import SwiftUI

/// Sheet explaining how a task supports the user's wellbeing, with a campus resource link.
struct TaskKnowMoreView: View {
    let task: TaskItem
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Label(task.category.rawValue, systemImage: task.category.symbol)
                        .font(Theme.supportingText.weight(.semibold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(task.category.tint.opacity(0.15))
                        .foregroundStyle(task.category.tint)
                        .clipShape(Capsule())

                    Text(task.title)
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textDark)
                        .wrapping()

                    Text(task.timeEstimateLabel)
                        .font(Theme.supportingText)
                        .foregroundStyle(Theme.textDark.opacity(0.5))

                    Text("How this helps")
                        .font(Theme.rowTitle)
                        .foregroundStyle(Theme.textDark)

                    Text(task.learnMoreText)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.8))
                        .wrapping()

                    if let url = task.linkedResourceURL {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Campus Resource")
                                .font(Theme.rowTitle)
                                .foregroundStyle(Theme.textDark)

                            Button {
                                openURL(url)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(task.linkedResourceTitle)
                                            .font(Theme.bodyText.weight(.semibold))
                                            .foregroundStyle(Theme.teal)
                                            .wrapping()
                                        Text(url.absoluteString)
                                            .font(.caption)
                                            .foregroundStyle(Theme.textDark.opacity(0.55))
                                            .wrapping()
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.up.right.square")
                                        .foregroundStyle(Theme.teal)
                                }
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Theme.teal.opacity(0.25), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Know More")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    TaskKnowMoreView(
        task: TaskDatabase.all.first ?? TaskItem(
            title: "Join a study group session",
            detail: "Even 15 minutes with others helps retention.",
            category: .academic,
            style: .extroverted,
            minutes: 10,
            learnMore: "Study groups improve retention through active recall and peer accountability."
        )
    )
}
