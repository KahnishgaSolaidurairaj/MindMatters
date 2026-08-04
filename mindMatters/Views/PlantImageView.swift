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
    /// Negative values pull the pot upward to close the gap under the plant.
    var potOverlap: CGFloat = 0

    var body: some View {
        VStack(spacing: potOverlap) {
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

/// Priority Garden row: four potted plants displayed on a shared bench.
struct PriorityGardenBenchView: View {
    let profiles: [GardenPlantProfile]
    var plantHeight: CGFloat = 105
    var potHeight: CGFloat = 46
    var potOverlap: CGFloat = -24
    /// Lifts pots onto the bench surface; higher values move plants further up the bench.
    var benchSurfaceInset: CGFloat = 62
    /// Crops empty space above the bench in the source asset.
    var benchVisibleHeight: CGFloat = 92
    var displayHeight: CGFloat = 168

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("garden_bench")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: benchVisibleHeight, alignment: .bottom)
                .clipped()

            HStack(alignment: .bottom, spacing: 2) {
                ForEach(profiles) { plant in
                    PottedPlantView(
                        kind: plant.kind,
                        stage: plant.stage,
                        potAssetName: plant.potAssetName,
                        plantHeight: plantHeight,
                        potHeight: potHeight,
                        potOverlap: potOverlap
                    )
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, benchSurfaceInset)
        }
        .frame(height: displayHeight)
        .clipped()
    }
}
