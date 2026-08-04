import SwiftUI

/// Rotating motivational messages shown when the app opens.
enum MotivationMessages {
    static let all = [
        "Let's continue growing!",
        "Small moments make big impacts!",
        "One step today keeps your garden thriving.",
        "You're building something meaningful.",
    ]

    static func random() -> String {
        all.randomElement() ?? all[0]
    }
}

/// A lightweight notification-style popup for motivational messages.
struct MotivationPopupView: View {
    let message: String
    var onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "leaf.fill")
                .font(.title2)
                .foregroundStyle(Theme.teal)

            Text(message)
                .font(Theme.bodyText.weight(.semibold))
                .foregroundStyle(Theme.textDark)
                .wrapping()
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)

            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.textDark.opacity(0.35))
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Theme.teal.opacity(0.18), radius: 12, y: 6)
        )
        .padding(.horizontal)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

#Preview {
    MotivationPopupView(message: MotivationMessages.all[0], onDismiss: {})
        .background(Theme.background)
}
