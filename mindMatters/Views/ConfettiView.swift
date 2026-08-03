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

#Preview {
    ZStack {
        Theme.background.ignoresSafeArea()
        ConfettiView()
    }
}
