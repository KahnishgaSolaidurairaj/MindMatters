import Foundation

enum PlantStage: Int, CaseIterable {
    case seed = 0
    case sprout
    case small
    case medium
    case large
    case blooming

    var label: String {
        switch self {
        case .seed: return "Seed"
        case .sprout: return "Sprout"
        case .small: return "Small Plant"
        case .medium: return "Medium Plant"
        case .large: return "Large Plant"
        case .blooming: return "Blooming"
        }
    }

    var assetName: String {
        switch self {
        case .seed: return "plant_seed"
        case .sprout: return "plant_sprout"
        case .small: return "plant_small"
        case .medium: return "plant_medium"
        case .large: return "plant_large"
        case .blooming: return "plant_blooming"
        }
    }
}

struct PlantState {
    var water: Int = 0
    var sunlight: Int = 0
    var fertilizer: Int = 0
    var streakDays: Int = 0
    var missedYesterday: Bool = false

    var stage: PlantStage {
        let total = water + sunlight + fertilizer
        switch total {
        case 0: return .seed
        case 1...2: return .sprout
        case 3...5: return .small
        case 6...9: return .medium
        case 10...13: return .large
        default: return .blooming
        }
    }

    var isWilted: Bool { missedYesterday }

    mutating func reward(for category: TaskCategory) {
        switch category {
        case .mentalHealth, .social:
            sunlight += 1
        case .finance, .academic:
            fertilizer += 1
        }
        water += 1
    }
}
