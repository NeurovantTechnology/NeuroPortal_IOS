import Foundation

enum FeedUrgency: Equatable {
    case soon, upcoming, regular

    static func classify(dueAt: Date?, now: Date) -> FeedUrgency {
        guard let dueAt else { return .regular }
        let remaining = dueAt.timeIntervalSince(now)
        if remaining <= 60 * 60 { return .soon }
        if remaining <= 24 * 60 * 60 { return .upcoming }
        return .regular
    }
}
