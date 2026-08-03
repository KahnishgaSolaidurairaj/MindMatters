import Foundation

// MARK: - Currency

/// Spendable currency earned from tasks and streak bonuses (shown as ⚡ Bloom Points).
/// Separate from streak badges and growth milestones, which are one-time unlocks.
enum BloomCurrency {
    static let displayName = "Bloom Points"
    static let icon = "bolt.fill"
}

// MARK: - Shop Categories

enum RewardCategory: String, CaseIterable, Identifiable {
    case cosmetics = "Cosmetics"
    case plants = "Rare Plants"
    case gardenBeds = "Garden Beds"
    case upgrades = "Level Ups"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .cosmetics: return "sparkles"
        case .plants: return "leaf.fill"
        case .gardenBeds: return "square.grid.2x2.fill"
        case .upgrades: return "arrow.up.circle.fill"
        }
    }

    var detail: String {
        switch self {
        case .cosmetics: return "Profile frames, pins, and decorative pots"
        case .plants: return "Unlock rarer species for your garden"
        case .gardenBeds: return "Transplant mature plants to permanent beds"
        case .upgrades: return "Level up your pots and plants"
        }
    }
}

enum CosmeticKind: String, Hashable {
    case profileFrame
    case pin
    case pot
}

struct ShopItem: Identifiable, Hashable {
    let id: String
    let name: String
    let detail: String
    let category: RewardCategory
    let cost: Int
    let icon: String
    var cosmeticKind: CosmeticKind?
    var requiredPlantLevel: Int = 1
}

struct TransplantedPlant: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let kind: PlantKind
    let bedIndex: Int
    let transplantedAt: Date
}

enum RewardsCatalog {
    static let shopItems: [ShopItem] = [
        ShopItem(id: "frame_golden_vine", name: "Golden Vine Frame", detail: "Profile frame with winding vine border.", category: .cosmetics, cost: 50, icon: "person.crop.circle.badge.checkmark", cosmeticKind: .profileFrame),
        ShopItem(id: "pin_sprout", name: "Sprout Pin", detail: "Wear a tiny sprout on your profile.", category: .cosmetics, cost: 30, icon: "pin.fill", cosmeticKind: .pin),
        ShopItem(id: "pot_ceramic_blue", name: "Ceramic Blue Pot", detail: "Cool-toned pot for your weekly plant.", category: .cosmetics, cost: 75, icon: "cup.and.saucer.fill", cosmeticKind: .pot),
        ShopItem(id: "pot_terracotta", name: "Terracotta Pot", detail: "Warm classic pot style.", category: .cosmetics, cost: 40, icon: "flowerpot.fill", cosmeticKind: .pot),

        ShopItem(id: "plant_lavender", name: "Lavender", detail: "A calming rare species.", category: .plants, cost: 150, icon: "leaf.fill", requiredPlantLevel: 1),
        ShopItem(id: "plant_orchid", name: "Orchid", detail: "An elegant higher-level plant.", category: .plants, cost: 200, icon: "leaf.circle.fill", requiredPlantLevel: 2),
        ShopItem(id: "plant_bonsai", name: "Bonsai", detail: "A rare, patient-grower species.", category: .plants, cost: 250, icon: "tree.fill", requiredPlantLevel: 3),

        ShopItem(id: "bed_second", name: "Second Flower Bed", detail: "Transplant a mature plant to a permanent bed.", category: .gardenBeds, cost: 100, icon: "square.grid.2x2"),
        ShopItem(id: "bed_third", name: "Third Flower Bed", detail: "Expand your permanent garden display.", category: .gardenBeds, cost: 200, icon: "square.grid.3x3.fill"),

        ShopItem(id: "upgrade_pot", name: "Pot Level Up", detail: "Upgrade your pot tier for richer visuals.", category: .upgrades, cost: 80, icon: "arrow.up.circle"),
        ShopItem(id: "upgrade_plant", name: "Plant Level Up", detail: "Raise plant level to unlock rarer species.", category: .upgrades, cost: 120, icon: "chart.line.uptrend.xyaxis"),
    ]

    static let potLevelCost = 80
    static let plantLevelCost = 120
    static let maxPotLevel = 5
    static let maxPlantLevel = 5
}
