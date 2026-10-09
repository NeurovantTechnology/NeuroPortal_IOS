import SwiftUI

struct HubView: View {
    let overview: DailyOverviewCard
    let items: [HubFeedItem]

    @State private var filter: HubFeedFilter = .all
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    private var visibleItems: [HubFeedItem] {
        items.filter { filter.includes($0) }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                overview

                Text("In focus")
                    .font(.title2.bold())
                    .accessibilityAddTraits(.isHeader)
                    .padding(.top, 8)

                if visibleItems.isEmpty {
                    emptyFeed
                } else {
                    ForEach(visibleItems) { item in
                        HubCard(
                            symbol: item.kind.symbol,
                            source: item.source,
                            title: item.title,
                            summary: item.summary,
                            detail: item.detail,
                            dueAt: item.dueAt
                        )
                        .transition(.opacity)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: 680)
            .frame(maxWidth: .infinity)
        }
        .background(colorScheme == .dark ? BlackDynamic.background_app : BlackDynamic.background_light)
        .navigationTitle("Your hub")
        .safeAreaInset(edge: .bottom, spacing: 0) {
            filterBar
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private var emptyFeed: some View {
        if #available(iOS 17, *) {
            ContentUnavailableView(
                "Nothing here yet",
                systemImage: "tray",
                description: Text("Items from your connected sources will appear here. Try another filter.")
            )
        } else {
            VStack(spacing: 12) {
                Image(systemName: "tray")
                    .font(.largeTitle)
                    .accessibilityHidden(true)
                Text("Nothing here yet").font(.headline)
                Text("Items from your connected sources will appear here. Try another filter.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .accessibilityElement(children: .combine)
        }
    }

    @ViewBuilder
    private var filterBar: some View {
        if #available(iOS 26, *), !reduceTransparency {
            GlassEffectContainer(spacing: 12) {
                adaptiveFilters
            }
        } else {
            adaptiveFilters
                .padding(8)
                .background {
                    if reduceTransparency {
                        RoundedRectangle(cornerRadius: BlackDynamic.cardRadius)
                            .fill(colorScheme == .dark ? BlackDynamic.background_raised : .white)
                    } else {
                        RoundedRectangle(cornerRadius: BlackDynamic.cardRadius)
                            .fill(.regularMaterial)
                    }
                }
        }
    }

    private var adaptiveFilters: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 12) {
                ForEach(HubFeedFilter.allCases, id: \.self) { option in
                    filterButton(option)
                }
            }
            .fixedSize(horizontal: true, vertical: false)

            Menu {
                ForEach(HubFeedFilter.allCases, id: \.self) { option in
                    Button {
                        select(option)
                    } label: {
                        if filter == option {
                            Label(option.rawValue, systemImage: "checkmark")
                        } else {
                            Text(option.rawValue)
                        }
                    }
                }
            } label: {
                let label = Label("Filter: \(filter.rawValue)", systemImage: "line.3.horizontal.decrease")
                    .font(.body)
                    .padding(.horizontal, 16)
                    .frame(minWidth: 44, minHeight: 44)
                    .fixedSize(horizontal: false, vertical: true)
                if #available(iOS 26, *), !reduceTransparency {
                    label.glassEffect(.regular.interactive(), in: .capsule)
                } else {
                    label
                }
            }
            .accessibilityHint("Choose all items, email, or calendar")
        }
        .tint(BlackDynamic.accent_primary)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Feed filters")
    }

    @ViewBuilder
    private func filterButton(_ option: HubFeedFilter) -> some View {
        if #available(iOS 26, *), !reduceTransparency {
            if filter == option {
                filterControl(option).buttonStyle(.glassProminent)
            } else {
                filterControl(option).buttonStyle(.glass)
            }
        } else if filter == option {
            filterControl(option).buttonStyle(.borderedProminent)
        } else {
            filterControl(option).buttonStyle(.bordered)
        }
    }

    private func filterControl(_ option: HubFeedFilter) -> some View {
        Button {
            select(option)
        } label: {
            Text(option.rawValue)
                .font(.body.weight(.medium))
                .padding(.horizontal, 8)
                .frame(minWidth: 44, minHeight: 44)
        }
        .buttonBorderShape(.capsule)
        .accessibilityAddTraits(filter == option ? .isSelected : [])
        .accessibilityHint("Show \(option.rawValue.lowercased()) items")
    }

    private func select(_ option: HubFeedFilter) {
        withAnimation(reduceMotion ? nil : .spring(response: 0.35, dampingFraction: 0.85)) {
            filter = option
        }
    }
}
