//
//  HomeView.swift
//  mindMatters
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showPlantDetails = false

    private let backgroundCream = Theme.background
    private let primaryTeal = Theme.teal
    private let darkText = Theme.textDark

    var body: some View {
        ZStack {
            backgroundCream
                .ignoresSafeArea()

            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        topBar
                        gardenSection
                        tasksSection

                        if appState.hasConnection {
                            NavigationLink {
                                ConnectionGreenhouseView(connectionName: appState.connectionName)
                            } label: {
                                Label(
                                    "Visit \(appState.connectionName)'s Greenhouse",
                                    systemImage: "person.2.fill"
                                )
                                .font(.headline)
                                .fontWeight(.semibold)
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
                                Label(
                                    "Add a Connection",
                                    systemImage: "person.badge.plus"
                                )
                                .font(.headline)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.9))
                                .foregroundStyle(primaryTeal)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(primaryTeal.opacity(0.35), lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding()
                    .padding(.bottom, 100)
                }

                BottomStatusBar(
                    streak: appState.currentStreak,
                    energy: appState.energyPoints,
                    onEndDay: { appState.endDay() },
                    onResourcesTap: { appState.showResources = true }
                )
                .padding(.bottom, 12)
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPlantDetails) {
            PlantOverviewView()
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

            Spacer()

            MindMattersLogoView(size: 36)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()

            Button {
                appState.showAppMenu = true
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(primaryTeal)
            }
        }
    }

    private var gardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Your Garden", systemImage: "leaf.circle.fill")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(primaryTeal)

            Button {
                showPlantDetails = true
            } label: {
                VStack(spacing: 14) {
                    ZStack(alignment: .bottom) {
                        Image(GardenCatalog.backgroundAssets[0])
                            .resizable()
                            .scaledToFill()
                            .frame(height: 245)
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.12))

                        VStack(spacing: 6) {
                            HStack(alignment: .bottom, spacing: 8) {
                                ForEach(GardenCatalog.plants) { plant in
                                    PottedPlantView(
                                        kind: plant.kind,
                                        stage: plant.stage,
                                        potAssetName: plant.potAssetName,
                                        plantHeight: 52,
                                        potHeight: 24
                                    )
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.horizontal, 10)

                            Image("my_plants_asset-08")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 28)
                                .padding(.horizontal, 28)
                        }
                        .padding(.bottom, 16)
                    }
                    .frame(height: 245)
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Text("Tap the garden to view all plants and progress")
                        .font(.caption)
                        .foregroundStyle(Theme.textDark.opacity(0.6))
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Today's Tasks", systemImage: "checkmark.circle.fill")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(primaryTeal)

            if appState.dailyActivities.isEmpty {
                Text("Complete your intake to receive personalized tasks.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textDark.opacity(0.6))
            } else {
                ForEach(appState.dailyActivities) { task in
                    taskRow(task: task)
                }
            }
        }
    }

    private func taskRow(task: TaskItem) -> some View {
        let isDone = appState.completedTaskIDs.contains(task.id)

        return Button {
            appState.toggleComplete(task)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(task.category.tint.opacity(0.15))
                        .frame(width: 46, height: 46)

                    Image(systemName: task.category.symbol)
                        .font(.title3)
                        .foregroundStyle(task.category.tint)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(task.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(darkText)
                        .strikethrough(isDone)

                    Text(task.category.rawValue)
                        .font(.caption)
                        .foregroundStyle(Theme.textDark.opacity(0.6))
                }

                Spacer()

                Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isDone ? primaryTeal : primaryTeal.opacity(0.5))
            }
            .padding()
            .background(Color.white.opacity(0.9))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Plant Overview

struct PlantOverviewView: View {
    private let primaryTeal = Theme.teal
    private let darkText = Theme.textDark

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    MindMattersLogoView(size: 48)

                    Text("Your Plant Priorities")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(darkText)
                        .multilineTextAlignment(.center)

                    Text("Each plant represents a different area of your wellbeing.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textDark.opacity(0.6))
                        .multilineTextAlignment(.center)

                    ForEach(GardenCatalog.plants) { plant in
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

                VStack(alignment: .leading, spacing: 2) {
                    Text(profile.name)
                        .fontWeight(.semibold)
                        .foregroundStyle(darkText)

                    Text(profile.category)
                        .font(.caption)
                        .foregroundStyle(Theme.textDark.opacity(0.6))
                }

                Spacer()

                Text("\(profile.progress)%")
                    .fontWeight(.bold)
                    .foregroundStyle(primaryTeal)
            }

            ProgressView(value: Double(profile.progress), total: 100)
                .tint(primaryTeal)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        HomeView()
            .environmentObject(AppState())
    }
}
