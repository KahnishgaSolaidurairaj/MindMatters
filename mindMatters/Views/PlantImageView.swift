import SwiftUI

struct PlantImageView: View {
    let kind: PlantKind
    let stage: PlantStage
    var isWilted: Bool = false
    var height: CGFloat = 130

    private var assetName: String {
        isWilted ? kind.wiltAssetName() : kind.growthAssetName(for: stage)
    }

    var body: some View {
        Image(assetName)
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .opacity(isWilted && (kind == .cactus || kind == .rose) ? 0.55 : 1)
    }
}

struct PottedPlantView: View {
    let kind: PlantKind
    let stage: PlantStage
    var potAssetName: String? = nil
    var isWilted: Bool = false
    var plantHeight: CGFloat = 72
    var potHeight: CGFloat = 34

    var body: some View {
        VStack(spacing: 0) {
            PlantImageView(
                kind: kind,
                stage: stage,
                isWilted: isWilted,
                height: plantHeight
            )

            Image(potAssetName ?? kind.defaultPotAssetName)
                .resizable()
                .scaledToFit()
                .frame(height: potHeight)
        }
    }
}
