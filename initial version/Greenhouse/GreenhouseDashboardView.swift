//
//  GreenhouseDashboardView.swift
//  Greenhouse
//
//  Created by Amaani Ziauddin on 7/18/26.
//

import SwiftUI

struct GreenhouseDashboardView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "house.lodge.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(.green)

                Text("Your Greenhouse")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("View your growth areas and complete activities.")
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                VStack(spacing: 16) {
                    PlantCardView(
                        title: "Academic Growth",
                        iconName: "book.fill",
                        progress: 0.75
                    )

                    PlantCardView(
                        title: "Financial Growth",
                        iconName: "dollarsign.circle.fill",
                        progress: 0.50
                    )

                    PlantCardView(
                        title: "Personal Wellness",
                        iconName: "heart.fill",
                        progress: 0.85
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Greenhouse")
    }
}

struct PlantCardView: View {
    let title: String
    let iconName: String
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: iconName)
                    .foregroundStyle(.green)

                Text(title)
                    .font(.headline)
            }

            ProgressView(value: progress)
                .tint(.green)

            Text("\(Int(progress * 100))% complete")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.green.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        GreenhouseDashboardView()
    }
}
