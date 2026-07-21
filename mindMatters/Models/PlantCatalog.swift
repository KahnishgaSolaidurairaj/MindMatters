import Foundation

enum PlantKind: String, CaseIterable, Identifiable {
    case cactus
    case rose
    case sunflower
    case tulip

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .cactus: return "Cactus"
        case .rose: return "Rose"
        case .sunflower: return "Sunflower"
        case .tulip: return "Tulip"
        }
    }

    var description: String {
        switch self {
        case .cactus: return "Steady growth for academic goals"
        case .rose: return "Balanced care for financial habits"
        case .sunflower: return "Bright progress for social connection"
        case .tulip: return "Gentle growth for physical wellness"
        }
    }

    var maxGrowthImages: Int {
        switch self {
        case .cactus: return 6
        case .rose: return 7
        case .sunflower: return 6
        case .tulip: return 8
        }
    }

    /// Returns the asset catalog image name for a growth stage.
    func growthAssetName(for stage: PlantStage) -> String {
        let index = min(stage.growthImageIndex, maxGrowthImages)
        let suffix = String(format: "%02d", index)
        switch self {
        case .cactus: return "Cactus_Grow-\(suffix)"
        case .rose: return "Rose_Grow-\(suffix)"
        case .sunflower: return "Sunflower_Grow-\(suffix)"
        case .tulip: return "Tuplip_Grow-\(suffix)"
        }
    }

    /// Returns the wilted or neglected plant image when available.
    func wiltAssetName() -> String {
        switch self {
        case .sunflower: return "Sunflower_Dead"
        case .tulip: return "Tuplip_Wilt"
        case .cactus, .rose: return growthAssetName(for: .sprout)
        }
    }

    var previewAssetName: String {
        growthAssetName(for: .medium)
    }

    var defaultPotAssetName: String {
        switch self {
        case .cactus: return "A_Pot"
        case .rose: return "F_Pot"
        case .sunflower: return "S_Pot"
        case .tulip: return "P_Pot"
        }
    }
}

extension PlantStage {
    var growthImageIndex: Int {
        switch self {
        case .seed: return 1
        case .sprout: return 2
        case .small: return 3
        case .medium: return 4
        case .large: return 5
        case .blooming: return 6
        }
    }
}

struct GardenPlantProfile: Identifiable {
    let id = UUID()
    let name: String
    let category: String
    let kind: PlantKind
    let potAssetName: String
    let stage: PlantStage
    let progress: Int
}

enum GardenCatalog {
    static let plants: [GardenPlantProfile] = [
        GardenPlantProfile(
            name: "Academic Cactus",
            category: "Academic Growth",
            kind: .cactus,
            potAssetName: "A_Pot",
            stage: .large,
            progress: 82
        ),
        GardenPlantProfile(
            name: "Financial Rose",
            category: "Financial Growth",
            kind: .rose,
            potAssetName: "F_Pot",
            stage: .medium,
            progress: 68
        ),
        GardenPlantProfile(
            name: "Social Sunflower",
            category: "Social Growth",
            kind: .sunflower,
            potAssetName: "S_Pot",
            stage: .large,
            progress: 74
        ),
        GardenPlantProfile(
            name: "Fitness Tulip",
            category: "Physical Wellness",
            kind: .tulip,
            potAssetName: "P_Pot",
            stage: .medium,
            progress: 61
        ),
        GardenPlantProfile(
            name: "Mindful Bloom",
            category: "Mental Wellness",
            kind: .rose,
            potAssetName: "A_Pot",
            stage: .blooming,
            progress: 79
        ),
    ]

    static let backgroundAssets = [
        "greenhouse_assets-01",
        "greenhouse_assets-02",
        "greenhouse_assets-03",
        "greenhouse_assets-04",
        "greenhouse_assets-05",
    ]
}

enum MindMattersAssets {
    static let logo = "MM_Logo"
    static let logoCompact = "MM_Logo-14"
    static let myPlantsBanner = "my_plants_asset-07"
}
