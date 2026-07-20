//
//  CoOpSetupView.swift
//  Greenhouse
//
//  Created by Amaani Ziauddin on 7/18/26.
//

import SwiftUI

struct CoOpSetupView: View {
    @State private var workTogether = true
    @State private var shareGreenhouseProgress = true
    @State private var showOnlineStatus = true
    @State private var allowSharedActivities = true

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

                    VStack(spacing: 10) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(primaryTeal)

                        Text("CO-OP Setup")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(darkText)

                        Text(
                            "Choose how you and your connection would like to grow together while continuing your individual activities."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Label(
                            "Work Together",
                            systemImage: "leaf.fill"
                        )
                        .font(.headline)
                        .foregroundStyle(darkText)

                        Toggle(
                            "Participate in CO-OP activities",
                            isOn: $workTogether
                        )
                        .tint(primaryTeal)

                        Text(
                            "CO-OP activities let you contribute toward shared goals without affecting your individual plant growth."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    if workTogether {
                        VStack(alignment: .leading, spacing: 18) {
                            Label(
                                "Privacy and Sharing",
                                systemImage: "lock.shield.fill"
                            )
                            .font(.headline)
                            .foregroundStyle(darkText)

                            Toggle(
                                "Share Greenhouse Progress",
                                isOn: $shareGreenhouseProgress
                            )
                            .tint(primaryTeal)

                            Divider()

                            Toggle(
                                "Show Online Status",
                                isOn: $showOnlineStatus
                            )
                            .tint(primaryTeal)

                            Divider()

                            Toggle(
                                "Allow Shared Activities",
                                isOn: $allowSharedActivities
                            )
                            .tint(primaryTeal)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 20)
                        )
                    }

                    NavigationLink {
                        HomeView()
                    } label: {
                        Text("Continue to Greenhouse")
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

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("CO-OP Setup")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CoOpSetupView()
    }
}
