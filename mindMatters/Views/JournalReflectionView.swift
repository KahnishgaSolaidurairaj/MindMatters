import SwiftUI

/// Optional post-task reflection sheet with a skip path.
struct JournalReflectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var reflectionText = ""

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed.fill")
                .font(.system(size: 48))
                .foregroundStyle(Theme.teal)

            Text("How did that feel?")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.textDark)

            if let task = appState.pendingJournalTask {
                Text(task.title)
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
                    .wrapping(.center)
                    .frame(maxWidth: .infinity)
            }

            TextEditor(text: $reflectionText)
                .font(Theme.bodyText)
                .frame(height: 120)
                .padding(8)
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.teal.opacity(0.25), lineWidth: 1)
                )

            Button("Save Reflection") {
                appState.saveJournalEntry(text: reflectionText)
            }
            .font(Theme.buttonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Theme.teal)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .disabled(reflectionText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

            Button("Skip") {
                appState.dismissJournalReflection()
            }
            .font(Theme.buttonText)
            .foregroundStyle(Theme.teal)
        }
        .padding()
        .presentationDetents([.medium])
    }
}

#Preview {
    JournalReflectionView()
        .environmentObject({
            let state = AppState()
            state.pendingJournalTask = TaskDatabase.all.first
            return state
        }())
}
