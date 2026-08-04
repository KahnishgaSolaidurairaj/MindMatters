import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable {
    case social = "Social"
    case academic = "Academic"
    case financial = "Financial"
    case physical = "Physical"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .social: return "person.2.fill"
        case .academic: return "book.fill"
        case .financial: return "dollarsign.circle.fill"
        case .physical: return "figure.run"
        }
    }

    var tint: Color {
        switch self {
        case .social: return .orange
        case .academic: return .blue
        case .financial: return .green
        case .physical: return .red
        }
    }

    /// Label shown in task lists and matched to garden priority pots.
    var priorityLabel: String {
        GardenPriority.from(taskCategory: self).rawValue
    }

    /// UIC campus resource link for this category.
    var resourceURL: URL? {
        switch self {
        case .social: return URL(string: "https://involvement.uic.edu")
        case .academic: return URL(string: "https://www.uic.edu/academics/academic-support")
        case .financial: return URL(string: "https://financialaid.uic.edu")
        case .physical: return URL(string: "https://campusrec.uic.edu")
        }
    }

    var resourceLinkTitle: String {
        switch self {
        case .social: return "UIC Student Involvement"
        case .academic: return "UIC Academic Support"
        case .financial: return "UIC Financial Aid & Wellness"
        case .physical: return "UIC Campus Recreation"
        }
    }
}

enum SocialStyle: String {
    case introverted
    case extroverted
    case neutral
}

/// User's 1–5 ranking for a task category during intake.
struct CategoryPreference: Identifiable, Hashable {
    let category: TaskCategory
    var rank: Int = 3

    var id: String { category.id }

    /// Weight used when recommending daily tasks.
    var combinedScore: Int { rank }

    /// Builds category preferences from specific task intake responses.
    static func from(responses: [IntakeTaskResponse]) -> [CategoryPreference] {
        var scores: [TaskCategory: [Int]] = [:]

        for response in responses {
            guard !response.skipped, let rank = response.rank else { continue }
            scores[response.task.category, default: []].append(rank)
            for (category, weight) in response.task.effectiveWeights where category != response.task.category {
                let weightedRank = max(1, min(5, Int(Double(rank) * Double(weight) / 100.0)))
                scores[category, default: []].append(weightedRank)
            }
        }

        return TaskCategory.allCases.map { category in
            let ranks = scores[category] ?? []
            let average = ranks.isEmpty ? 3 : Int(round(Double(ranks.reduce(0, +)) / Double(ranks.count)))
            return CategoryPreference(category: category, rank: average)
        }
    }
}

/// A single intake question response for a specific task.
struct IntakeTaskResponse: Identifiable {
    let task: TaskItem
    var rank: Int?
    var skipped: Bool = false

    var id: UUID { task.id }
}

/// Summary generated from completed intake responses.
struct IntakeSummary {
    let headline: String
    let detailLines: [String]
    let categoryRankings: [(category: TaskCategory, rank: Int)]
}

/// A post-task reflection saved by the user.
struct JournalEntry: Identifiable, Hashable {
    let id = UUID()
    let taskID: UUID
    let taskTitle: String
    let text: String
    let date: Date
}

/// Snapshot of a task completed on a specific day (stored in activity history).
struct CompletedTaskRecord: Identifiable, Hashable {
    let id: UUID
    let title: String
    let detail: String
    let category: TaskCategory
    let categoryLabels: String
    let isCustom: Bool

    /// Creates a storable record from a live daily task.
    init(from task: TaskItem) {
        id = task.id
        title = task.title
        detail = task.detail
        category = task.category
        categoryLabels = task.categoryLabels
        isCustom = task.isCustom
    }
}

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let detail: String
    let category: TaskCategory
    let style: SocialStyle
    let minutes: Int
    var categoryWeights: [TaskCategory: Int] = [:]
    var isCustom: Bool = false
    var learnMore: String = ""
    var resourceURL: URL? = nil
    var resourceLinkTitle: String = ""

    /// Grey time label shown beside each task.
    var timeEstimateLabel: String { "\(minutes) min" }

    /// Explanation for the Know More sheet; falls back to detail for custom tasks.
    var learnMoreText: String {
        if !learnMore.isEmpty { return learnMore }
        if isCustom {
            return "Custom \(category.rawValue.lowercased()) tasks help you build habits in the areas that matter most to you right now."
        }
        return detail
    }

    var linkedResourceURL: URL? {
        resourceURL ?? category.resourceURL
    }

    var linkedResourceTitle: String {
        resourceLinkTitle.isEmpty ? category.resourceLinkTitle : resourceLinkTitle
    }

    /// Weighted categories for garden credit; defaults to the primary category.
    var effectiveWeights: [TaskCategory: Int] {
        categoryWeights.isEmpty ? [category: 100] : categoryWeights
    }

    /// Labels for all categories this task contributes to.
    var categoryLabels: String {
        let categories = effectiveWeights.keys.sorted { $0.rawValue < $1.rawValue }
        return categories.map(\.priorityLabel).joined(separator: " · ")
    }
}

/// Priority percentages for one calendar week, used in greenhouse charts.
struct WeeklyPriorityBreakdown: Identifiable {
    let id: String
    let title: String
    let taskCounts: [GardenPriority: Int]
    let percentages: [GardenPriority: Int]

    var averageProgress: Int {
        let values = GardenPriority.allCases.map { percentages[$0, default: 0] }
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / values.count
    }

    var completedTaskCount: Int {
        taskCounts.values.reduce(0, +)
    }
}
