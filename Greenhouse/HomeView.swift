//
//  HomeView.swift
//  Greenhouse
//
//  Created by Amaani Ziauddin on 7/17/26.
//

import SwiftUI

struct HomeView: View {

    @State private var showPlantDetails = false

    private let backgroundCream =
        Color(red: 0.89, green: 0.88, blue: 0.82)

    private let primaryTeal =
        Color(red: 0.35, green: 0.57, blue: 0.60)

    private let darkText =
        Color(red: 0.20, green: 0.26, blue: 0.24)

    var body: some View {
        ZStack {
            backgroundCream
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {

                    topBar

                    gardenSection

                    tasksSection

                    NavigationLink {
                        ConnectionGreenhouseView()
                    } label: {
                        Label(
                            "Visit Connection's Greenhouse",
                            systemImage: "person.2.fill"
                        )
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(primaryTeal)
                        .foregroundStyle(.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                    }

                    bottomStatusBar
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPlantDetails) {
            PlantOverviewView()
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Button {
                // Menu action can be added later.
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundStyle(primaryTeal)
                    .padding(8)
            }

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "leaf.fill")
                    .font(.title2)
                    .foregroundStyle(primaryTeal)

                Text("Mind Matters")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(darkText)
            }

            Spacer()

            Button {
                // Pressing profile button - add later
            } label: {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(primaryTeal)
            }
        }
    }

    // garden area
    private var gardenSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label(
                "Your Garden",
                systemImage: "leaf.circle.fill"
            )
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(primaryTeal)

            Button {
                showPlantDetails = true
            } label: {
                VStack(spacing: 14) {

                    ZStack(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.white.opacity(0.88))
                            .frame(height: 245)

                        VStack(spacing: 4) {

                            HStack(alignment: .bottom, spacing: 13) {

                        
                                gardenPlant(
                                    icon: "tree.fill",
                                    color: .blue,
                                    size: 52
                                )

                                gardenPlant(
                                    icon: "leaf.fill",
                                    color: .green,
                                    size: 58
                                )

                                gardenPlant(
                                    icon: "sun.max.fill",
                                    color: .yellow,
                                    size: 48
                                )

                                gardenPlant(
                                    icon: "figure.run",
                                    color: .red,
                                    size: 45
                                )

                                gardenPlant(
                                    icon: "sparkles",
                                    color: .purple,
                                    size: 44
                                )
                            }

                            RoundedRectangle(cornerRadius: 5)
                                .fill(
                                    Color(
                                        red: 0.42,
                                        green: 0.25,
                                        blue: 0.14
                                    )
                                )
                                .frame(height: 48)
                                .padding(.horizontal, 28)
                        }
                        .padding(.bottom, 24)
                    }

                    Text("Tap the garden to view plant progress")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
        }
    }

    private func gardenPlant(
        icon: String,
        color: Color,
        size: CGFloat
    ) -> some View {
        Image(systemName: icon)
            .font(.system(size: size))
            .foregroundStyle(color)
            .frame(maxHeight: 80, alignment: .bottom)
    }

    // MARK: - Tasks

    private var tasksSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label(
                "Today's Tasks",
                systemImage: "checkmark.circle.fill"
            )
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(primaryTeal)

            taskRow(
                icon: "book.fill",
                iconColor: .blue,
                title: "Study for 30 minutes",
                category: "Academic"
            )

            taskRow(
                icon: "dollarsign.circle.fill",
                iconColor: .green,
                title: "Review this week's budget",
                category: "Financial"
            )

            taskRow(
                icon: "person.2.fill",
                iconColor: .yellow,
                title: "Call or message a friend",
                category: "Social"
            )

            taskRow(
                icon: "figure.run",
                iconColor: .red,
                title: "Take a 20-minute walk",
                category: "Physical Wellness"
            )

            taskRow(
                icon: "brain.head.profile",
                iconColor: .purple,
                title: "Complete a 5-minute reflection",
                category: "Mental Wellness"
            )
        }
    }

    private func taskRow(
        icon: String,
        iconColor: Color,
        title: String,
        category: String
    ) -> some View {
        HStack(spacing: 12) {

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 46, height: 46)

                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(darkText)

                Text(category)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "circle")
                .font(.title3)
                .foregroundStyle(primaryTeal)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }

    // MARK: - Bottom Status Bar

    private var bottomStatusBar: some View {
        HStack(spacing: 20) {

            statusItem(
                icon: "leaf.fill",
                text: "Balanced"
            )

            statusItem(
                icon: "checkmark.circle.fill",
                text: "5"
            )

            statusItem(
                icon: "flame.fill",
                text: "12"
            )
        }
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundStyle(.white)
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(primaryTeal)
        .clipShape(Capsule())
    }

    private func statusItem(
        icon: String,
        text: String
    ) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
            Text(text)
        }
    }
}

// MARK: - Plant Overview

struct PlantOverviewView: View {

    private let backgroundCream =
        Color(red: 0.89, green: 0.88, blue: 0.82)

    private let primaryTeal =
        Color(red: 0.35, green: 0.57, blue: 0.60)

    private let darkText =
        Color(red: 0.20, green: 0.26, blue: 0.24)

    var body: some View {
        ZStack {
            backgroundCream
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {

                    Image(systemName: "leaf.circle.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(primaryTeal)

                    Text("Your Plant Priorities")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(darkText)
                        .multilineTextAlignment(.center)

                    Text(
                        "Each plant represents a different area of your wellbeing."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                    plantRow(
                        name: "Academic Cactus",
                        category: "Academic Growth",
                        icon: "tree.fill",
                        color: .blue,
                        progress: 82
                    )

                    plantRow(
                        name: "Financial Ficus",
                        category: "Financial Growth",
                        icon: "leaf.fill",
                        color: .green,
                        progress: 68
                    )

                    plantRow(
                        name: "Social Sunflower",
                        category: "Social Growth",
                        icon: "sun.max.fill",
                        color: .yellow,
                        progress: 74
                    )

                    plantRow(
                        name: "Fitness Aloe",
                        category: "Physical Wellness",
                        icon: "figure.run",
                        color: .red,
                        progress: 61
                    )

                    plantRow(
                        name: "Mindful Lotus",
                        category: "Mental Wellness",
                        icon: "sparkles",
                        color: .purple,
                        progress: 79
                    )
                }
                .padding()
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func plantRow(
        name: String,
        category: String,
        icon: String,
        color: Color,
        progress: Int
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 12) {

                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(color.opacity(0.15))
                        .frame(width: 46, height: 46)

                    Image(systemName: icon)
                        .foregroundStyle(color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .fontWeight(.semibold)
                        .foregroundStyle(darkText)

                    Text(category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(progress)%")
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            }

            ProgressView(
                value: Double(progress),
                total: 100
            )
            .tint(color)
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
