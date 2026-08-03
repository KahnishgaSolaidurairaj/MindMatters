import SwiftUI

/// Full-screen greenhouse scene reflecting priority balance and weekly streak progress.
struct FullGardenView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                    Image(appState.greenhouseSceneAsset)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                        .padding(.horizontal)
                        .accessibilityLabel("Your greenhouse")

                    gardenStatusCard
                    prioritySummaryCard
                }
                .padding(.vertical)
        }
    }

    private var gardenStatusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Plant Health: \(appState.plantHealthScore)%", systemImage: "heart.fill")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.teal)

            if appState.growthDaysOnCurrentPlant > 0 {
                Text("Growth Day \(appState.growthDaysOnCurrentPlant)")
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
            Text("Priorities")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.teal)

            Text("Avg. \(appState.averagePriorityProgress)%")
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
