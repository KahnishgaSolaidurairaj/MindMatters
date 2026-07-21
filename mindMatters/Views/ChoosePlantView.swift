import SwiftUI

struct ChoosePlantView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    var isReplacingWeeklyPlant: Bool = false
    @State private var selectedKind: PlantKind = .sunflower

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    MindMattersLogoView(size: 64)
                        .padding(.top, 16)

                    Text(isReplacingWeeklyPlant ? "Pick Your Next Weekly Plant" : "Choose Your Weekly Plant")
                        .font(Theme.pageTitle)
                        .foregroundColor(Theme.textDark)

                    Text(
                        isReplacingWeeklyPlant
                        ? "Start fresh with a new plant for this week."
                        : "This plant grows one stage for each day you complete your streak."
                    )
                        .font(Theme.bodyText)
                        .foregroundColor(Theme.textDark.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(PlantKind.allCases) { kind in
                            plantOptionCard(for: kind)
                        }
                    }
                    .padding(.horizontal)

                    Button(isReplacingWeeklyPlant ? "Start \(selectedKind.displayName) This Week" : "Grow \(selectedKind.displayName) This Week") {
                        if isReplacingWeeklyPlant {
                            appState.replaceWeeklyPlant(with: selectedKind)
                            dismiss()
                        } else {
                            appState.selectPlant(selectedKind)
                        }
                    }
                    .font(Theme.buttonText)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Theme.teal)
                    .clipShape(Capsule())
                    .padding(.horizontal, 32)
                    .padding(.bottom, 32)
                }
            }
        }
    }

    private func plantOptionCard(for kind: PlantKind) -> some View {
        let isSelected = selectedKind == kind

        return Button {
            selectedKind = kind
        } label: {
            VStack(spacing: 12) {
                PlantImageView(kind: kind, stage: .medium, height: 90)

                Text(kind.displayName)
                    .font(Theme.rowTitle)
                    .foregroundColor(Theme.textDark)

                Text(kind.weeklyStreakDescription)
                    .font(Theme.bodyText)
                    .foregroundColor(Theme.textDark.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 200)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Theme.teal : Color.clear, lineWidth: 3)
            )
            .shadow(color: .black.opacity(isSelected ? 0.08 : 0.04), radius: 6, y: 3)
        }
        .buttonStyle(.plain)
    }
}
