//
//  CoOpSetupView.swift
//  mindMatters
//

import SwiftUI

struct CoOpSetupView: View {
    @EnvironmentObject var appState: AppState

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

                        Text("Grow together with a connection.")
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

                        Toggle("Join CO-OP activities", isOn: $appState.privacySettings.participateInCoOp)
                            .font(Theme.bodyText)
                            .tint(Theme.teal)
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    if appState.privacySettings.participateInCoOp {
                        VStack(alignment: .leading, spacing: 18) {
                            Label("Privacy and Sharing", systemImage: "lock.shield.fill")
                                .font(Theme.rowTitle)
                                .foregroundStyle(Theme.textDark)

                            Toggle("Share Greenhouse Progress", isOn: $appState.privacySettings.shareGreenhouseProgress)
                                .font(Theme.bodyText)
                                .tint(Theme.teal)
                            Divider()
                            Toggle("Show Online Status", isOn: onlineStatusBinding)
                                .font(Theme.bodyText)
                                .tint(Theme.teal)
                            Divider()
                            Toggle("Allow Shared Activities", isOn: $appState.privacySettings.allowSharedActivities)
                                .font(Theme.bodyText)
                                .tint(Theme.teal)

                            NavigationLink {
                                PrivacySettingsView()
                                    .environmentObject(appState)
                            } label: {
                                Label("Full Privacy Settings", systemImage: "gearshape.fill")
                                    .font(Theme.bodyText.weight(.semibold))
                                    .foregroundStyle(Theme.teal)
                            }
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

    private var onlineStatusBinding: Binding<Bool> {
        Binding(
            get: { appState.privacySettings.onlineStatusVisibility != .nobody },
            set: { appState.privacySettings.onlineStatusVisibility = $0 ? .closeFriends : .nobody }
        )
    }
}

#Preview {
    NavigationStack {
        CoOpSetupView()
            .environmentObject(AppState())
    }
}
