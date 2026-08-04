import SwiftUI

/// Reusable capsule/ranking button with a full-area tap target.
struct SelectableCapsuleButton: View {
    let title: String
    let isSelected: Bool
    let cornerRadius: CGFloat
    let action: () -> Void

    init(
        _ title: String,
        isSelected: Bool,
        cornerRadius: CGFloat = 10,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.cornerRadius = cornerRadius
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.buttonText)
                .wrapping(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .foregroundStyle(isSelected ? .white : Theme.teal)
                .background(isSelected ? Theme.teal : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Theme.teal.opacity(0.35), lineWidth: 1)
                )
                .contentShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

/// Full-width capsule action button with tappable fill area.
struct PrimaryCapsuleButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(Theme.buttonText)
                .foregroundStyle(.white)
                .wrapping(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(isEnabled ? Theme.teal : Color.gray.opacity(0.4))
                .clipShape(Capsule())
                .contentShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack {
            SelectableCapsuleButton("1", isSelected: true) {}
            SelectableCapsuleButton("2", isSelected: false) {}
        }
        PrimaryCapsuleButton(title: "Continue", isEnabled: true) {}
    }
    .padding()
}
