import SwiftUI

enum TaskCategory: String, CaseIterable, Identifiable {
    case social = "Social"
    case academic = "Academic"
    case finance = "Finance"
    case mentalHealth = "Mental Health"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .social: return "person.2.fill"
        case .academic: return "book.fill"
        case .finance: return "dollarsign.circle.fill"
        case .mentalHealth: return "brain.head.profile"
        }
    }

    var tint: Color {
        switch self {
        case .social: return .orange
        case .academic: return .blue
        case .finance: return .green
        case .mentalHealth: return .purple
        }
    }

    /// Label shown in task lists and matched to garden priority pots.
    var priorityLabel: String {
        GardenPriority.from(taskCategory: self).rawValue
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
