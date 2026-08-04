import SwiftUI

/// Celebrates task completion with a watering can and falling droplet confetti.
struct WateringCelebrationView: View {
    @State private var canAppeared = false
    @State private var dropletsAnimating = false
    @State private var pourWobble = false

    private let droplets = DropletParticle.specs(count: 24)

    var body: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height * 0.18
            let spoutX = centerX - 38
            let spoutY = centerY + 30

            ZStack {
                ForEach(droplets) { droplet in
                    dropletView(droplet)
                        .position(
                            x: spoutX + (dropletsAnimating ? droplet.endX : droplet.startX),
                            y: spoutY + (dropletsAnimating ? droplet.endY : droplet.startY)
                        )
                        .opacity(dropletsAnimating ? 0 : 1)
                        .animation(
                            .easeOut(duration: droplet.duration).delay(droplet.delay),
                            value: dropletsAnimating
                        )
                }

                Image("watering_can")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .scaleEffect(canAppeared ? 1 : 0.15)
                    .opacity(canAppeared ? 1 : 0)
                    .rotationEffect(.degrees(canAppeared ? (pourWobble ? -12 : -6) : 18))
                    .position(x: centerX, y: centerY)
                    .animation(.spring(response: 0.45, dampingFraction: 0.62), value: canAppeared)
                    .animation(.easeInOut(duration: 0.35).repeatCount(3, autoreverses: true), value: pourWobble)
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            canAppeared = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                dropletsAnimating = true
                pourWobble = true
            }
        }
    }

    @ViewBuilder
    private func dropletView(_ droplet: DropletParticle) -> some View {
        Group {
            if droplet.usesAsset {
                Image("water_drops")
                    .resizable()
                    .scaledToFit()
            } else {
                Circle()
                    .fill(Theme.teal.opacity(0.85))
            }
        }
        .frame(width: 22 * droplet.scale, height: 22 * droplet.scale)
        .rotationEffect(.degrees(dropletsAnimating ? droplet.endRotation : droplet.startRotation))
        .animation(
            .easeOut(duration: droplet.duration).delay(droplet.delay),
            value: dropletsAnimating
        )
    }
}

private struct DropletParticle: Identifiable {
    let id: Int
    let startX: CGFloat
    let startY: CGFloat
    let endX: CGFloat
    let endY: CGFloat
    let startRotation: Double
    let endRotation: Double
    let scale: CGFloat
    let delay: Double
    let duration: Double
    let usesAsset: Bool

    /// Builds a fixed set of droplet trajectories so animations stay stable across redraws.
    static func specs(count: Int) -> [DropletParticle] {
        (0..<count).map { index in
            DropletParticle(
                id: index,
                startX: seededCGFloat(index: index, range: -10...10, salt: 1),
                startY: seededCGFloat(index: index, range: -6...6, salt: 2),
                endX: seededCGFloat(index: index, range: -85...95, salt: 3),
                endY: seededCGFloat(index: index, range: 45...130, salt: 4),
                startRotation: seededDouble(index: index, range: -20...20, salt: 5),
                endRotation: seededDouble(index: index, range: -50...50, salt: 6),
                scale: seededCGFloat(index: index, range: 0.35...1.05, salt: 7),
                delay: Double(index) * 0.03 + seededDouble(index: index, range: 0...0.12, salt: 8),
                duration: seededDouble(index: index, range: 0.85...1.55, salt: 9),
                usesAsset: index % 3 != 0
            )
        }
    }

    private static func seededCGFloat(index: Int, range: ClosedRange<CGFloat>, salt: Int) -> CGFloat {
        let normalized = pseudoRandom(index: index, salt: salt)
        return range.lowerBound + (range.upperBound - range.lowerBound) * normalized
    }

    private static func seededDouble(index: Int, range: ClosedRange<Double>, salt: Int) -> Double {
        let normalized = Double(pseudoRandom(index: index, salt: salt))
        return range.lowerBound + (range.upperBound - range.lowerBound) * normalized
    }

    private static func pseudoRandom(index: Int, salt: Int) -> CGFloat {
        var value = UInt64(index &+ 1) &* 1103515245 &+ UInt64(salt &* 12345)
        value = (value ^ (value >> 16)) &* 2246822519
        value = value ^ (value >> 13)
        return CGFloat(value % 10_000) / 10_000
    }
}

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        WateringCelebrationView()
    }
}
