"""Check actual brand and urgency tokens: python Tests/ContrastCheck.py."""
from pathlib import Path
import re

source = (Path(__file__).resolve().parents[1] / "Components/HubCards.swift").read_text(encoding="utf-8")
palette = {
    name: tuple(int(channel) / 255 for channel in channels)
    for name, *channels in re.findall(
        r"static let (\w+) = Color\(\.sRGB, red: (\d+) / 255, green: (\d+) / 255, blue: (\d+) / 255\)", source
    )
}
palette["white"] = (1, 1, 1)


def luminance(color):
    channels = [v / 12.92 if v <= 0.04045 else ((v + 0.055) / 1.055) ** 2.4 for v in color]
    return sum(v * weight for v, weight in zip(channels, (0.2126, 0.7152, 0.0722)))


def contrast(foreground, background):
    lighter, darker = sorted((luminance(foreground), luminance(background)), reverse=True)
    return (lighter + 0.05) / (darker + 0.05)


assert abs(contrast((1, 1, 1), (0, 0, 0)) - 21) < 0.001
for foreground, backgrounds in (
    ("status_urgent", ("background_card",)),
    ("status_warning", ("background_card", "background_accent")),
    ("text_accent", ("background_accent",)),
    ("urgent_light", ("white",)),
    ("warning_light", ("white",)),
    ("accent_primary", ("white",)),
    ("white", ("accent_primary",)),
):
    for background in backgrounds:
        ratio = contrast(palette[foreground], palette[background])
        assert ratio >= 4.5, f"{foreground} on {background}: {ratio:.2f}:1"
        print(f"{foreground} on {background}: {ratio:.2f}:1")

# Check the strongest point of the overview's purple wash as well as its base.
wash_opacity = float(re.search(r"colors: \[BlackDynamic.accent_primary.opacity\(([\d.]+)\)", source).group(1))
for background, foregrounds in (
    (palette["white"], ("warning_light", "accent_primary")),
    (palette["background_accent"], ("status_warning", "text_accent")),
):
    washed = tuple(wash_opacity * accent + (1 - wash_opacity) * base for accent, base in zip(palette["accent_primary"], background))
    for foreground in foregrounds:
        ratio = contrast(palette[foreground], washed)
        assert ratio >= 4.5, f"{foreground} on overview wash: {ratio:.2f}:1"
print("Brand and urgency text contrast checks passed (minimum 4.5:1).")
