//
//  CoOpSetupView.swift
//  mindMatters
//

import SwiftUI

struct CoOpSetupView: View {
    @EnvironmentObject var appState: AppState
    @State private var workTogether = true
    @State private var shareGreenhouseProgress = true
    @State private var showOnlineStatus = true
    @State private var allowSharedActivities = true

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(Theme.teal)

                        Text("CO-OP Setup")
                            .font(Theme.pageTitle)
                            .foregroundStyle(Theme.textDark)

                        Text("Choose how you and your connection grow together.")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Label("Work Together", systemImage: "leaf.fill")
                            .font(Theme.rowTitle)
                            .foregroundStyle(Theme.textDark)

                        Toggle("Participate in CO-OP activities", isOn: $workTogether)
                            .font(Theme.bodyText)
                            .tint(Theme.teal)

                        Text("CO-OP activities support shared goals without changing your individual plants.")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    if workTogether {
                        VStack(alignment: .leading, spacing: 18) {
                            Label("Privacy and Sharing", systemImage: "lock.shield.fill")
                                .font(Theme.rowTitle)
                                .foregroundStyle(Theme.textDark)

                            Toggle("Share Greenhouse Progress", isOn: $shareGreenhouseProgress)
                                .font(Theme.bodyText)
                                .tint(Theme.teal)
                            Divider()
                            Toggle("Show Online Status", isOn: $showOnlineStatus)
                                .font(Theme.bodyText)
                                .tint(Theme.teal)
                            Divider()
                            Toggle("Allow Shared Activities", isOn: $allowSharedActivities)
                                .font(Theme.bodyText)
                                .tint(Theme.teal)
                        }
                        .padding()
                        .background(Color.white.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }

                    Button {
                        if appState.connectionName.isEmpty {
                            appState.saveConnection(name: "Connection")
                        }
                        appState.hasConnection = true
                        appState.stage = .home
                    } label: {
                        Text("Continue to Greenhouse")
                            .font(Theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.teal)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("CO-OP Setup")
    }
}

#Preview {
    NavigationStack {
        CoOpSetupView()
            .environmentObject(AppState())
    }
}
