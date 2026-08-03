import SwiftUI

/// Sheet for adding a user-defined task to today's list.
struct AddCustomTaskView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var selectedCategory: TaskCategory = .mentalHealth

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Add Task")
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textDark)

                    TextField("What do you want to do today?", text: $title)
                        .font(Theme.bodyText)
                        .padding(12)
                        .background(Color.white.opacity(0.92))
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Category")
                            .font(Theme.bodyText.weight(.semibold))
                            .foregroundStyle(Theme.textDark)

                        Picker("Category", selection: $selectedCategory) {
                            ForEach(TaskCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Button("Add Task") {
                        appState.addCustomTask(title: title, category: selectedCategory)
                        dismiss()
                    }
                    .font(Theme.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Theme.teal)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.teal)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    AddCustomTaskView()
        .environmentObject(AppState())
}
