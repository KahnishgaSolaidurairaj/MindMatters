import SwiftUI

struct IntakeFormView: View {
    @EnvironmentObject var appState: AppState

    @State private var stepIndex = 0
    @State private var responses: [IntakeTaskResponse] = TaskDatabase.intakeQuestions.map {
        IntakeTaskResponse(task: $0)
    }
    @State private var showSummary = false

    private var questions: [TaskItem] {
        TaskDatabase.intakeQuestions
    }

    private var currentTask: TaskItem {
        questions[stepIndex]
    }

    private var currentResponse: IntakeTaskResponse {
        responses[stepIndex]
    }

    private var summary: IntakeSummary {
        TaskDatabase.intakeSummary(from: responses)
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            if showSummary {
                summaryView
            } else {
                questionView
            }
        }
    }

    private var questionView: some View {
        VStack(spacing: 24) {
            progressHeader

            Text("Quick Intake")
                .font(Theme.sectionTitle)
                .foregroundColor(Theme.textDark)

            Text("How likely are you to do this?")
                .font(Theme.bodyText)
                .foregroundColor(Theme.textDark.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            taskCard

            rankingSection

            navigationButtons

            Button("Skip this question") {
                skipCurrentQuestion()
            }
            .font(Theme.supportingText)
            .foregroundColor(Theme.textDark.opacity(0.6))

            Spacer()
        }
        .padding(.top)
    }

    private var summaryView: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Your Intake Summary")
                    .font(Theme.sectionTitle)
                    .foregroundColor(Theme.textDark)
                    .padding(.top, 24)

                VStack(spacing: 12) {
                    Image(systemName: "chart.bar.doc.horizontal.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(Theme.teal)

                    Text(summary.headline)
                        .font(Theme.bodyText.weight(.semibold))
                        .foregroundColor(Theme.textDark)
                        .wrapping(.center)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(summary.detailLines, id: \.self) { line in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: "leaf.fill")
                                .foregroundStyle(Theme.teal)
                                .font(.caption)
                                .padding(.top, 3)
                            Text(line)
                                .font(Theme.bodyText)
                                .foregroundColor(Theme.textDark.opacity(0.85))
                                .wrapping()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 14) {
                    Text("Category Snapshot")
                        .font(Theme.bodyText.weight(.semibold))
                        .foregroundColor(Theme.textDark)

                    ForEach(summary.categoryRankings, id: \.category) { item in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Label(item.category.rawValue, systemImage: item.category.symbol)
                                    .font(Theme.supportingText.weight(.semibold))
                                    .foregroundColor(item.category.tint)
                                Spacer()
                                Text(likelihoodLabel(for: item.rank))
                                    .font(Theme.supportingText)
                                    .foregroundColor(Theme.textDark.opacity(0.7))
                            }

                            ProgressView(value: Double(item.rank), total: 5)
                                .tint(item.category.tint)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
                .padding(.horizontal)

                Button {
                    appState.finishIntake(from: responses)
                } label: {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .font(Theme.buttonText)
                .foregroundColor(.white)
                .background(Theme.sage)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
        }
    }

    private var progressHeader: some View {
        VStack(spacing: 8) {
            ProgressView(
                value: Double(stepIndex + 1),
                total: Double(questions.count)
            )
            .tint(Theme.teal)
            .padding(.horizontal)

            Text("Question \(stepIndex + 1) of \(questions.count)")
                .font(Theme.supportingText)
                .foregroundColor(Theme.textDark.opacity(0.6))
        }
    }

    private var taskCard: some View {
        VStack(spacing: 12) {
            Label(currentTask.category.rawValue, systemImage: currentTask.category.symbol)
                .font(Theme.supportingText.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(currentTask.category.tint.opacity(0.15))
                .foregroundColor(currentTask.category.tint)
                .clipShape(Capsule())

            Text(currentTask.title)
                .font(Theme.bodyText.weight(.semibold))
                .foregroundColor(Theme.textDark)
                .wrapping(.center)
                .frame(maxWidth: .infinity)

            Text(currentTask.detail)
                .font(Theme.supportingText)
                .foregroundColor(Theme.textDark.opacity(0.7))
                .wrapping(.center)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .padding(.horizontal)
    }

    private var rankingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { rank in
                    SelectableCapsuleButton("\(rank)", isSelected: currentResponse.rank == rank) {
                        updateRank(rank)
                    }
                }
            }
            .padding(.horizontal)

            HStack {
                Text("Least likely")
                Spacer()
                Text("Most likely")
            }
            .font(Theme.supportingText)
            .foregroundStyle(Theme.textDark.opacity(0.6))
            .padding(.horizontal)
        }
    }

    private var navigationButtons: some View {
        HStack(spacing: 16) {
            if stepIndex > 0 {
                Button {
                    stepIndex -= 1
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .foregroundColor(Theme.teal)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.teal, lineWidth: 1))
            }

            Button {
                advance()
            } label: {
                Text(stepIndex == questions.count - 1 ? "See Summary" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .font(Theme.buttonText)
            .foregroundColor(.white)
            .background(currentResponse.rank == nil ? Theme.sage.opacity(0.45) : Theme.sage)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .disabled(currentResponse.rank == nil)
        }
        .padding(.horizontal)
    }

    private func updateRank(_ rank: Int) {
        responses[stepIndex].rank = rank
        responses[stepIndex].skipped = false
    }

    private func skipCurrentQuestion() {
        responses[stepIndex].rank = nil
        responses[stepIndex].skipped = true
        advance()
    }

    private func advance() {
        if stepIndex >= questions.count - 1 {
            showSummary = true
        } else {
            stepIndex += 1
        }
    }

    private func likelihoodLabel(for rank: Int) -> String {
        switch rank {
        case 5: return "Very likely"
        case 4: return "Likely"
        case 3: return "Neutral"
        case 2: return "Unlikely"
        default: return "Very unlikely"
        }
    }
}

#Preview {
    IntakeFormView()
        .environmentObject(AppState())
}
