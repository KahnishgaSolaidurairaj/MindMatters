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

struct TaskItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let detail: String
    let category: TaskCategory
    let style: SocialStyle
    let minutes: Int
}
