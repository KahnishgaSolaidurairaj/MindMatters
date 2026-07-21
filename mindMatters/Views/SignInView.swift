import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var appState: AppState
    @State private var fallbackName: String = ""
    @State private var showResources = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    MindMattersLogoView(size: 360)

                    Text("Mind Matters")
                        .font(Theme.pageTitle)
                        .foregroundColor(Theme.textDark)

                    Text("Daily wins for your mind, body, and wallet.")
                        .font(Theme.bodyText)
                        .foregroundColor(Theme.textDark.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Spacer()

                    SignInWithAppleButton(.signIn, onRequest: { request in
                        request.requestedScopes = [.fullName]
                    }, onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            if let credential = authResults.credential as? ASAuthorizationAppleIDCredential {
                                let name = credential.fullName?.givenName ?? "there"
                                appState.signIn(name: name)
                            } else {
                                appState.signIn(name: "there")
                            }
                        case .failure:
                            appState.signIn(name: fallbackName)
                        }
                    })
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .frame(height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 32)

                    VStack(spacing: 12) {
                        TextField("Your name", text: $fallbackName)
                            .font(Theme.bodyText)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 32)

                        Button("Continue without Apple Sign-In") {
                            appState.signIn(name: fallbackName)
                        }
                        .font(Theme.linkText)
                        .foregroundColor(Theme.teal)
                    }

                    Button("Browse campus resources") {
                        showResources = true
                    }
                    .font(Theme.linkText)
                    .foregroundColor(Theme.teal)

                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $showResources) {
                ResourcesHubView()
            }
        }
    }
}
