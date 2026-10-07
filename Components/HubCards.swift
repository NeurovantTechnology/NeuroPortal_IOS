import SwiftUI

// Matches the NP / Black Dynamic variables in Figma.
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
    static let cardRadius: CGFloat = 20
    static let controlRadius: CGFloat = 14
    static let pillRadius: CGFloat = 99
}

// PriorityCard, EventCard, and SummaryCard share this layout.
// Detail must communicate urgency in words as well as color.
struct HubCard: View {
    let symbol: String
    let source: String
    let title: String
    let summary: String
    let detail: String
    var accent: Color = BlackDynamic.text_primary
    var dueAt: Date? = nil

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { context in
            card(tint: FeedUrgency.classify(dueAt: dueAt, now: context.date).tint(regular: accent))
        }
    }

    private func card(tint: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: symbol)
                    .accessibilityHidden(true)
                Text(source)
                    .font(.caption2.weight(.semibold))
            }
            .foregroundStyle(tint)

            Text(title)
                .font(.headline)
                .foregroundStyle(tint)
            Text(summary)
                .font(.subheadline)
                .foregroundStyle(BlackDynamic.text_secondary)
            Text(detail)
                .font(.footnote.weight(.medium))
                .foregroundStyle(tint)
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(BlackDynamic.background_card)
        .clipShape(RoundedRectangle(cornerRadius: BlackDynamic.cardRadius))
        .overlay {
            RoundedRectangle(cornerRadius: BlackDynamic.cardRadius)
                .strokeBorder(tint.opacity(0.35), lineWidth: 1)
        }
        .accessibilityElement(children: .combine)
    }
}

private extension FeedUrgency {
    func tint(regular: Color) -> Color {
        switch self {
        case .soon: return BlackDynamic.status_urgent
        case .upcoming: return BlackDynamic.status_warning
        case .regular: return regular
        }
    }
}

struct DailyOverviewCard: View {
    let title: String
    let summary: String
    let eventCount: Int
    let deadlineCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "sparkles")
                    .accessibilityHidden(true)
                Text("YOUR DAY, AT A GLANCE")
                    .font(.caption2.weight(.semibold))
            }
            .foregroundStyle(BlackDynamic.text_accent)

            Text(title)
                .font(.headline)
                .foregroundStyle(BlackDynamic.text_primary)
            Text(summary)
                .font(.subheadline)
                .foregroundStyle(BlackDynamic.text_secondary)
            HStack(spacing: 24) {
                Text("\(eventCount) events")
                    .foregroundStyle(BlackDynamic.text_primary)
                Text("\(deadlineCount) due today")
                    .foregroundStyle(BlackDynamic.status_warning)
            }
            .font(.footnote.weight(.medium))
        }
        .fixedSize(horizontal: false, vertical: true)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(BlackDynamic.background_accent)
        .clipShape(RoundedRectangle(cornerRadius: BlackDynamic.cardRadius))
        .accessibilityElement(children: .combine)
    }
}

struct HubCards_Previews: PreviewProvider {
    static var previews: some View {
        specimens
            .previewDisplayName("Black Dynamic / Default")
        specimens
            .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
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
