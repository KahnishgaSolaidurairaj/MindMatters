import SwiftUI

struct StreakPopupView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame.fill")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.orange)

            Text("\(appState.currentStreak) Day Streak!")
                .font(Theme.pageTitle)

            Text("You finished all of today's tasks. Come back tomorrow to keep it going.")
                .font(Theme.bodyText)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.textDark.opacity(0.8))
                .padding(.horizontal)

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Label("Your streak counts days you finish all 3 daily tasks.", systemImage: "info.circle")
                Label("Miss 5 days in a row and your streak resets.", systemImage: "exclamationmark.triangle")
            }
            .font(Theme.bodyText)
            .foregroundColor(Theme.textDark.opacity(0.75))
            .padding(.horizontal)

            Button("Nice!") {
                appState.showStreakPopup = false
            }
            .font(Theme.buttonText)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

struct StreakBrokenView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "flame.slash")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.gray)

            Text("Your streak reset")
                .font(Theme.sectionTitle)

            Text("You went 5 days without finishing your tasks. Every streak starts somewhere.")
                .font(Theme.bodyText)
                .multilineTextAlignment(.center)
                .foregroundColor(Theme.textDark.opacity(0.8))
                .padding(.horizontal)

            if let task = appState.redemptionTask {
                VStack(spacing: 8) {
                    Text("Want a fresh start? Try something new:")
                        .font(Theme.bodyText)
                        .foregroundColor(Theme.textDark.opacity(0.75))
                        .multilineTextAlignment(.center)
                    Text(task.title)
                        .font(Theme.rowTitle)
                    Text(task.detail)
                        .font(Theme.bodyText)
                        .foregroundColor(Theme.textDark.opacity(0.75))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.08)))
                .padding(.horizontal)

                Button("Add this to today's tasks") {
                    appState.acceptRedemption()
                }
                .font(Theme.buttonText)
                .buttonStyle(.borderedProminent)
            }

            Button("Maybe later") {
                appState.streakBroken = false
            }
            .font(Theme.buttonText)
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
