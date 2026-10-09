import SwiftUI

struct HubView_Previews: PreviewProvider {
    static var previews: some View {
        specimen
            .preferredColorScheme(.dark)
            .previewDisplayName("Hub / Dark")
        specimen
            .preferredColorScheme(.light)
            .previewDisplayName("Hub / Light")
        specimen
            .preferredColorScheme(.dark)
            .environment(\.dynamicTypeSize, .accessibility5)
            .previewLayout(.fixed(width: 320, height: 700))
            .previewDisplayName("Hub / Large text, narrow width")
        specimen
            .preferredColorScheme(.light)
            .environment(\.colorSchemeContrast, .increased)
            .environment(\.accessibilityReduceTransparency, true)
            .environment(\.accessibilityReduceMotion, true)
            .previewDisplayName("Hub / Accessibility settings")
        specimen
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 1024, height: 768))
            .previewDisplayName("Hub / iPad")
        NavigationStack {
            HubView(
                overview: DailyOverviewCard(title: "A fresh start.", summary: "Your connected sources will appear here.", eventCount: 0, deadlineCount: 0),
                items: []
            )
        }
        .previewDisplayName("Hub / Empty")
    }

    private static var specimen: some View {
        NavigationStack {
            HubView(
                overview: DailyOverviewCard(
                    title: "A little focus. A clear day.",
                    summary: "One deadline to take care of. Your next event is a design review.",
                    eventCount: 3,
                    deadlineCount: 1
                ),
                items: [
                    HubFeedItem(
                        id: "email:estimate", kind: .email, source: "Email · Maya",
                        title: "Send the project estimate",
                        summary: "Maya needs your updated estimate by 5 PM.",
                        detail: "Due today · 5:00 PM",
                        dueAt: Date().addingTimeInterval(8 * 60 * 60)
                    ),
                    HubFeedItem(
                        id: "calendar:review", kind: .calendar, source: "Calendar · Work",
                        title: "Design review",
                        summary: "Conference room B · 30 minutes",
                        detail: "Starts in 30 minutes",
                        dueAt: Date().addingTimeInterval(30 * 60)
                    ),
                    HubFeedItem(
                        id: "email:update", kind: .email, source: "Email · Alex",
                        title: "Weekly team update",
                        summary: "Three decisions and next week's milestones, summarized.",
                        detail: "Received this morning"
                    )
                ]
            )
        }
        .previewLayout(.fixed(width: 393, height: 852))
    }
}
