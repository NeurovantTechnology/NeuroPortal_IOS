# NeuroPortal — Black Dynamic

[Editable Figma design](https://www.figma.com/design/UIde8BGhSWliAsRp5C4mbA?node-id=3-48)

[Start the prototype](https://www.figma.com/proto/UIde8BGhSWliAsRp5C4mbA?node-id=3-49&starting-point-node-id=3%3A49)

For the current SwiftUI layout, accessibility behavior, and integration steps,
see [SwiftUI refinement](SwiftUI-Refinement.md). The design dimensions and colors
below describe the original Figma pass; SwiftUI now includes a hub screen,
larger card typography, adaptive light mode, and native glass controls.

Completed in Figma:

- Dark theme with scoped color, spacing, and radius variables; SF Pro text styles.
- Reusable PriorityCard, EventCard, SummaryCard, and DailyOverviewCard.
- LoginView with Apple, Google, email, and phone choices.
- HubView with daily overview and priority-ordered email/calendar feed.
- SettingsView with source status, preferences, account/support, and sign-out.
- Sign-in → hub, hub ↔ settings, and sign-out → login prototype links.

Screens use 393 × 852 frames, 24-point content margins, 16-point card padding,
20-point card corners, and 8/12/20/24-point layout gaps. Hub and settings content
scroll above the persistent navigation. Source labels and deadline text convey
meaning independently of accent color.

Feed urgency uses the item's deadline or event start date:

- Red (`#FF8A8A`): overdue or within 1 hour, including exactly 1 hour.
- Orange (`#F2BE75`): more than 1 hour and within 24 hours, including exactly 24 hours.
- White or the caller's purple accent: more than 24 hours away, or no date.

The SF Symbol, source label, title, detail, and border adopt the urgency color.
Summary text keeps its readable neutral color. `HubCard(dueAt: ...)` recalculates
every minute through `TimelineView`; completed items should leave the active feed.
Figma shows the upcoming event in red, the later deadline in orange, and the
undated summary in white. Demo profile: Tom Harris, `tomharris@neourobant.com`.

`Components/HubCards.swift` supplies the matching reusable SwiftUI layouts and
theme. The three feed card designs use one `HubCard` with different content,
SF Symbol, and accent. `DailyOverviewCard` accepts summary and count inputs.
Both support content growth, Dynamic Type, and grouped VoiceOver reading.
Open the included default and accessibility previews in an iOS 16+ Xcode target.

The Figma prototype simulates successful authentication and uses sample content.
Screen SwiftUI implementations, authentication forms/services, provider setup,
source connections, and settings detail screens remain integration work.
Text integration is intentionally shown as not connected, following the brief.

Validation: inspected the original screen and card screenshots, verified navigation
targets and editable component instances, and checked text contrast and sizing.
The urgency/profile update saved successfully and passed red/orange text contrast
checks; Figma's Starter call limit blocked its final screenshot check.
SwiftUI cannot be compiled in this Windows workspace; Xcode validation remains.
The Foundation-only urgency check covers missing dates, overdue dates, exact
boundaries, and color progression as the clock advances. On macOS run:

```sh
swiftc Components/FeedUrgency.swift Tests/FeedUrgencyCheck.swift -o /tmp/feed-urgency-check
/tmp/feed-urgency-check
```
