//
//  HomeView.swift
//  mindMatters
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showPlantDetails = false

    private let primaryTeal = Theme.teal
    private let darkText = Theme.textDark

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 24) {
                        topBar
                        plantOfTheWeekSection
                        tasksSection
                        gardenSection
                        connectionSection
                    }
                    .padding()
                    .padding(.bottom, 100)
                }

                BottomStatusBar(
                    streak: appState.currentStreak,
                    energy: appState.energyPoints,
                    onEndDay: { appState.endDay() }
                )
                .padding(.bottom, 12)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPlantDetails) {
            PlantOverviewView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showPriorityBreakdown) {
            PlantOverviewView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showAppMenu) {
            AppMenuView()
                .environmentObject(appState)
        }
        .sheet(isPresented: $appState.showResources) {
            ResourcesHubView()
        }
        .sheet(isPresented: $appState.showStreakPopup) {
            StreakPopupView().environmentObject(appState)
        }
        .sheet(isPresented: $appState.streakBroken) {
            StreakBrokenView().environmentObject(appState)
        }
        .sheet(isPresented: $appState.showWeeklyPlantPicker) {
            ChoosePlantView(isReplacingWeeklyPlant: true)
                .environmentObject(appState)
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                appState.showAppMenu = true
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundStyle(primaryTeal)
                    .padding(8)
            }
            .accessibilityLabel("Open menu")

            Spacer()

            MindMattersLogoView(size: 52)

            Spacer()

            Button {
                appState.showAppMenu = true
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(primaryTeal)
            }
            .accessibilityLabel("Open profile menu")
        }
    }

    private var plantOfTheWeekSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Plant of the Week", icon: "flame.fill")

            VStack(spacing: 14) {
                PlantImageView(
                    kind: appState.selectedPlantKind,
                    stage: appState.plantOfTheWeekStage,
                    isWilted: appState.isStreakPlantWilted,
                    height: 140
                )

                HStack {
                    Text(appState.selectedPlantKind.displayName)
                        .font(Theme.rowTitle)
                        .foregroundStyle(darkText)

                    Spacer()

                    Text("\(appState.currentStreak) day streak")
                        .font(Theme.bodyText.weight(.semibold))
                        .foregroundStyle(primaryTeal)
                }

                if appState.currentWeeklyPlantDay > 0 {
                    Text("Day \(appState.currentWeeklyPlantDay) with this plant")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Text("Finish all daily tasks to grow your streak. Each new plant starts at day 1 on your next streak day.")
                    .font(Theme.supportingText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
                    .frame(maxWidth: .infinity, alignment: .leading)

                if appState.canPickNewWeeklyPlant {
                    Button {
                        appState.beginWeeklyPlantReplacement()
                    } label: {
                        Label("Pick a New Weekly Plant", systemImage: "leaf.circle")
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

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Today's Tasks", icon: "checkmark.circle.fill")

            if appState.dailyActivities.isEmpty {
                Text("Finish intake to get your daily tasks.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
            } else {
                ForEach(appState.dailyActivities) { task in
                    taskRow(task: task)
                }
            }
        }
    }

    private var gardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Your Garden", icon: "leaf.circle.fill")

            Button {
                showPlantDetails = true
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

                    Text("Tap to view your priority breakdown.")
                        .font(Theme.supportingText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                }
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var connectionSection: some View {
        if appState.hasConnection {
            NavigationLink {
                ConnectionGreenhouseView(connectionName: appState.connectionName)
            } label: {
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
            NavigationLink {
                RelationshipCheckInView()
            } label: {
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
                    Text(task.title)
                        .font(Theme.rowTitle)
                        .foregroundStyle(darkText)
                        .multilineTextAlignment(.leading)
                        .strikethrough(isDone)

                    Text(task.category.priorityLabel)
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                }

                Spacer()

                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(isDone ? primaryTeal : primaryTeal.opacity(0.5))
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

    private let primaryTeal = Theme.teal
    private let darkText = Theme.textDark

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    MindMattersLogoView(size: 64)

                    Text("Your Plant Priorities")
                        .font(Theme.pageTitle)
                        .foregroundStyle(darkText)
                        .multilineTextAlignment(.center)

                    Text("Percentages show where your completed tasks are focused.")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                        .multilineTextAlignment(.center)

                    ForEach(appState.gardenProfiles) { plant in
                        plantRow(profile: plant)
                    }
                }
                .padding()
            }
        }
        .presentationDetents([.medium, .large])
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
