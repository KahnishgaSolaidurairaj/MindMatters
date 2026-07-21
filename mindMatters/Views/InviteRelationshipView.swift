//
//  InvitePartnerView.swift
//  Greenhouse
//
//  Created by Amaani Ziauddin on 7/16/26.
//

import SwiftUI

struct InviteRelationshipView: View {
    @EnvironmentObject var appState: AppState
    @State private var personEmail = ""
    @State private var invitationSent = false

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
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 48))
                            .foregroundStyle(primaryTeal)

                        Text("Invite a Connection")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundStyle(darkText)

                        Text(
                            "Invite your new partner, a friend, a family member, or another important person to grow alongside you."
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Label(
                            "Send an Invitation",
                            systemImage: "envelope.fill"
                        )
                        .font(.headline)
                        .foregroundStyle(darkText)

                        TextField(
                            "Email Address",
                            text: $personEmail
                        )
                        #if os(iOS)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        #endif
                        .autocorrectionDisabled()
                        .padding()
                        .background(Color.white.opacity(0.75))
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )

                        Button {
                            invitationSent = true
                            if appState.connectionName.isEmpty {
                                let derivedName = personEmail.components(separatedBy: "@").first ?? "Connection"
                                appState.saveConnection(name: derivedName.capitalized)
                            }
                        } label: {
                            Text("Send Invitation")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(primaryTeal)
                                .foregroundStyle(.white)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 16)
                                )
                        }
                        .disabled(personEmail.isEmpty)
                        .opacity(personEmail.isEmpty ? 0.5 : 1)

                        if invitationSent {
                            Label(
                                "Invitation Sent!",
                                systemImage: "checkmark.circle.fill"
                            )
                            .foregroundStyle(primaryTeal)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .clipShape(
                        RoundedRectangle(cornerRadius: 20)
                    )

                    NavigationLink {
                        CoOpSetupView()
                            .environmentObject(appState)
                    } label: {
                        Text("Continue")
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
        .navigationTitle("Invite Connection")
    }
}

#Preview {
    NavigationStack {
        InviteRelationshipView()
    }
}
    

