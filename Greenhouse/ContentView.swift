import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.89, green: 0.88, blue: 0.82)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(
                            Color(red: 0.58, green: 0.68, blue: 0.61)
                        )

                    Text("Mind Matters")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            Color(red: 0.20, green: 0.26, blue: 0.24)
                        )

                    Text("Grow independently while staying connected.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(
                            Color(red: 0.35, green: 0.45, blue: 0.43)
                        )

                    NavigationLink {
                        RelationshipCheckInView()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "apple.logo")

                            Text("Sign in with Apple")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }

                    Spacer()
                }
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
struct RelationshipCheckInView: View {

    @State private var selectedChange = "Added a Romantic Partner"
    @State private var connectionName = ""
    @State private var inviteOtherRelationships = false

    private let relationshipChanges = [
        "No Recent Changes",
        "Added a Romantic Partner",
        "Added a Family Member",
        "Added a Friend",
        "Added Another Important Person"
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

                    // MARK: Header

                    VStack(spacing: 10) {
                        Image(systemName: "leaf.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(primaryTeal)

                        Text("Update Your Check-In")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(darkText)
                            .multilineTextAlignment(.center)

                        Text("Welcome back!")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(darkText)

                        Text(
                            "Update your relationship information so your greenhouse and activities stay personalized."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                    }
                    .padding(.top, 20)

                    // MARK: Relationship Update Card

                    VStack(alignment: .leading, spacing: 16) {
                        Label(
                            "Relationship Update",
                            systemImage: "person.2.fill"
                        )
                        .font(.headline)
                        .foregroundStyle(darkText)

                        Text(
                            "What has changed since your last check-in?"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

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
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(darkText)

                                TextField(
                                    "Enter any name",
                                    text: $connectionName
                                )
                                .textInputAutocapitalization(.words)
                                .autocorrectionDisabled()
                                .padding()
                                .background(
                                    Color.white.opacity(0.75)
                                )
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 14)
                                )

                                Text(
                                    "For this scenario, select “Added a Romantic Partner” and enter the boyfriend's name."
                                )
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    // MARK: Other Relationships Card

                    VStack(alignment: .leading, spacing: 14) {
                        Label(
                            "Other Important Relationships",
                            systemImage: "person.3.fill"
                        )
                        .font(.headline)
                        .foregroundStyle(darkText)

                        Toggle(
                            "Consider inviting other relationships",
                            isOn: $inviteOtherRelationships
                        )
                        .tint(primaryTeal)

                        if inviteOtherRelationships {
                            Text(
                                "You can also invite friends, family members, or another important person to join your greenhouse."
                            )
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    // continue button

                    NavigationLink {
                        InviteRelationshipView()
                    } label: {
                        Text("Save Check-In")
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

                    Text(
                        "Your relationship type will not affect how the connection is valued or scored."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                }
                .padding()
            }
        }
        .navigationTitle("Check-In")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    ContentView()
}
