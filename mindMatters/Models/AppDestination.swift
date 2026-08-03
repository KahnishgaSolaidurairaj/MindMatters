import Foundation

/// Full-page destinations pushed from the menu or home screen.
enum AppDestination: Hashable {
    case menu
    case greenhouse
    case priorityBreakdown
    case profile
    case privacySettings
    case rewardsShop
    case streakCalendar
    case coOpActivities
    case resources
    case relationshipCheckIn
    case inviteConnection
    case connectionGreenhouse(String)
    case encouragementNote
}
