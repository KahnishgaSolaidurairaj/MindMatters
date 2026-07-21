import SwiftUI

struct BottomStatusBar: View {
    let streak: Int
    let energy: Int
    let onEndDay: () -> Void

    var body: some View {
        HStack(spacing: 22) {
            Button(action: onEndDay) {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.white)
            }
            .accessibilityLabel("End day")

            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                Text("\(streak)")
            }
            .foregroundColor(.white)
            .accessibilityLabel("\(streak) day streak")

            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                Text("\(energy)")
            }
            .foregroundColor(.white)
            .accessibilityLabel("\(energy) energy points")
        }
        .font(Theme.buttonText)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Theme.teal)
        .clipShape(Capsule())
    }
}
