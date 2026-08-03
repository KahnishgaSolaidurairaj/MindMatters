import SwiftUI

/// Maps navigation destinations to their full-page views.
struct AppDestinationView: View {
    let destination: AppDestination

    var body: some View {
        switch destination {
        case .menu:
            AppMenuView()
        case .greenhouse:
            AppPageShell(title: "Your Greenhouse") {
                FullGardenView()
            }
        case .priorityBreakdown:
            AppPageShell(title: "Your Plant Priorities") {
                PlantOverviewView(showLogo: false)
            }
        case .profile:
            AppPageShell(title: "Profile") {
                ProfileView()
            }
        case .privacySettings:
            AppPageShell(title: "Privacy Settings") {
                PrivacySettingsView()
            }
        case .rewardsShop:
            AppPageShell(title: "Points & Rewards") {
                RewardsShopView()
            }
        case .streakCalendar:
            AppPageShell(title: "Activity Calendar") {
                StreakCalendarView()
            }
        case .coOpActivities:
            AppPageShell(title: "CO-OP Activities") {
                CoOpActivitiesView()
            }
        case .resources:
            AppPageShell(title: "Campus Resources") {
                ResourcesHubView()
            }
        case .relationshipCheckIn:
            AppPageShell(title: "Check-In") {
                RelationshipCheckInView()
            }
        case .inviteConnection:
            AppPageShell(title: "Invite Connection") {
                InviteRelationshipView()
            }
        case .connectionGreenhouse(let name):
            AppPageShell {
                ConnectionGreenhouseView(connectionName: name)
            }
        case .encouragementNote:
            AppPageShell(title: "Send a Message") {
                EncouragementNoteView()
            }
        }
    }
}
