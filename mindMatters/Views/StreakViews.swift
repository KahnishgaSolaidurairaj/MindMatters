import SwiftUI

struct StreakPopupView: View {
    @EnvironmentObject var appState: AppState

    private var latestReward: StreakReward? {
        ConnectionCatalog.streakRewards.first { $0.streakDay == appState.currentStreak }
    }

    var body: some View {
        ZStack {
            FlowerPetalConfettiView()

            VStack(spacing: 20) {
                Image(systemName: "flame.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.orange)

                Text("\(appState.currentStreak) Day Streak!")
                    .font(Theme.pageTitle)

                if let reward = latestReward {
                    Label("+\(reward.energyBonus) \(BloomCurrency.displayName)", systemImage: BloomCurrency.icon)
                        .font(Theme.bodyText.weight(.semibold))
                        .foregroundStyle(Theme.teal)
                }

                Button("Nice!") {
                    appState.showStreakPopup = false
                }
                .font(Theme.buttonText)
                .foregroundStyle(.white)
                .padding(.horizontal, 36)
                .padding(.vertical, 12)
                .background(Theme.sage)
                .clipShape(Capsule())
            }
            .padding()
        }
    }
}

struct StreakBrokenView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart.slash")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.orange)

            Text("Plant health dropped")
                .font(Theme.sectionTitle)

            Text("5 missed days reset your streak.")
                .font(Theme.bodyText)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.textDark.opacity(0.8))
                .padding(.horizontal)

            if let task = appState.redemptionTask {
                VStack(spacing: 8) {
                    Text(task.title)
                        .font(Theme.rowTitle)
                        .wrapping(.center)
                    Text(task.detail)
                        .font(Theme.bodyText)
                        .foregroundColor(Theme.textDark.opacity(0.75))
                        .wrapping(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.08)))
                .padding(.horizontal)

                Button("Try This Task") {
                    appState.acceptRedemption()
                }
                .font(Theme.buttonText)
                .buttonStyle(.borderedProminent)
            }

            Button("Maybe Later") {
                appState.streakBroken = false
            }
            .font(Theme.buttonText)
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
