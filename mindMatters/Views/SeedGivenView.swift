import SwiftUI

struct SeedGivenView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                MindMattersLogoView(size: 56)

                Text("Your Weekly \(appState.selectedPlantKind.displayName)")
                    .font(Theme.sectionTitle)
                    .foregroundColor(Theme.textDark)
                    .multilineTextAlignment(.center)

                ZStack(alignment: .bottom) {
                    Image(appState.selectedPlantKind.streakPotAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 70)

                    PlantImageView(
                        kind: appState.selectedPlantKind,
                        stage: .seed,
                        height: 70
                    )
                    .offset(y: -36)
                }
                .padding(24)
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("This plant grows one stage for each day you complete your streak.")
                    .font(Theme.bodyText)
                    .foregroundColor(Theme.textDark.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                Button("Plant It") {
                    appState.plantSeed()
                }
                .font(Theme.buttonText)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(Theme.teal)
                .clipShape(Capsule())
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}
