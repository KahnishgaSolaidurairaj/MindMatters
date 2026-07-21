import SwiftUI

struct AppMenuView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        HStack(spacing: 16) {
                            Text("Menu")
                                .font(Theme.pageTitle)
                                .foregroundStyle(Theme.textDark)

                            MindMattersLogoView(size: 108)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)

                        menuSection(title: "Your Garden") {
                            NavigationLink {
                                FullGardenView()
                                    .environmentObject(appState)
                            } label: {
                                menuRowLabel(title: "View Full Garden", icon: "leaf.circle.fill")
                            }

                            Button {
                                dismiss()
                                appState.showPriorityBreakdown = true
                            } label: {
                                menuRowLabel(title: "Priority Breakdown", icon: "chart.bar.fill")
                            }
                        }

                        menuSection(title: "Connections") {
                            NavigationLink {
                                RelationshipCheckInView()
                            } label: {
                                menuRowLabel(title: "Relationship Check-In", icon: "person.2.fill")
                            }

                            NavigationLink {
                                InviteRelationshipView()
                            } label: {
                                menuRowLabel(title: "Invite a Connection", icon: "person.badge.plus")
                            }

                            if appState.hasConnection {
                                NavigationLink {
                                    ConnectionGreenhouseView(connectionName: appState.connectionName)
                                } label: {
                                    menuRowLabel(
                                        title: "Visit Connection's Greenhouse",
                                        icon: "house.lodge.fill"
                                    )
                                }
                            }
                        }

                        menuSection(title: "Campus") {
                            Button {
                                dismiss()
                                appState.showResources = true
                            } label: {
                                menuRowLabel(title: "Browse Campus Resources", icon: "building.2.fill")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .toolbarBackground(Theme.background, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .font(Theme.buttonText)
                        .foregroundStyle(Theme.teal)
                }
            }
        }
    }

    private func menuSection<Content: View>(
        title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.teal)
                .padding(.leading, 4)

            VStack(spacing: 8) {
                content()
            }
        }
    }

    private func menuRowLabel(title: String, icon: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Theme.teal)
                .frame(width: 32)

            Text(title)
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.body.weight(.semibold))
                .foregroundStyle(Theme.textDark.opacity(0.35))
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
