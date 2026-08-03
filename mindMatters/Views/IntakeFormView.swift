import SwiftUI

struct IntakeFormView: View {
    @EnvironmentObject var appState: AppState

    @State private var stepIndex = 0
    @State private var draftPreferences: [CategoryPreference] = TaskCategory.allCases.map {
        CategoryPreference(category: $0)
    }

    private var currentCategory: TaskCategory {
        TaskCategory.allCases[stepIndex]
    }

    private var currentPreference: CategoryPreference {
        draftPreferences[stepIndex]
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 24) {
                progressHeader

                Text("Quick Intake")
                    .font(Theme.sectionTitle)
                    .foregroundColor(Theme.textDark)

                Text("Rank \(currentCategory.rawValue.lowercased()) activities")
                    .font(Theme.bodyText)
                    .foregroundColor(Theme.textDark.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                categoryCard

                rankingSection(
                    title: "How likely are you to do this?",
                    value: currentPreference.rank
                ) { newValue in
                    updateDraft(rank: newValue)
                }

                navigationButtons

                Spacer()
            }
            .padding(.top)
        }
    }

    private var progressHeader: some View {
        VStack(spacing: 8) {
            ProgressView(
                value: Double(stepIndex + 1),
                total: Double(TaskCategory.allCases.count)
            )
            .tint(Theme.teal)
            .padding(.horizontal)

            HStack(spacing: 8) {
                ForEach(Array(TaskCategory.allCases.enumerated()), id: \.offset) { index, category in
                    Circle()
                        .fill(index <= stepIndex ? Theme.teal : Theme.teal.opacity(0.25))
                        .frame(width: 8, height: 8)
                        .accessibilityLabel(category.rawValue)
                }
            }
        }
    }

    private var categoryCard: some View {
        VStack(spacing: 12) {
            Label(currentCategory.rawValue, systemImage: currentCategory.symbol)
                .font(Theme.bodyText.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Theme.sage.opacity(0.2))
                .foregroundColor(Theme.teal)
                .clipShape(Capsule())

            Text(samplePrompt(for: currentCategory))
                .font(Theme.bodyText)
                .foregroundColor(Theme.textDark.opacity(0.8))
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .padding(.horizontal)
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
                Text(stepIndex == TaskCategory.allCases.count - 1 ? "Finish" : "Next")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
            .font(Theme.buttonText)
            .foregroundColor(.white)
            .background(Theme.sage)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(.horizontal)
    }

    private func rankingSection(
        title: String,
        value: Int,
        onSelect: @escaping (Int) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.bodyText.weight(.semibold))
                .foregroundColor(Theme.textDark)
                .padding(.horizontal)

            HStack(spacing: 8) {
                ForEach(1...5, id: \.self) { rank in
                    SelectableCapsuleButton("\(rank)", isSelected: rank == value) {
                        onSelect(rank)
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

    private func samplePrompt(for category: TaskCategory) -> String {
        switch category {
        case .social: return "Friends, classmates, and people around you."
        case .academic: return "Studying, planning, and school work."
        case .finance: return "Saving, spending, and money habits."
        case .mentalHealth: return "Movement, mindfulness, and self-care."
        }
    }

    private func updateDraft(rank: Int) {
        var preference = draftPreferences[stepIndex]
        preference.rank = rank
        draftPreferences[stepIndex] = preference
    }

    private func advance() {
        appState.updateCategoryPreference(draftPreferences[stepIndex])

        if stepIndex >= TaskCategory.allCases.count - 1 {
            appState.categoryPreferences = draftPreferences
            appState.finishIntake()
        } else {
            stepIndex += 1
        }
    }
}

#Preview {
    IntakeFormView()
        .environmentObject(AppState())
}
