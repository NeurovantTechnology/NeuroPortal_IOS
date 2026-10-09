import Foundation

// Compile with Models/HubFeedItem.swift, then run the resulting executable.
@main
struct HubFeedCheck {
    static func main() {
        let items = [
            HubFeedItem(id: "email:1", kind: .email, source: "Maya", title: "Estimate", summary: "", detail: ""),
            HubFeedItem(id: "calendar:1", kind: .calendar, source: "Work", title: "Review", summary: "", detail: ""),
            HubFeedItem(id: "email:2", kind: .email, source: "Alex", title: "Update", summary: "", detail: "")
        ]
        assert(items.filter { HubFeedFilter.all.includes($0) }.map(\.id) == items.map(\.id))
        assert(items.filter { HubFeedFilter.email.includes($0) }.map(\.id) == ["email:1", "email:2"])
        assert(items.filter { HubFeedFilter.calendar.includes($0) }.map(\.id) == ["calendar:1"])
        assert([items[1]].filter { HubFeedFilter.email.includes($0) }.isEmpty)
        assert(Set(items.map(\.id)).count == items.count)
        print("Hub filter, identity, empty-result, and ordering checks passed.")
    }
}
