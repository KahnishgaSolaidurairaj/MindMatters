import SwiftUI

struct ChoosePlantView: View {
    @EnvironmentObject var appState: AppState
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
                    Image(MindMattersAssets.myPlantsBanner)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 220)
                        .padding(.top, 12)

                    Text("Choose Your Plant")
                        .font(.title.bold())
                        .foregroundColor(Theme.textDark)

                    Text("Pick a plant that will grow with your daily activities. You can always change it later from your garden.")
                        .font(.subheadline)
                        .foregroundColor(Theme.textDark.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)

                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(PlantKind.allCases) { kind in
                            plantOptionCard(for: kind)
                        }
                    }
                    .padding(.horizontal)

                    Button("Continue with \(selectedKind.displayName)") {
                        appState.selectPlant(selectedKind)
                    }
                    .font(.headline)
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
                    .font(.headline)
                    .foregroundColor(Theme.textDark)

                Text(kind.description)
                    .font(.caption)
                    .foregroundColor(Theme.textDark.opacity(0.65))
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 210)
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
