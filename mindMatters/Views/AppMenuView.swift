import SwiftUI

/// Side menu exposing all app pathways from the main home screen.
struct AppMenuView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Your Garden") {
                    NavigationLink {
                        PlantOverviewView()
                    } label: {
                        Label("View Full Garden", systemImage: "leaf.circle.fill")
                    }
                }

                Section("Connections") {
                    NavigationLink {
                        RelationshipCheckInView()
                    } label: {
                        Label("Relationship Check-In", systemImage: "person.2.fill")
                    }

                    NavigationLink {
                        InviteRelationshipView()
                    } label: {
                        Label("Invite a Connection", systemImage: "person.badge.plus")
                    }

                    if appState.hasConnection {
                        NavigationLink {
                            ConnectionGreenhouseView(connectionName: appState.connectionName)
                        } label: {
                            Label("Visit Connection's Greenhouse", systemImage: "house.lodge.fill")
                        }
                    }
                }

                Section("Campus") {
                    Button {
                        dismiss()
                        appState.showResources = true
                    } label: {
                        Label("Browse Campus Resources", systemImage: "building.2.fill")
                    }
                }
            }
            .navigationTitle("Menu")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
