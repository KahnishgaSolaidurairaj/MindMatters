import SwiftUI

struct SeedGivenView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                Text("Here's your \(appState.selectedPlantKind.displayName) Seed")
                    .font(.title.bold())
                    .foregroundColor(Theme.textDark)
                    .multilineTextAlignment(.center)

                ZStack(alignment: .bottom) {
                    Image(appState.selectedPlantKind.defaultPotAssetName)
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
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Text("This \(appState.selectedPlantKind.displayName.lowercased()) grows alongside your daily habits. Water it, give it sunlight, and fertilize it by completing your activities.")
                    .foregroundColor(Theme.textDark.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                Button("Plant It") {
                    appState.plantSeed()
                }
                .font(.headline)
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
