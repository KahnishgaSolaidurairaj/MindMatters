import SwiftUI

struct AppMenuView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        AppPageShell(title: "Menu") {
            ScrollView {
                VStack(spacing: 24) {
                    menuSection(title: "Home") {
                        Button {
                            appState.navigateToHome()
                        } label: {
                            menuRowLabel(title: "Today's Tasks", icon: "checkmark.circle.fill")
                        }
                    }

                    menuSection(title: "Your Garden") {
                        NavigationLink(value: AppDestination.greenhouse) {
                            menuRowLabel(title: "View Greenhouse", icon: "house.lodge.fill")
                        }

                        NavigationLink(value: AppDestination.priorityBreakdown) {
                            menuRowLabel(title: "Priority Breakdown", icon: "chart.bar.fill")
                        }
                    }

                    menuSection(title: "Profile") {
                        NavigationLink(value: AppDestination.profile) {
                            menuRowLabel(title: "Edit Profile", icon: "person.crop.circle")
                        }

//                        NavigationLink(value: AppDestination.privacySettings) {
//                            menuRowLabel(title: "Privacy Settings", icon: "lock.shield.fill")
//                        }

                        NavigationLink(value: AppDestination.rewardsShop) {
                            menuRowLabel(title: "Points & Rewards", icon: "bolt.fill")
                        }

                        NavigationLink(value: AppDestination.streakCalendar) {
                            menuRowLabel(title: "Activity Calendar", icon: "calendar")
                        }
                    }

                    menuSection(title: "Connections") {
                        NavigationLink(value: AppDestination.coOpActivities) {
                            menuRowLabel(title: "CO-OP Activities", icon: "person.3.fill")
                        }

                        NavigationLink(value: AppDestination.relationshipCheckIn) {
                            menuRowLabel(title: "Relationship Check-In", icon: "person.2.fill")
                        }

                        NavigationLink(value: AppDestination.inviteConnection) {
                            menuRowLabel(title: "Invite a Connection", icon: "person.badge.plus")
                        }

                        if appState.hasConnection {
                            NavigationLink(value: AppDestination.connectionGreenhouse(appState.connectionName)) {
                                menuRowLabel(
                                    title: "Visit Connection's Greenhouse",
                                    icon: "house.lodge.fill"
                                )
                            }
                        }
                    }

                    menuSection(title: "Campus") {
                        NavigationLink(value: AppDestination.resources) {
                            menuRowLabel(title: "Browse Campus Resources", icon: "building.2.fill")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }

    private func menuSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.teal)
                .padding(.leading, 4)

            VStack(spacing: 8) {
                content()
            }
        }
    }

    private func menuRowLabel(title: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Theme.teal)
                .frame(width: 32)

            Text(title)
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)
                .wrapping()
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.body.weight(.semibold))
                .foregroundStyle(Theme.textDark.opacity(0.35))
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .contentShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    NavigationStack {
        AppMenuView()
            .environmentObject(AppState())
    }
}
