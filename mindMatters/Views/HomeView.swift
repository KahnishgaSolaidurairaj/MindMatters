//
//  HomeView.swift
//  mindMatters
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    // @Environment(\.scenePhase) private var scenePhase
    @State private var showAddTask = false
    @State private var knowMoreTask: TaskItem?
    @State private var endDayButtonPulsing = false
//    @State private var plantScale: CGFloat = 1.0

    private let primaryTeal = Theme.teal
    private let darkText = Theme.textDark

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                AppPageTopBar()
                    .padding(.horizontal, 4)
                    .padding(.top, 8)
                    .zIndex(1)

                ScrollView {
                    VStack(spacing: 24) {
                        gardenSection
                        tasksSection
                    }
                    .padding()
                    .padding(.bottom, 24)
                }
            }

            if appState.showWateringCelebration {
                WateringCelebrationView()
                    .id(appState.wateringCelebrationToken)
                    .zIndex(2)
            }

            if appState.showConfetti {
                ConfettiView()
                    .zIndex(3)
                    .allowsHitTesting(false)
            }

            /*
            if appState.showMotivationPopup {
                VStack {
                    MotivationPopupView(message: appState.motivationMessage) {
                        appState.dismissMotivationPopup()
                    }
                    .padding(.top, 12)
                    Spacer()
                }
                .zIndex(1)
                .task(id: appState.motivationMessage) {
                    try? await Task.sleep(for: .seconds(5))
                    appState.dismissMotivationPopup()
                }
            }
            */
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        /*
        .onAppear {
            appState.presentMotivationPopup()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                appState.presentMotivationPopup()
            }
        }
        */
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
        .sheet(item: $knowMoreTask) { task in
            TaskKnowMoreView(task: task)
        }
    }

    /*
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
                HStack(spacing: 8) {
                    Button {
                        appState.navigateTo(.rewardsShop)
                    } label: {
                        Label("\(appState.energyPoints)", systemImage: BloomCurrency.icon)
                            .font(Theme.bodyText.weight(.semibold))
                            .foregroundStyle(primaryTeal)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.92))
                            .clipShape(Capsule())
                    }
                    .accessibilityLabel("\(appState.energyPoints) \(BloomCurrency.displayName). Tap to open rewards shop.")

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
            }

            if !appState.metStreakGoalToday {
                Text("Complete 1 task in each category to earn today's streak.")
                    .font(Theme.supportingText)
                    .foregroundStyle(Theme.textDark.opacity(0.55))
            }

            streakCategoryProgress

            if appState.dailyActivities.isEmpty {
                Text("Finish intake to get your daily tasks.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
            } else {
                if appState.metStreakGoalToday {
                    Text("Streak ready — tap End Day.")
                        .font(Theme.supportingText)
                        .foregroundStyle(primaryTeal)

                    endDayButton
                        .transition(.move(edge: .top).combined(with: .opacity))
                }

                ForEach(appState.dailyActivities) { task in
                    DailyTaskRow(
                        task: task,
                        isDone: appState.completedTaskIDs.contains(task.id),
                        onToggle: { appState.toggleComplete(task) },
                        onKnowMore: { knowMoreTask = task }
                    )
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
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: appState.metStreakGoalToday)
    }

    private var endDayButton: some View {
        Button {
            appState.endDay()
        } label: {
            Label("End Day", systemImage: "arrow.right.circle.fill")
                .font(Theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .foregroundStyle(.white)
                .background(Theme.sage)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .accessibilityLabel("End day to grow your plant")
        .scaleEffect(endDayButtonPulsing ? 1.04 : 1.0)
        .onAppear { updateEndDayPulse(isReady: appState.metStreakGoalToday) }
        .onChange(of: appState.metStreakGoalToday) { _, isReady in
            updateEndDayPulse(isReady: isReady)
        }
    }

    private func updateEndDayPulse(isReady: Bool) {
        if isReady {
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) {
                endDayButtonPulsing = true
            }
        } else {
            endDayButtonPulsing = false
        }
    }

    private var gardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Priority Garden", icon: "leaf.circle.fill")

            Button {
                appState.navigateTo(.priorityBreakdown)
            } label: {
                VStack(spacing: 12) {
                    PriorityGardenBenchView(profiles: appState.gardenProfiles)
                        .padding(.horizontal, 8)
                        .padding(.top, 24)
                        .padding(.bottom, 8)
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

    private var streakCategoryProgress: some View {
        HStack(spacing: 8) {
            ForEach(TaskCategory.allCases) { category in
                let isComplete = appState.hasCompletedCategory(category)
                VStack(spacing: 4) {
                    Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                        .foregroundStyle(isComplete ? primaryTeal : Theme.textDark.opacity(0.25))
                    Text(category.rawValue)
                        .font(.caption2)
                        .foregroundStyle(isComplete ? Theme.textDark : Theme.textDark.opacity(0.45))
                        .wrapping(.center)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
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

                priorityChartCard

                ForEach(appState.gardenProfiles) { plant in
                    plantRow(profile: plant)
                }
            }
            .padding()
        }
    }

    private var priorityChartCard: some View {
        let slices = PriorityPieChartView.slices(from: appState.gardenProfiles)

        return VStack(alignment: .leading, spacing: 16) {
            Text("Priority Balance")
                .font(Theme.sectionTitle)
                .foregroundStyle(primaryTeal)

            HStack(alignment: .center, spacing: 20) {
                PriorityPieChartView(slices: slices)
                    .frame(width: 160, height: 160)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(slices) { slice in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(slice.color)
                                .frame(width: 10, height: 10)

                            Text(slice.label)
                                .font(Theme.supportingText)
                                .foregroundStyle(Theme.textDark.opacity(0.8))
                                .wrapping()

                            Spacer(minLength: 4)

                            Text("\(Int(slice.value))%")
                                .font(Theme.supportingText.weight(.semibold))
                                .foregroundStyle(primaryTeal)
                        }
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func plantRow(profile: GardenPlantProfile) -> some View {
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
                    .wrapping()
            }

            Spacer()

            Text("\(profile.progress)%")
                .font(Theme.rowTitle)
                .foregroundStyle(primaryTeal)
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
