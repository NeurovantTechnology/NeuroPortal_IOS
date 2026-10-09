import Foundation

struct HubFeedItem: Identifiable {
    // Use the provider's persistent ID so refreshing the feed preserves view identity.
    let id: String
    let kind: Kind
    let source: String
    let title: String
    let summary: String
    let detail: String
    var dueAt: Date? = nil

    enum Kind {
        case email, calendar

        var symbol: String {
            switch self {
            case .email: return "envelope"
            case .calendar: return "calendar"
            }
        }
    }
}

enum HubFeedFilter: String, CaseIterable {
    case all = "All"
    case email = "Email"
    case calendar = "Calendar"

    func includes(_ item: HubFeedItem) -> Bool {
        switch self {
        case .all: return true
        case .email: return item.kind == .email
        case .calendar: return item.kind == .calendar
        }
    }
}
