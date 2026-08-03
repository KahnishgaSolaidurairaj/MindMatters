import SwiftUI

/// Onboarding planting moment — tap the pot to begin the priority garden journey.
struct PlantingView: View {
    @EnvironmentObject var appState: AppState
    @State private var planted = false

    private var starterPlant: PlantKind {
        appState.plantKind(for: appState.focusedPriority)
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                MindMattersLogoView(size: 56)

                Text(planted ? "You're ready to grow!" : "Let's start our journey")
                    .font(Theme.sectionTitle)
                    .foregroundColor(Theme.textDark)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                if !planted {
                    Text("Tap the pot to get started")
                        .font(Theme.bodyText)
                        .foregroundColor(Theme.textDark.opacity(0.75))
                }

                ZStack(alignment: .bottom) {
                    Image(starterPlant.streakPotAssetName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 90)

                    if planted {
                        PlantImageView(
                            kind: starterPlant,
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
                .accessibilityLabel("Plant pot. Tap to begin.")

                Spacer()

                Button("Continue") {
                    appState.confirmPlanting()
                }
                .font(Theme.buttonText)
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
        .interactiveDismissDisabled()
    }
}
