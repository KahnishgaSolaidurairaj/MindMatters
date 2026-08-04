import SwiftUI

/// Shop for spending Bloom Points on cosmetics, rare plants, garden beds, and level-ups.
struct RewardsShopView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedCategory: RewardCategory = .cosmetics
    @State private var purchaseMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                currencyHeader
                categoryPicker

                if !purchaseMessage.isEmpty {
                    Text(purchaseMessage)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.teal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                ForEach(filteredItems) { item in
                    shopItemRow(item)
                }

                if selectedCategory == .gardenBeds {
                    transplantSection
                }
            }
            .padding()
        }
    }

    private var currencyHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                Image(systemName: BloomCurrency.icon)
                    .font(.title2)
                    .foregroundStyle(Theme.teal)

                VStack(alignment: .leading, spacing: 2) {
                    Text("\(appState.energyPoints)")
                        .font(Theme.pageTitle)
                        .foregroundStyle(Theme.teal)
                    Text(BloomCurrency.displayName)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                }

                Spacer()
            }

            HStack(spacing: 8) {
                statTile(
                    value: "Lv. \(appState.potLevel)",
                    label: "Pot",
                    icon: "cup.and.saucer.fill"
                )
                statTile(
                    value: "Lv. \(appState.plantLevel)",
                    label: "Plant",
                    icon: "leaf.fill"
                )
                statTile(
                    value: "\(appState.unlockedGardenBeds)",
                    label: "Beds",
                    icon: "square.grid.2x2"
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func statTile(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(Theme.teal)

            Text(value)
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)
                .wrapping(.center)

            Text(label)
                .font(Theme.supportingText)
                .foregroundStyle(Theme.textDark.opacity(0.6))
                .wrapping(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(Theme.sage.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(RewardCategory.allCases) { category in
                    SelectableCapsuleButton(
                        category.rawValue,
                        isSelected: selectedCategory == category,
                        cornerRadius: 20
                    ) {
                        selectedCategory = category
                        purchaseMessage = ""
                    }
                    .frame(minWidth: 110)
                }
            }
        }
    }

    private var filteredItems: [ShopItem] {
        RewardsCatalog.shopItems.filter { $0.category == selectedCategory }
    }

    private var transplantSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            if appState.canTransplantCurrentPlant {
                PrimaryCapsuleButton(title: "Transplant \(appState.selectedPlantKind.displayName)", isEnabled: true) {
                    if appState.transplantCurrentPlant() {
                        purchaseMessage = "\(appState.selectedPlantKind.displayName) transplanted!"
                    }
                }
            }

            if !appState.transplantedPlants.isEmpty {
                ForEach(appState.transplantedPlants) { plant in
                    Label("Bed \(plant.bedIndex + 1): \(plant.name)", systemImage: "leaf.fill")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.8))
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func shopItemRow(_ item: ShopItem) -> some View {
        let owned = appState.ownsShopItem(item)
        let canAfford = appState.energyPoints >= item.cost
        let meetsLevel = appState.plantLevel >= item.requiredPlantLevel

        return VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Image(systemName: item.icon)
                    .font(.title2)
                    .foregroundStyle(Theme.teal)
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(Theme.rowTitle)
                        .foregroundStyle(Theme.textDark)
                        .wrapping()
                    Text(item.detail)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                        .wrapping()
                    if item.requiredPlantLevel > 1 {
                        Text("Plant Lv. \(item.requiredPlantLevel)+")
                            .font(Theme.supportingText)
                            .foregroundStyle(meetsLevel ? Theme.teal : .orange)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                Label("\(item.cost)", systemImage: BloomCurrency.icon)
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(canAfford ? Theme.teal : Theme.textDark.opacity(0.4))
            }

            if owned {
                Label(item.category == .upgrades ? "Max Level" : "Owned", systemImage: "checkmark.circle.fill")
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(.green)
            } else {
                PrimaryCapsuleButton(
                    title: item.category == .upgrades ? "Level Up · \(item.cost)" : "Unlock · \(item.cost)",
                    isEnabled: canAfford && meetsLevel
                ) {
                    purchaseMessage = appState.purchaseShopItem(item)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    RewardsShopView()
        .environmentObject(AppState())
}
