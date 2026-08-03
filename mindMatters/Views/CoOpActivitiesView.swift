import SwiftUI

/// CO-OP challenges and friend discovery in one place.
struct CoOpActivitiesView: View {
    @EnvironmentObject var appState: AppState

    @State private var selectedSection = 0
    @State private var selectedMode: CoOpMode = .active
    @State private var friendsTab = 0
    @State private var priorityFilter: GardenPriority?
    @State private var searchQuery = ""
    @State private var foundProfile: ConnectionProfile?
    @State private var searchMessage = ""

    private var filteredActivities: [CoOpActivity] {
        appState.coOpActivities.filter { $0.mode == selectedMode }
    }

    var body: some View {
        VStack(spacing: 16) {
            Picker("Section", selection: $selectedSection) {
                Text("Activities").tag(0)
                Text("Find Friends").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if selectedSection == 0 {
                activitiesSection
            } else {
                findFriendsSection
            }
        }
    }

    // MARK: - Activities

    private var activitiesSection: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("Co-op Mode", selection: $selectedMode) {
                    ForEach(CoOpMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                ForEach(filteredActivities) { activity in
                    activityCard(activity)
                }
            }
            .padding()
        }
    }

    private func activityCard(_ activity: CoOpActivity) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(activity.title)
                    .font(Theme.rowTitle)
                    .foregroundStyle(Theme.textDark)
                Spacer()
                Text("\(activity.participantCount) people")
                    .font(Theme.supportingText)
                    .foregroundStyle(Theme.teal)
            }

            Text(activity.detail)
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.75))

            Label(activity.priority.rawValue, systemImage: "leaf.fill")
                .font(Theme.supportingText)
                .foregroundStyle(Theme.textDark.opacity(0.6))

            if activity.mode == .group {
                ProgressView(value: Double(activity.progress), total: Double(activity.goal))
                    .tint(Theme.teal)
                Text("\(activity.progress)/\(activity.goal) progress")
                    .font(Theme.supportingText)
                    .foregroundStyle(Theme.textDark.opacity(0.6))
            }

            Button(activity.mode == .active ? "Start Together" : "Join Group") {}
                .font(Theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(Theme.teal)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Find Friends

    private var findFriendsSection: some View {
        VStack(spacing: 16) {
            Picker("Find Friends", selection: $friendsTab) {
                Text("Discover New").tag(0)
                Text("Find Existing").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            if friendsTab == 0 {
                discoverSection
            } else {
                existingSection
            }
        }
    }

    private var discoverSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Match by priority or interests.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        filterChip(title: "All", priority: nil)
                        ForEach(GardenPriority.allCases) { priority in
                            filterChip(title: priority.rawValue, priority: priority)
                        }
                    }
                    .padding(.horizontal)
                }

                ForEach(appState.discoverUsers(matching: priorityFilter)) { user in
                    discoverCard(for: user)
                }
            }
            .padding(.bottom, 24)
        }
    }

    private var existingSection: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("Search by username or phone.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .leading)

                TextField("Username or phone #", text: $searchQuery)
                    .font(Theme.bodyText)
                    #if os(iOS)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.default)
                    #endif
                    .padding(12)
                    .background(Color.white.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                Button("Search") {
                    performSearch()
                }
                .font(Theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Theme.teal)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 14))

                if let profile = foundProfile {
                    existingResultCard(profile)
                } else if !searchMessage.isEmpty {
                    Text(searchMessage)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                }
            }
            .padding()
        }
    }

    private func filterChip(title: String, priority: GardenPriority?) -> some View {
        let isSelected = priorityFilter == priority

        return Button {
            priorityFilter = priority
        } label: {
            Text(title)
                .font(Theme.bodyText.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.teal : Color.white.opacity(0.92))
                .foregroundStyle(isSelected ? .white : Theme.teal)
                .clipShape(Capsule())
        }
    }

    private func discoverCard(for user: DiscoverableUser) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(Theme.rowTitle)
                        .foregroundStyle(Theme.textDark)
                    Text("@\(user.username)")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.6))
                }

                Spacer()

                Text("\(user.matchScore)% match")
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(Theme.teal)
            }

            Text(user.bio)
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.8))

            HStack(spacing: 12) {
                Label(user.major, systemImage: "graduationcap.fill")
                Label(user.focusedPriority.rawValue, systemImage: "leaf.fill")
            }
            .font(Theme.supportingText)
            .foregroundStyle(Theme.textDark.opacity(0.7))

            Text(user.hobbies.joined(separator: " · "))
                .font(Theme.supportingText)
                .foregroundStyle(Theme.textDark.opacity(0.6))

            Button("Connect") {
                appState.addConnection(from: user)
            }
            .font(Theme.buttonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Theme.sage)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private func existingResultCard(_ profile: ConnectionProfile) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(profile.name)
                    .font(Theme.rowTitle)
                    .foregroundStyle(Theme.textDark)
                Spacer()
                if profile.isOnline {
                    Label("Online", systemImage: "circle.fill")
                        .font(Theme.supportingText)
                        .foregroundStyle(.green)
                }
            }

            Text("@\(profile.username)")
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.6))

            Text("Focus: \(profile.focusedPriority.rawValue)")
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.75))

            Button("Add Connection") {
                appState.connectExisting(profile)
                searchMessage = "Connected with \(profile.name)!"
            }
            .font(Theme.buttonText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background(Theme.teal)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func performSearch() {
        foundProfile = appState.findExistingConnection(query: searchQuery)
        searchMessage = foundProfile == nil ? "No user found. Try a different username." : ""
    }
}

#Preview {
    CoOpActivitiesView()
        .environmentObject(AppState())
}
