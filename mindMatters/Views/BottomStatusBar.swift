import SwiftUI

struct BottomStatusBar: View {
    let streak: Int
    let energy: Int
    let onEndDay: () -> Void
    let onResourcesTap: () -> Void

    var body: some View {
        HStack(spacing: 22) {
            Button(action: onResourcesTap) {
                MindMattersLogoView(size: 22, useCompactVariant: true)
            }

            Button(action: onEndDay) {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundColor(.white)
            }

            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                Text("\(streak)")
            }
            .foregroundColor(.white)

            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                Text("\(energy)")
            }
            .foregroundColor(.white)
        }
        .font(.headline)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(Theme.teal)
        .clipShape(Capsule())
    }
}
