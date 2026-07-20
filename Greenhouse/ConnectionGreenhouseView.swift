//
//  ConnectionGreenhouseView.swift
//  Greenhouse
//
//  Created by Amaani Ziauddin on 7/16/26.
//

import SwiftUI

struct ConnectionGreenhouseView: View {
    @Environment(\.dismiss) private var dismiss
    private let connectionName = "Linus"
    private let currentStreak = 2
    private let requiredStreak = 5

    var body: some View {
        ZStack {
            Color(red: 0.89, green: 0.88, blue: 0.82)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 22) {
                    headerView
                    greenhouseCard
                    streakCard
                    encouragementButton
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }

    private var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundStyle(
                        Color(red: 0.20, green: 0.26, blue: 0.24)
                    )
                    .padding(8)
            }
                .font(.title2)

            Spacer()

            Text("\(connectionName)'s Greenhouse")
                .font(.title2)
                .fontWeight(.bold)

            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .fill(.green)
                    .frame(width: 10, height: 10)

                Text("Online")
                    .font(.subheadline)
            }
        }
    }

    private var greenhouseCard: some View {
        VStack(spacing: 16) {
            Text("New Growth")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(
                    Color(red: 0.42, green: 0.62, blue: 0.63)
                )

            Image(systemName: "sprout.fill")
                .font(.system(size: 110))
                .foregroundStyle(
                    Color(red: 0.58, green: 0.68, blue: 0.61)
                )

            Text("Sapling")
                .font(.headline)

            Text(
                "\(connectionName) is just beginning their growth journey."
            )
            .multilineTextAlignment(.center)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.88))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private var streakCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(
                    "Growth Streak",
                    systemImage: "flame.fill"
                )
                .font(.headline)

                Spacer()

                Text("\(currentStreak)/\(requiredStreak) days")
                    .fontWeight(.semibold)
            }

            ProgressView(
                value: Double(currentStreak),
                total: Double(requiredStreak)
            )
            .tint(
                Color(red: 0.42, green: 0.62, blue: 0.63)
            )

            Text(
                currentStreak >= requiredStreak
                ? "CO-OP mode is unlocked."
                : "CO-OP mode unlocks after a 5-day growth streak."
            )
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            Color(red: 0.57, green: 0.67, blue: 0.60)
                .opacity(0.28)
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }

    private var encouragementButton: some View {
        NavigationLink {
            EncouragementNoteView()
        } label: {
            Label(
                "Leave Encouragement",
                systemImage: "envelope.fill"
            )
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Color(red: 0.35, green: 0.57, blue: 0.60)
            )
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

#Preview {
    NavigationStack {
        ConnectionGreenhouseView()
    }
}
