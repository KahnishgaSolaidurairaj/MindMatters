import SwiftUI

/// Full-screen greenhouse scene reflecting priority balance and weekly streak progress.
struct FullGardenView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Image(appState.greenhouseSceneAsset)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                        .padding(.horizontal)
                        .accessibilityLabel("Your greenhouse garden")

                    gardenStatusCard
                    prioritySummaryCard
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Your Garden")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var gardenStatusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Overall Streak: \(appState.currentStreak) days", systemImage: "flame.fill")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.teal)

            if appState.currentWeeklyPlantDay > 0 {
                Text("Day \(appState.currentWeeklyPlantDay) with your current weekly plant.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
            }

            Text(appState.greenhouseSceneDescription)
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.8))

            if appState.streakBroken {
                Label("Streak recently reset", systemImage: "exclamationmark.triangle.fill")
                    .font(Theme.bodyText)
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var prioritySummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Priority Breakdown")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.teal)

            Text("Average focus: \(appState.averagePriorityProgress)%")
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.75))

            ForEach(appState.gardenProfiles) { profile in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(profile.category)
                            .font(Theme.bodyText.weight(.semibold))
                            .foregroundStyle(Theme.textDark)
                        Spacer()
                        Text("\(profile.progress)%")
                            .font(Theme.bodyText.weight(.semibold))
                            .foregroundStyle(Theme.teal)
                    }

                    ProgressView(value: Double(profile.progress), total: 100)
                        .tint(Theme.teal)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        FullGardenView()
            .environmentObject(AppState())
    }
}
