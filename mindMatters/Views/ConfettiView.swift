import SwiftUI

/// Lightweight confetti burst for task and day completion celebrations.
struct ConfettiView: View {
    @State private var animate = false
    private let colors: [Color] = [Theme.teal, Theme.sage, .orange, .yellow, .pink]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<24, id: \.self) { index in
                    Circle()
                        .fill(colors[index % colors.count])
                        .frame(width: 8, height: 8)
                        .offset(
                            x: animate ? CGFloat.random(in: -geometry.size.width / 2...geometry.size.width / 2) : 0,
                            y: animate ? geometry.size.height * 0.6 : -20
                        )
                        .opacity(animate ? 0 : 1)
                        .animation(
                            .easeOut(duration: Double.random(in: 1.0...1.8))
                                .delay(Double(index) * 0.03),
                            value: animate
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .allowsHitTesting(false)
        .onAppear { animate = true }
    }
}

/// Flower-petal confetti for streak celebration pop-ups.
struct FlowerPetalConfettiView: View {
    @State private var animate = false
    private let petals = PetalParticle.specs(count: 28)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(petals) { petal in
                    Ellipse()
                        .fill(petal.color)
                        .frame(width: petal.width, height: petal.height)
                        .rotationEffect(.degrees(animate ? petal.endRotation : petal.startRotation))
                        .position(
                            x: animate ? petal.endX(in: geometry.size) : petal.startX(in: geometry.size),
                            y: animate ? petal.endY(in: geometry.size) : petal.startY(in: geometry.size)
                        )
                        .opacity(animate ? 0 : 1)
                        .animation(
                            .easeOut(duration: petal.duration).delay(petal.delay),
                            value: animate
                        )
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear { animate = true }
    }
}

private struct PetalParticle: Identifiable {
    let id: Int
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let startRotation: Double
    let endRotation: Double
    let startXFactor: CGFloat
    let startY: CGFloat
    let endXDrift: CGFloat
    let endYFactor: CGFloat
    let delay: Double
    let duration: Double

    func startX(in size: CGSize) -> CGFloat {
        startXFactor * size.width
    }

    func startY(in size: CGSize) -> CGFloat {
        startY
    }

    func endX(in size: CGSize) -> CGFloat {
        startX(in: size) + endXDrift
    }

    func endY(in size: CGSize) -> CGFloat {
        startY + endYFactor * size.height
    }

    static func specs(count: Int) -> [PetalParticle] {
        let colors: [Color] = [Theme.sage, Theme.teal, .pink, .orange, .yellow, Color(red: 0.95, green: 0.7, blue: 0.75)]

        return (0..<count).map { index in
            PetalParticle(
                id: index,
                color: colors[index % colors.count],
                width: seededCGFloat(index: index, range: 7...13, salt: 1),
                height: seededCGFloat(index: index, range: 14...24, salt: 2),
                startRotation: seededDouble(index: index, range: 0...360, salt: 3),
                endRotation: seededDouble(index: index, range: -90...270, salt: 4),
                startXFactor: seededCGFloat(index: index, range: 0.05...0.95, salt: 5),
                startY: seededCGFloat(index: index, range: -24...36, salt: 6),
                endXDrift: seededCGFloat(index: index, range: -70...70, salt: 7),
                endYFactor: seededCGFloat(index: index, range: 0.55...1.05, salt: 8),
                delay: Double(index) * 0.04 + seededDouble(index: index, range: 0...0.15, salt: 9),
                duration: seededDouble(index: index, range: 1.2...2.0, salt: 10)
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
        ConfettiView()
    }
}
