import SwiftUI

/// A daily task row with time estimate, know-more info, and completion toggle.
struct DailyTaskRow: View {
    let task: TaskItem
    let isDone: Bool
    var onToggle: () -> Void
    var onKnowMore: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Button(action: onToggle) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(task.category.tint.opacity(0.15))
                            .frame(width: 50, height: 50)

                        Image(systemName: task.category.symbol)
                            .font(.title2)
                            .foregroundStyle(task.category.tint)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(Theme.rowTitle)
                            .foregroundStyle(Theme.textDark)
                            .wrapping()
                            .strikethrough(isDone)

                        HStack(spacing: 8) {
                            Text(task.timeEstimateLabel)
                                .font(Theme.supportingText)
                                .foregroundStyle(Theme.textDark.opacity(0.45))

                            if task.isCustom {
                                Text("Custom")
                                    .font(.caption2.weight(.semibold))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Theme.sage.opacity(0.25))
                                    .foregroundStyle(Theme.teal)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer(minLength: 0)

                    Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundStyle(isDone ? Theme.teal : Theme.teal.opacity(0.5))
                        .symbolEffect(.bounce, value: isDone)
                }
            }
            .buttonStyle(.plain)

            Button(action: onKnowMore) {
                Image(systemName: "info.circle")
                    .font(.title3)
                    .foregroundStyle(Theme.teal.opacity(0.85))
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Know more about \(task.title)")
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    DailyTaskRow(
        task: TaskDatabase.all[0],
        isDone: false,
        onToggle: {},
        onKnowMore: {}
    )
    .padding()
    .background(Theme.background)
}
