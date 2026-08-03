import SwiftUI

/// Lets the user assign each plant to one garden priority via dropdown menus.
struct PriorityPlantMappingView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var isOnboarding: Bool = true

    @State private var mapping: [GardenPriority: PlantKind] = [:]

    private var allAssigned: Bool {
        mapping.count == GardenPriority.allCases.count
            && Set(mapping.values).count == PlantKind.allCases.count
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    MindMattersLogoView(size: 64)
                        .padding(.top, 16)

                    Text(isOnboarding ? "Match Plants to Priorities" : "Edit Priority Plants")
                        .font(Theme.pageTitle)
                        .foregroundColor(Theme.textDark)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    Text("Choose a priority for each plant. Used priorities won't appear in other menus.")
                        .font(Theme.bodyText)
                        .foregroundColor(Theme.textDark.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)

                    VStack(spacing: 14) {
                        ForEach(PlantKind.allCases) { kind in
                            plantRow(for: kind)
                        }
                    }

                    PrimaryCapsuleButton(
                        title: isOnboarding ? "Continue" : "Save",
                        isEnabled: allAssigned,
                        action: confirmMapping
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            mapping = appState.priorityPlantMapping
        }
    }

    private func plantRow(for kind: PlantKind) -> some View {
        HStack(spacing: 14) {
            PlantImageView(kind: kind, stage: .medium, height: 64)
                .frame(width: 64)

            VStack(alignment: .leading, spacing: 8) {
                Text(kind.displayName)
                    .font(Theme.rowTitle)
                    .foregroundStyle(Theme.textDark)

                Picker("Priority", selection: priorityBinding(for: kind)) {
                    Text("Select priority").tag(GardenPriority?.none)
                    ForEach(availablePriorities(for: kind)) { priority in
                        Text(priority.rawValue).tag(Optional(priority))
                    }
                }
                .pickerStyle(.menu)
                .tint(Theme.teal)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    /// Priorities available for this plant: unassigned ones plus its current selection.
    private func availablePriorities(for plant: PlantKind) -> [GardenPriority] {
        let current = priority(for: plant)
        return GardenPriority.allCases.filter { priority in
            priority == current || mapping[priority] == nil
        }
    }

    private func priority(for plant: PlantKind) -> GardenPriority? {
        mapping.first(where: { $0.value == plant })?.key
    }

    private func priorityBinding(for plant: PlantKind) -> Binding<GardenPriority?> {
        Binding(
            get: { priority(for: plant) },
            set: { newPriority in
                if let oldPriority = priority(for: plant) {
                    mapping.removeValue(forKey: oldPriority)
                }
                if let newPriority {
                    mapping[newPriority] = plant
                }
            }
        )
    }

    private func confirmMapping() {
        guard allAssigned else { return }

        if isOnboarding {
            appState.applyPriorityPlantMapping(mapping)
        } else {
            appState.savePriorityPlantMapping(mapping)
            dismiss()
        }
    }
}

#Preview {
    PriorityPlantMappingView()
        .environmentObject(AppState())
}
