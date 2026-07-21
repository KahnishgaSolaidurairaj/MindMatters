import SwiftUI

struct ActivePlantCard: View {
    let kind: PlantKind
    let stage: PlantStage
    let isWilted: Bool

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                MindMattersLogoView(size: 28, useCompactVariant: true)
                Text("Your Active Plant")
                    .font(.headline)
                    .foregroundColor(Theme.teal)
                Spacer()
                Text(kind.displayName)
                    .font(.subheadline)
                    .foregroundColor(Theme.textDark.opacity(0.7))
            }

            PlantImageView(
                kind: kind,
                stage: stage,
                isWilted: isWilted,
                height: 150
            )
            .padding(.vertical, 4)

            Text(stage.label)
                .font(.caption.bold())
                .foregroundColor(Theme.teal)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.cardWhite)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
