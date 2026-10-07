import Foundation

// Run: swiftc Components/FeedUrgency.swift Tests/FeedUrgencyCheck.swift -o /tmp/feed-urgency-check && /tmp/feed-urgency-check
@main
struct FeedUrgencyCheck {
    static func main() {
        let now = Date(timeIntervalSince1970: 1_000_000)
        assert(FeedUrgency.classify(dueAt: nil, now: now) == .regular)
        let cases: [(TimeInterval, FeedUrgency)] = [
            (-60, .soon), (0, .soon), (1800, .soon), (3600, .soon),
            (3601, .upcoming), (86400, .upcoming), (86401, .regular)
        ]
        for (seconds, expected) in cases {
            assert(FeedUrgency.classify(dueAt: now.addingTimeInterval(seconds), now: now) == expected)
        }
        let deadline = now.addingTimeInterval(25 * 60 * 60)
        assert(FeedUrgency.classify(dueAt: deadline, now: now) == .regular)
        assert(FeedUrgency.classify(dueAt: deadline, now: now.addingTimeInterval(60 * 60)) == .upcoming)
        assert(FeedUrgency.classify(dueAt: deadline, now: now.addingTimeInterval(24 * 60 * 60)) == .soon)
        print("Feed urgency boundary and clock-advance checks passed.")
    }
}
