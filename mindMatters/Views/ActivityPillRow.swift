import SwiftUI

struct ActivityPillRow: View {
    let task: TaskItem
    let isDone: Bool
    let onToggle: () -> Void
    var onKnowMore: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onToggle) {
                HStack(spacing: 14) {
                    Image(systemName: task.category.symbol)
                        .foregroundColor(Theme.teal)
                        .frame(width: 34, height: 34)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(task.title)
                            .font(Theme.rowTitle)
                            .foregroundColor(.white)
                            .wrapping()
                            .strikethrough(isDone)

                        Text(task.timeEstimateLabel)
                            .font(Theme.supportingText)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(.white)
                }
                .padding(12)
                .background(Theme.sage)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            if let onKnowMore {
                Button(action: onKnowMore) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
