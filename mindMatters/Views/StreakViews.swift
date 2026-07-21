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
                .font(.largeTitle.bold())

            Text("You completed all of today's activities. Come back tomorrow to keep it going.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Label("Your streak counts consecutive days you finish all 3 daily activities.", systemImage: "info.circle")
                Label("Miss your activities for 5 days in a row and the streak resets to zero.", systemImage: "exclamationmark.triangle")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.horizontal)

            Button("Nice!") {
                appState.showStreakPopup = false
            }
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
                .font(.title.bold())

            Text("You went 5 days without finishing your activities, so your streak is back to zero. That's okay — every streak starts somewhere.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            if let task = appState.redemptionTask {
                VStack(spacing: 8) {
                    Text("Want a fresh start? Try something a little outside your comfort zone:")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Text(task.title)
                        .font(.headline)
                    Text(task.detail)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.gray.opacity(0.08)))
                .padding(.horizontal)

                Button("Add this to today's activities") {
                    appState.acceptRedemption()
                }
                .buttonStyle(.borderedProminent)
            }

            Button("Maybe later") {
                appState.streakBroken = false
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
