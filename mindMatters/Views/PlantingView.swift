import SwiftUI

struct PlantingView: View {
    @EnvironmentObject var appState: AppState
    @State private var planted = false

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()
                Text(planted ? "Planted!" : "Tap the pot to plant your seed")
                    .font(.title2.bold())
                    .foregroundColor(Theme.textDark)

                ZStack(alignment: .bottom) {
                    Image(appState.selectedPlantKind.defaultPotAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 90)

                    if planted {
                        PlantImageView(
                            kind: appState.selectedPlantKind,
                            stage: .seed,
                            height: 80
                        )
                        .offset(y: -48)
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) { planted = true }
                }

                Spacer()

                Button("Continue") {
                    appState.confirmPlanting()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
                .background(planted ? Theme.teal : Color.gray.opacity(0.4))
                .clipShape(Capsule())
                .disabled(!planted)
                .padding(.bottom, 40)
            }
            .padding()
        }
    }
}
