import SwiftUI

/// Controls who can see profile, garden, online status, and groups.
struct PrivacySettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                visibilitySection(
                    title: "Profile",
                    icon: "person.crop.circle",
                    selection: $appState.privacySettings.profileVisibility
                )

                visibilitySection(
                    title: "Garden",
                    icon: "leaf.circle",
                    selection: $appState.privacySettings.gardenVisibility
                )

                visibilitySection(
                    title: "Online Status",
                    icon: "circle.fill",
                    selection: $appState.privacySettings.onlineStatusVisibility
                )

                visibilitySection(
                    title: "Groups",
                    icon: "person.3.fill",
                    selection: $appState.privacySettings.groupsVisibility
                )

                searchabilitySection
                coOpSection
            }
            .padding()
        }
    }

    private func visibilitySection(
        title: String,
        icon: String,
        selection: Binding<VisibilityLevel>
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(title, systemImage: icon)
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            Picker("\(title) Visibility", selection: selection) {
                ForEach(VisibilityLevel.allCases) { level in
                    Text(level.rawValue).tag(level)
                }
            }
            .pickerStyle(.menu)
            .tint(Theme.teal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var searchabilitySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Searchability", systemImage: "magnifyingglass")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            Toggle("Allow others to find me", isOn: $appState.privacySettings.isSearchable)
                .font(Theme.bodyText)
                .tint(Theme.teal)

            Text("Hidden from discovery when off.")
                .font(Theme.supportingText)
                .foregroundStyle(Theme.textDark.opacity(0.6))
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var coOpSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("CO-OP Sharing", systemImage: "lock.shield.fill")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            Toggle("Participate in CO-OP", isOn: $appState.privacySettings.participateInCoOp)
                .font(Theme.bodyText)
                .tint(Theme.teal)

            Toggle("Share Greenhouse Progress", isOn: $appState.privacySettings.shareGreenhouseProgress)
                .font(Theme.bodyText)
                .tint(Theme.teal)

            Toggle("Allow Shared Activities", isOn: $appState.privacySettings.allowSharedActivities)
                .font(Theme.bodyText)
                .tint(Theme.teal)
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    PrivacySettingsView()
        .environmentObject(AppState())
}
