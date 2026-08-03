//
//  HomeView.swift
//  mindMatters
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddTask = false
//    @State private var plantScale: CGFloat = 1.0

    private let primaryTeal = Theme.teal
    private let darkText = Theme.textDark

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        topBar
//                        plantOfTheWeekSection
                        gardenSection
                        tasksSection
//                        connectionSection
                    }
                    .padding()
                    .padding(.bottom, 100)
                }

                BottomStatusBar(
                    energy: appState.energyPoints,
                    highlightEndDay: appState.highlightEndDay,
                    onEndDay: { appState.endDay() },
                    onPointsTap: { appState.navigateTo(.rewardsShop) }
                )
                .padding(.bottom, 12)
            }

            if appState.showConfetti {
                ConfettiView()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $appState.showStreakPopup) {
            StreakPopupView().environmentObject(appState)
        }
        .sheet(isPresented: $appState.streakBroken) {
            StreakBrokenView().environmentObject(appState)
        }
        .sheet(isPresented: $appState.showWeeklyPlantPicker) {
            WeeklyPlantPickerView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showPlantingAfterReplacement) {
            PlantingView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showJournalReflection) {
            JournalReflectionView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $showAddTask) {
            AddCustomTaskView()
                .environmentObject(appState)
        }
    }

    private var topBar: some View {
        AppPageTopBar()
    }

    /*
    private var plantOfTheWeekSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionHeader("Plant of the Week", icon: "leaf.fill")
                Spacer()
                Button {
                    appState.navigateTo(.streakCalendar)
                } label: {
                    Label("\(appState.currentStreak)", systemImage: "flame.fill")
                        .font(Theme.bodyText.weight(.semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.92))
                        .clipShape(Capsule())
                }
                .accessibilityLabel("View activity calendar, \(appState.currentStreak) day streak")
            }

            VStack(spacing: 14) {
                HStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Health", systemImage: "heart.fill")
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.textDark.opacity(0.7))
                        ProgressView(value: Double(appState.plantHealthScore), total: 100)
                            .tint(appState.isPlantHealthy ? Theme.sage : .orange)
                        Text("\(appState.plantHealthScore)%")
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.textDark.opacity(0.6))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Label("Growth", systemImage: "arrow.up.circle.fill")
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.textDark.opacity(0.7))
                        ProgressView(value: appState.todayTaskProgress)
                            .tint(primaryTeal)
                        Text("\(appState.completedTaskIDs.count)/\(appState.dailyActivities.count) today")
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.textDark.opacity(0.6))
                    }
                }

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        plantScale = 1.12
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring()) { plantScale = 1.0 }
                    }
                } label: {
                    PlantImageView(
                        kind: appState.selectedPlantKind,
                        stage: appState.displayPlantStage,
                        isWilted: appState.isStreakPlantWilted,
                        height: 140
                    )
                    .scaleEffect(appState.plantGrowthPulse ? 1.08 : plantScale)
                    .animation(.spring(response: 0.35), value: appState.plantGrowthPulse)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Your weekly plant. Tap to see it grow.")

                HStack {
                    Text(appState.selectedPlantKind.displayName)
                        .font(Theme.rowTitle)
                        .foregroundStyle(darkText)

                    Spacer()

                    Text("Growth Day \(appState.growthDaysOnCurrentPlant)")
                        .font(Theme.bodyText.weight(.semibold))
                        .foregroundStyle(primaryTeal)
                }

                if appState.allDoneToday {
                    Text("All done — tap End Day.")
                        .font(Theme.supportingText)
                        .foregroundStyle(primaryTeal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                if appState.canPickNewWeeklyPlant {
                    Button {
                        appState.beginWeeklyPlantReplacement()
                    } label: {
                        Label(
                            appState.isWeeklyPlantMature ? "Pick a New Plant" : "New Weekly Plant",
                            systemImage: "leaf.circle"
                        )
                        .font(Theme.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(primaryTeal)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
            }
            .padding()
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    */

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                sectionHeader("Today's Tasks", icon: "checkmark.circle.fill")
                Spacer()
                Button {
                    appState.navigateTo(.streakCalendar)
                } label: {
                    Label("\(appState.currentStreak)", systemImage: "flame.fill")
                        .font(Theme.bodyText.weight(.semibold))
                        .foregroundStyle(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.92))
                        .clipShape(Capsule())
                }
                .accessibilityLabel("View activity calendar, \(appState.currentStreak) day streak")
            }

            if appState.metStreakGoalToday {
                Text("Streak ready — tap End Day.")
                    .font(Theme.supportingText)
                    .foregroundStyle(primaryTeal)
            }

            if appState.dailyActivities.isEmpty {
                Text("Finish intake to get your daily tasks.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
            } else {
                ForEach(appState.dailyActivities) { task in
                    taskRow(task: task)
                }

                Button {
                    showAddTask = true
                } label: {
                    Label("Add Task", systemImage: "plus.circle.fill")
                        .font(Theme.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .foregroundStyle(primaryTeal)
                        .background(Color.white.opacity(0.92))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(primaryTeal.opacity(0.35), lineWidth: 1)
                        )
                }
            }
        }
    }

    private var gardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Priority Garden", icon: "leaf.circle.fill")

            Button {
                appState.navigateTo(.priorityBreakdown)
            } label: {
                VStack(spacing: 12) {
                    HStack(alignment: .bottom, spacing: 6) {
                        ForEach(appState.gardenProfiles) { plant in
                            PottedPlantView(
                                kind: plant.kind,
                                stage: plant.stage,
                                potAssetName: plant.potAssetName,
                                plantHeight: 105,
                                potHeight: 46
                            )
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 24)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            .buttonStyle(.plain)

            Button {
                appState.navigateTo(.greenhouse)
            } label: {
                Label("View Greenhouse", systemImage: "house.lodge.fill")
                    .font(Theme.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(primaryTeal)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
        }
    }

    /*
    @ViewBuilder
    private var connectionSection: some View {
        VStack(spacing: 12) {
            Button {
                appState.navigateTo(.coOpActivities)
            } label: {
                Label("CO-OP Activities", systemImage: "person.3.fill")
                    .font(Theme.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.92))
                    .foregroundStyle(primaryTeal)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(primaryTeal.opacity(0.35), lineWidth: 1)
                    )
            }

            if appState.hasConnection {
                NavigationLink(value: AppDestination.connectionGreenhouse(appState.connectionName)) {
                    Label(
                        "Visit \(appState.connectionName)'s Greenhouse",
                        systemImage: "person.2.fill"
                    )
                    .font(Theme.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryTeal)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            } else {
                NavigationLink(value: AppDestination.relationshipCheckIn) {
                    Label("Add a Connection", systemImage: "person.badge.plus")
                        .font(Theme.buttonText)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.92))
                        .foregroundStyle(primaryTeal)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(primaryTeal.opacity(0.35), lineWidth: 1)
                        )
                }
            }
        }
    }
    */

    private func sectionHeader(_ title: String, icon: String) -> some View {
        Label(title, systemImage: icon)
            .font(Theme.sectionTitle)
            .foregroundStyle(primaryTeal)
    }

    private func taskRow(task: TaskItem) -> some View {
        let isDone = appState.completedTaskIDs.contains(task.id)

        return Button {
            appState.toggleComplete(task)
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(task.category.tint.opacity(0.15))
                        .frame(width: 50, height: 50)

                    Image(systemName: task.category.symbol)
                        .font(.title2)
                        .foregroundStyle(task.category.tint)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(task.title)
                            .font(Theme.rowTitle)
                            .foregroundStyle(darkText)
                            .multilineTextAlignment(.leading)
                            .strikethrough(isDone)

                        if task.isCustom {
                            Text("Custom")
                                .font(.caption2.weight(.semibold))
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Theme.sage.opacity(0.25))
                                .foregroundStyle(Theme.teal)
                                .clipShape(Capsule())
                        }
                    }
                }

                Spacer()

                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isDone ? primaryTeal : primaryTeal.opacity(0.5))
                    .symbolEffect(.bounce, value: isDone)
            }
            .padding()
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Plant Overview

struct PlantOverviewView: View {
    @EnvironmentObject var appState: AppState
    var showLogo: Bool = true

    private let primaryTeal = Theme.teal
    private let darkText = Theme.textDark

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if showLogo {
                    MindMattersLogoView(size: 64)
                }

                ForEach(appState.gardenProfiles) { plant in
                    plantRow(profile: plant)
                }
            }
            .padding()
        }
    }

    private func plantRow(profile: GardenPlantProfile) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                PottedPlantView(
                    kind: profile.kind,
                    stage: profile.stage,
                    potAssetName: profile.potAssetName,
                    plantHeight: 56,
                    potHeight: 22
                )
                .frame(width: 56)

                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(Theme.rowTitle)
                        .foregroundStyle(darkText)

                    Text(profile.category)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                }

                Spacer()

                Text("\(profile.progress)%")
                    .font(Theme.rowTitle)
                    .foregroundStyle(primaryTeal)
            }

            ProgressView(value: Double(profile.progress), total: 100)
                .tint(primaryTeal)
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AppState())
    }
}
