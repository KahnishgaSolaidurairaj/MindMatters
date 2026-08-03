import SwiftUI

struct BottomStatusBar: View {
    let energy: Int
    let highlightEndDay: Bool
    let onEndDay: () -> Void
    let onPointsTap: () -> Void

    var body: some View {
        HStack(spacing: 22) {
            Button(action: onEndDay) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.right.circle.fill")
                    if highlightEndDay {
                        Text("End Day")
                    }
                }
                .foregroundColor(.white)
                .frame(minHeight: 44)
                .contentShape(Capsule())
            }
            .accessibilityLabel(highlightEndDay ? "End day to grow your plant" : "End day")
            .scaleEffect(highlightEndDay ? 1.05 : 1.0)
            .animation(highlightEndDay ? .easeInOut(duration: 0.8).repeatForever(autoreverses: true) : .default, value: highlightEndDay)

            Spacer()

            Button(action: onPointsTap) {
                HStack(spacing: 4) {
                    Image(systemName: BloomCurrency.icon)
                    Text("\(energy)")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .contentShape(Capsule())
            }
            .accessibilityLabel("\(energy) \(BloomCurrency.displayName). Tap to open rewards shop.")
        }
        .font(Theme.buttonText)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(highlightEndDay ? Theme.sage : Theme.teal)
        .clipShape(Capsule())
        .animation(.easeInOut(duration: 0.3), value: highlightEndDay)
    }
}
