import SwiftUI

// Original Black Dynamic palette plus accessible light-mode urgency colors.
enum BlackDynamic {
    static let background_app = Color(.sRGB, red: 9 / 255, green: 9 / 255, blue: 13 / 255)
    static let background_card = Color(.sRGB, red: 21 / 255, green: 21 / 255, blue: 28 / 255)
    static let background_raised = Color(.sRGB, red: 32 / 255, green: 32 / 255, blue: 41 / 255)
    static let background_accent = Color(.sRGB, red: 33 / 255, green: 27 / 255, blue: 50 / 255)
    static let text_primary = Color(.sRGB, red: 245 / 255, green: 245 / 255, blue: 250 / 255)
    static let text_secondary = Color(.sRGB, red: 171 / 255, green: 171 / 255, blue: 185 / 255)
    static let text_accent = Color(.sRGB, red: 200 / 255, green: 181 / 255, blue: 255 / 255)
    static let text_onAccent = Color.white
    static let accent_primary = Color(.sRGB, red: 120 / 255, green: 84 / 255, blue: 214 / 255)
    static let border_default = Color(.sRGB, red: 48 / 255, green: 48 / 255, blue: 60 / 255)
    static let status_urgent = Color(.sRGB, red: 255 / 255, green: 138 / 255, blue: 138 / 255)
    static let status_warning = Color(.sRGB, red: 242 / 255, green: 190 / 255, blue: 117 / 255)
    static let status_positive = Color(.sRGB, red: 154 / 255, green: 218 / 255, blue: 187 / 255)
    static let background_light = Color(.sRGB, red: 246 / 255, green: 245 / 255, blue: 250 / 255)
    static let urgent_light = Color(.sRGB, red: 176 / 255, green: 36 / 255, blue: 48 / 255)
    static let warning_light = Color(.sRGB, red: 135 / 255, green: 77 / 255, blue: 12 / 255)
    static let cardRadius: CGFloat = 20
    static let controlRadius: CGFloat = 14
    static let pillRadius: CGFloat = 99
}

// PriorityCard, EventCard, and SummaryCard share this layout.
// Detail must communicate urgency in words as well as color.
struct HubCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.colorSchemeContrast) private var contrast

    let symbol: String
    let source: String
    let title: String
    let summary: String
    let detail: String
    var accent: Color = .primary
    var dueAt: Date? = nil

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            card(tint: FeedUrgency.classify(dueAt: dueAt, now: context.date).tint(regular: accent, scheme: colorScheme))
        }
    }

    private func card(tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: symbol)
                    .font(.body)
                    .padding(10)
                    .background(tint.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                    .accessibilityHidden(true)
                Text(source)
                    .font(.subheadline.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.vertical, 10)
            }
            .foregroundStyle(tint)

            Text(title)
                .font(.title3.bold())
                .foregroundStyle(tint)
            Text(summary)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
            Text(detail)
                .font(.footnote.weight(.medium))
                .foregroundStyle(tint)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(colorScheme == .dark ? BlackDynamic.background_card : .white)
        .clipShape(RoundedRectangle(cornerRadius: BlackDynamic.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: BlackDynamic.cardRadius)
                .strokeBorder(tint.opacity(contrast == .increased ? 0.65 : 0.2), lineWidth: 1)
        }
        .shadow(color: .black.opacity(colorScheme == .dark ? 0.12 : 0.04), radius: 12, y: 5)
        .accessibilityElement(children: .combine)
    }
}

private extension FeedUrgency {
    func tint(regular: Color, scheme: ColorScheme) -> Color {
        switch self {
        case .soon: return scheme == .dark ? BlackDynamic.status_urgent : BlackDynamic.urgent_light
        case .upcoming: return scheme == .dark ? BlackDynamic.status_warning : BlackDynamic.warning_light
        case .regular: return regular
        }
    }
}

struct DailyOverviewCard: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(\.colorSchemeContrast) private var contrast

    let title: String
    let summary: String
    let eventCount: Int
    let deadlineCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .accessibilityHidden(true)
                Text("Your day, at a glance")
                    .font(.subheadline.weight(.semibold))
            }
            .foregroundStyle(colorScheme == .dark ? BlackDynamic.text_accent : BlackDynamic.accent_primary)

            Text(title)
                .font(.title2.bold())
                .foregroundStyle(.primary)
            Text(summary)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(3)
            let layout = dynamicTypeSize.isAccessibilitySize
                ? AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
                : AnyLayout(HStackLayout(alignment: .top, spacing: 20))
            layout {
                Label("\(eventCount) events", systemImage: "calendar")
                    .foregroundStyle(.primary)
                Label("\(deadlineCount) due today", systemImage: "clock")
                    .foregroundStyle(colorScheme == .dark ? BlackDynamic.status_warning : BlackDynamic.warning_light)
            }
            .font(.footnote.weight(.medium))
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background {
            RoundedRectangle(cornerRadius: BlackDynamic.cardRadius)
                .fill(LinearGradient(
                    colors: [BlackDynamic.accent_primary.opacity(0.08), .clear],
                    startPoint: .topLeading, endPoint: .bottomTrailing
                ))
        }
        .background(colorScheme == .dark ? BlackDynamic.background_accent : .white)
        .clipShape(RoundedRectangle(cornerRadius: BlackDynamic.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: BlackDynamic.cardRadius)
                .strokeBorder(BlackDynamic.accent_primary.opacity(contrast == .increased ? 0.7 : 0.25), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

struct HubCards_Previews: PreviewProvider {
    static var previews: some View {
        specimens
            .previewDisplayName("Black Dynamic / Default")
        specimens
            .environment(\.dynamicTypeSize, .accessibility5)
            .previewDisplayName("Black Dynamic / Accessibility text")
    }

    private static var specimens: some View {
        ScrollView {
            VStack(spacing: 12) {
                DailyOverviewCard(
                    title: "A little focus. A clear day.",
                    summary: "1 deadline · Next event at 10:30",
                    eventCount: 3,
                    deadlineCount: 1
                )
                HubCard(
                    symbol: "envelope", source: "EMAIL · MAYA",
                    title: "Send the project estimate",
                    summary: "Maya needs your updated estimate by 5 PM.",
                    detail: "Due today · 5:00 PM",
                    dueAt: Date().addingTimeInterval(8 * 60 * 60)
                )
                HubCard(
                    symbol: "calendar", source: "CALENDAR · WORK",
                    title: "Design review",
                    summary: "10:30–11:00 AM · Conference room B",
                    detail: "Starts in 30 min",
                    accent: BlackDynamic.text_accent,
                    dueAt: Date().addingTimeInterval(30 * 60)
                )
                HubCard(
                    symbol: "envelope", source: "EMAIL · ALEX",
                    title: "Weekly team update",
                    summary: "3 decisions and next week’s milestones, summarized.",
                    detail: "Received 8:42 AM"
                )
            }
            .padding(24)
        }
        .background(BlackDynamic.background_app)
        .preferredColorScheme(.dark)
        .previewLayout(.fixed(width: 393, height: 852))
    }
}
