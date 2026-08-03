import SwiftUI

/// Simple picker when replacing the weekly streak plant from home.
struct WeeklyPlantPickerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedKind: PlantKind = .sunflower

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Pick Your Next Weekly Plant")
                        .font(Theme.sectionTitle)
                        .foregroundStyle(Theme.textDark)
                        .padding(.top, 8)

                    ForEach(PlantKind.allCases) { kind in
                        Button {
                            selectedKind = kind
                        } label: {
                            HStack(spacing: 14) {
                                PlantImageView(kind: kind, stage: .medium, height: 64)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(kind.displayName)
                                        .font(Theme.rowTitle)
                                        .foregroundStyle(Theme.textDark)
                                    Text(kind.meaningText)
                                        .font(Theme.bodyText)
                                        .foregroundStyle(Theme.textDark.opacity(0.75))
                                        .multilineTextAlignment(.leading)
                                }

                                Spacer()

                                Image(systemName: selectedKind == kind ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(selectedKind == kind ? Theme.teal : Theme.teal.opacity(0.35))
                            }
                            .padding()
                            .background(Color.white.opacity(0.92))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(selectedKind == kind ? Theme.teal : Color.clear, lineWidth: 2)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    PrimaryCapsuleButton(
                        title: "Start \(selectedKind.displayName) This Week",
                        isEnabled: true
                    ) {
                        appState.replaceWeeklyPlant(with: selectedKind)
                        dismiss()
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .padding()
            }
            .onAppear {
                selectedKind = appState.selectedPlantKind
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Theme.teal)
                }
            }
        }
    }
}

#Preview {
    WeeklyPlantPickerView()
        .environmentObject(AppState())
}
