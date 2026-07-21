import SwiftUI

struct ConnectionGreenhouseView: View {
    @Environment(\.dismiss) private var dismiss
    let connectionName: String

    private let currentStreak = 2
    private let requiredStreak = 5

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    headerView
                    greenhouseCard
                    streakCard
                    encouragementButton
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }

    private var headerView: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundStyle(Theme.textDark)
                    .padding(8)
            }

            Spacer()

            Text("\(connectionName)'s Greenhouse")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textDark)

            Spacer()

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

    private var greenhouseCard: some View {
        VStack(spacing: 16) {
            Text("New Growth")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.teal)

            PlantImageView(kind: .sunflower, stage: .sprout, height: 110)

            Text("Sapling")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            Text("\(connectionName) is starting their growth journey.")
                .font(Theme.bodyText)
                .multilineTextAlignment(.center)
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
                Label("Growth Streak", systemImage: "flame.fill")
                    .font(Theme.rowTitle)
                    .foregroundStyle(Theme.textDark)
                Spacer()
                Text("\(currentStreak)/\(requiredStreak) days")
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(Theme.textDark)
            }

            ProgressView(value: Double(currentStreak), total: Double(requiredStreak))
                .tint(Theme.teal)

            Text(
                currentStreak >= requiredStreak
                ? "CO-OP mode is unlocked."
                : "CO-OP unlocks after a 5-day growth streak."
            )
            .font(Theme.bodyText)
            .foregroundStyle(Theme.textDark.opacity(0.75))
        }
        .padding()
        .background(Theme.sage.opacity(0.28))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var encouragementButton: some View {
        NavigationLink {
            EncouragementNoteView()
        } label: {
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
        ConnectionGreenhouseView(connectionName: "Linus")
    }
}
