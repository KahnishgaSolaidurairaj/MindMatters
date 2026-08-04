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
        weeklyStreakDescription
    }

    var weeklyStreakDescription: String {
        switch self {
        case .cactus: return "A steady weekly companion as your streak builds"
        case .rose: return "Blooms a little more each day you stay consistent"
        case .sunflower: return "Turns toward the sun with every day you show up"
        case .tulip: return "Opens up as your weekly streak grows"
        }
    }

    /// Emotional meaning shown during plant selection intake.
    var meaningText: String {
        switch self {
        case .cactus: return "Steady, resilient, low-maintenance growth"
        case .rose: return "Intentional care, blooming through consistency"
        case .sunflower: return "Turning toward light, social warmth"
        case .tulip: return "Opening up, physical wellness"
        }
    }

    /// Decorative pot for the weekly streak plant — not tied to category priorities.
    var streakPotAssetName: String { "A_Pot" }

    var maxGrowthImages: Int {
        switch self {
        case .cactus: return 6
        case .rose: return 7
        case .sunflower: return 6
        case .tulip: return 8
        }
    }

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

enum GardenPriority: String, CaseIterable, Identifiable {
    case academicGrowth = "Academic Growth"
    case financialGrowth = "Financial Growth"
    case socialGrowth = "Social Growth"
    case physicalWellness = "Physical Wellness"

    var id: String { rawValue }

    var potAssetName: String {
        switch self {
        case .academicGrowth: return "A_Pot"
        case .financialGrowth: return "F_Pot"
        case .socialGrowth: return "S_Pot"
        case .physicalWellness: return "P_Pot"
        }
    }

    var plantKind: PlantKind {
        switch self {
        case .academicGrowth: return .cactus
        case .financialGrowth: return .rose
        case .socialGrowth: return .sunflower
        case .physicalWellness: return .tulip
        }
    }

    var plantDisplayName: String {
        switch self {
        case .academicGrowth: return "Academic Cactus"
        case .financialGrowth: return "Financial Rose"
        case .socialGrowth: return "Social Sunflower"
        case .physicalWellness: return "Fitness Tulip"
        }
    }

    static func from(taskCategory: TaskCategory) -> GardenPriority {
        switch taskCategory {
        case .academic: return .academicGrowth
        case .financial: return .financialGrowth
        case .social: return .socialGrowth
        case .physical: return .physicalWellness
        }
    }
}

struct GardenPlantProfile: Identifiable {
    let id: GardenPriority
    let name: String
    let category: String
    let kind: PlantKind
    let potAssetName: String
    let stage: PlantStage
    let progress: Int

    init(priority: GardenPriority, kind: PlantKind, stage: PlantStage, progress: Int) {
        id = priority
        self.kind = kind
        name = kind.displayName
        category = priority.rawValue
        potAssetName = priority.potAssetName
        self.stage = stage
        self.progress = progress
    }
}

enum GardenCatalog {
    /// Dead or untended plants — shown when plant health is 50% or lower.
    static let neglectedGreenhouse = "greenhouse_assets-01"
    /// First stage of growth.
    static let firstGrowthGreenhouse = "greenhouse_assets-02"
    /// Thriving, flourishing growth.
    static let flourishingGreenhouse = "greenhouse_assets-03"
    /// Second stage of growth.
    static let secondGrowthGreenhouse = "greenhouse_assets-04"
    /// Seed start — little or no garden activity yet.
    static let seedGreenhouse = "greenhouse_assets-05"

    static let starterGreenhouse = seedGreenhouse
    static let strugglingGreenhouse = neglectedGreenhouse
    static let earlyStreakGreenhouse = firstGrowthGreenhouse
    static let growingGreenhouse = secondGrowthGreenhouse
}

enum MindMattersAssets {
    /// Transparent-background plant icon for in-app use.
    static let logo = "MM_Logo"
    static let logoCompact = "MM_Logo"
    static let myPlantsBanner = "my_plants_asset-07"
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

    static func from(progressPercentage: Int) -> PlantStage {
        switch progressPercentage {
        case 0: return .seed
        case 1...15: return .sprout
        case 16...35: return .small
        case 36...55: return .medium
        case 56...75: return .large
        default: return .blooming
        }
    }

    /// Maps consecutive streak days to a growth stage over a 7-day weekly cycle.
    static func fromWeeklyStreakDays(_ days: Int, goal: Int = 7) -> PlantStage {
        guard goal > 0 else { return .seed }
        let progress = min(days * 100 / goal, 100)
        return from(progressPercentage: progress)
    }
}
