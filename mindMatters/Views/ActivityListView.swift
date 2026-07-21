import SwiftUI

struct ActivityListView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                AppHeaderView()
                    .padding(.top, 8)

                ScrollView {
                    VStack(spacing: 18) {
                        ActivePlantCard(
                            kind: appState.selectedPlantKind,
                            stage: appState.streakPlantStage,
                            isWilted: appState.isStreakPlantWilted
                        )
                            .padding(.horizontal)
                            .padding(.top, 12)

                        HStack {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(Theme.teal)
                            Text("Today's Activities:")
                                .font(Theme.sectionTitle)
                                .foregroundColor(Theme.teal)
                            Spacer()
                        }
                        .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(appState.dailyActivities) { task in
                                ActivityPillRow(
                                    task: task,
                                    isDone: appState.completedTaskIDs.contains(task.id)
                                ) {
                                    appState.toggleComplete(task)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 100)
                }

                BottomStatusBar(streak: appState.currentStreak, energy: appState.energyPoints) {
                    appState.endDay()
                }
                .padding(.bottom, 12)
            }
        }
        .sheet(isPresented: $appState.showStreakPopup) {
            StreakPopupView().environmentObject(appState)
        }
        .sheet(isPresented: $appState.showResources) {
            ResourcesHubView()
        }
        .sheet(isPresented: $appState.streakBroken) {
            StreakBrokenView().environmentObject(appState)
        }
    }
}
