import SwiftUI

struct ConnectionGreenhouseView: View {
    @EnvironmentObject var appState: AppState
    let connectionName: String

    private var connection: ConnectionProfile? {
        appState.connections.first { $0.name == connectionName }
            ?? ConnectionCatalog.existingUsers.first { $0.name == connectionName }
    }

    private var coOpUnlocked: Bool {
        (connection?.streak ?? 0) >= 3 || appState.currentStreak >= 3
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                connectionHeader
                greenhouseCard
                streakCard
                coOpButton
                encouragementButton
            }
            .padding()
        }
    }

    private var connectionHeader: some View {
        HStack {
            Text("\(connectionName)'s Greenhouse")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textDark)

            Spacer()

            if connection?.isOnline == true
                && appState.privacySettings.onlineStatusVisibility != .nobody {
                HStack(spacing: 6) {
                    Circle()
                        .fill(.green)
                        .frame(width: 10, height: 10)
                    Text("Online")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                }
            }
        }
    }

    private var greenhouseCard: some View {
        VStack(spacing: 16) {
            Text("Current Growth")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.teal)

            PlantImageView(
                kind: connection?.plantKind ?? .sunflower,
                stage: PlantStage.fromWeeklyStreakDays(connection?.growthDays ?? 1),
                height: 110
            )

            Text(connection?.focusedPriority.plantDisplayName ?? "Growing")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            Text(connection?.focusedPriority.rawValue ?? "Growing")
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.75))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Plant Health", systemImage: "heart.fill")
                    .font(Theme.rowTitle)
                    .foregroundStyle(Theme.textDark)
                Spacer()
                Text("\(connection?.streak ?? 0) day streak")
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(Theme.textDark)
            }

            ProgressView(value: Double(connection?.streak ?? 0), total: 3)
                .tint(Theme.teal)

            Text(coOpUnlocked ? "CO-OP unlocked!" : "CO-OP unlocks at 3-day streak.")
            .font(Theme.bodyText)
            .foregroundStyle(Theme.textDark.opacity(0.75))
        }
        .padding()
        .background(Theme.sage.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var coOpButton: some View {
        NavigationLink(value: AppDestination.coOpActivities) {
            Label("View CO-OP Activities", systemImage: "person.3.fill")
                .font(Theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(coOpUnlocked ? Theme.teal : Color.gray.opacity(0.4))
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!coOpUnlocked)
    }

    private var encouragementButton: some View {
        NavigationLink(value: AppDestination.encouragementNote) {
            Label("Leave Encouragement", systemImage: "envelope.fill")
                .font(Theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.teal)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    NavigationStack {
        AppPageShell {
            ConnectionGreenhouseView(connectionName: "Linus")
        }
        .environmentObject(AppState())
    }
}
