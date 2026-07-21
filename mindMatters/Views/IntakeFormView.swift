import SwiftUI

struct IntakeFormView: View {
    @EnvironmentObject var appState: AppState

    @State private var queue: [TaskItem] = TaskCategory.allCases.flatMap { category in
        Array(TaskDatabase.items(in: category).shuffled().prefix(2))
    }.shuffled()
    @State private var index = 0

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                ProgressView(value: Double(index), total: Double(max(queue.count, 1)))
                    .tint(Theme.teal)
                    .padding(.horizontal)

                Text("Quick Intake")
                    .font(Theme.sectionTitle)
                    .foregroundColor(Theme.textDark)
                Text("Would you enjoy this kind of task?")
                    .font(Theme.bodyText)
                    .foregroundColor(Theme.textDark.opacity(0.8))

                if index < queue.count {
                    let task = queue[index]
                    VStack(spacing: 12) {
                        Label(task.category.rawValue, systemImage: task.category.symbol)
                            .font(Theme.bodyText.weight(.semibold))
                            .padding(6)
                            .background(Theme.sage.opacity(0.2))
                            .foregroundColor(Theme.teal)
                            .clipShape(Capsule())

                        Text(task.title)
                            .font(Theme.rowTitle)
                            .foregroundColor(Theme.textDark)
                            .multilineTextAlignment(.center)
                        Text(task.detail)
                            .font(Theme.bodyText)
                            .foregroundColor(Theme.textDark.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                    .padding(.horizontal)

                    HStack(spacing: 20) {
                        Button {
                            advance(liked: false, task: task)
                        } label: {
                            Label("No thanks", systemImage: "xmark")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .foregroundColor(Theme.teal)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.teal, lineWidth: 1))

                        Button {
                            advance(liked: true, task: task)
                        } label: {
                            Label("I'd try this", systemImage: "checkmark")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .foregroundColor(.white)
                        .background(Theme.sage)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)
                } else {
                    Text("All set!")
                        .font(Theme.rowTitle)
                        .foregroundColor(Theme.textDark)
                }

                Spacer()
            }
            .padding(.top)
        }
        .onChange(of: index) { _, newValue in
            if newValue >= queue.count {
                appState.finishIntake()
            }
        }
    }

    private func advance(liked: Bool, task: TaskItem) {
        if liked {
            appState.likedTasks.append(task)
        } else {
            appState.dislikedTasks.append(task)
        }
        index += 1
    }
}
