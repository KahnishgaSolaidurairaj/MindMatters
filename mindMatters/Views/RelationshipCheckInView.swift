import SwiftUI

struct RelationshipCheckInView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedChange = "Added a Romantic Partner"
    @State private var connectionName = ""
    @State private var inviteOtherRelationships = false

    private let relationshipChanges = [
        "No Recent Changes",
        "Added a Romantic Partner",
        "Added a Family Member",
        "Added a Friend",
        "Added Another Important Person",
    ]

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
                        MindMattersLogoView(size: 48)

                        Text("Update Your Check-In")
                            .font(Theme.pageTitle)
                            .foregroundStyle(darkText)
                            .multilineTextAlignment(.center)

                        Text("Welcome back!")
                            .font(Theme.rowTitle)
                            .foregroundStyle(darkText)

                        Text("Update your relationships so your greenhouse stays personalized.")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Label(
                            "Relationship Update",
                            systemImage: "person.2.fill"
                        )
                        .font(Theme.rowTitle)
                        .foregroundStyle(darkText)

                        Text("What changed since your last check-in?")
                        .font(Theme.bodyText)
                        .foregroundStyle(Theme.textDark.opacity(0.75))

                        Picker(
                            "Recent Change",
                            selection: $selectedChange
                        ) {
                            ForEach(
                                relationshipChanges,
                                id: \.self
                            ) { change in
                                Text(change)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(primaryTeal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            Color.white.opacity(0.75)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )

                        if selectedChange != "No Recent Changes" {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Person's Name")
                                    .font(Theme.bodyText.weight(.semibold))
                                    .foregroundStyle(darkText)

                                TextField(
                                    "Enter any name",
                                    text: $connectionName
                                )
                                #if os(iOS)
                                .textInputAutocapitalization(.words)
                                #endif
                                .autocorrectionDisabled()
                                .padding()
                                .background(
                                    Color.white.opacity(0.75)
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 14)
                                )

                                Text("Enter the name of the person you'd like to grow with.")
                                .font(Theme.bodyText)
                                .foregroundStyle(Theme.textDark.opacity(0.75))
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    VStack(alignment: .leading, spacing: 14) {
                        Label(
                            "Other Important Relationships",
                            systemImage: "person.3.fill"
                        )
                        .font(Theme.rowTitle)
                        .foregroundStyle(darkText)

                        Toggle(
                            "Invite other relationships",
                            isOn: $inviteOtherRelationships
                        )
                        .font(Theme.bodyText)
                        .tint(primaryTeal)

                        if inviteOtherRelationships {
                            Text("You can invite friends, family, or others to join your greenhouse.")
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textDark.opacity(0.75))
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    NavigationLink {
                        InviteRelationshipView()
                            .environmentObject(appState)
                            .onAppear {
                                if selectedChange != "No Recent Changes" {
                                    appState.saveConnection(name: connectionName)
                                }
                            }
                    } label: {
                        Text("Save Check-In")
                            .font(Theme.buttonText)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(primaryTeal)
                            .foregroundStyle(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }
                    .disabled(
                        selectedChange != "No Recent Changes"
                        &&
                        connectionName
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                    )
                    .opacity(
                        selectedChange != "No Recent Changes"
                        &&
                        connectionName
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )
                            .isEmpty
                        ? 0.5
                        : 1
                    )

                    Text("Relationship type does not affect how connections are valued.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationTitle("Check-In")
    }
}

#Preview {
    NavigationStack {
        RelationshipCheckInView()
    }
}
