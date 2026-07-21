import SwiftUI

struct ActivityPillRow: View {
    let task: TaskItem
    let isDone: Bool
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 14) {
                Image(systemName: task.category.symbol)
                    .foregroundColor(Theme.teal)
                    .frame(width: 34, height: 34)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(task.title)
                    .font(Theme.rowTitle)
                    .foregroundColor(.white)
                    .strikethrough(isDone)

                Spacer()

                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.white)
            }
            .padding(12)
            .background(Theme.sage)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .buttonStyle(.plain)
    }
}
