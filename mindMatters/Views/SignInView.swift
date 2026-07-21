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

                VStack(spacing: 24) {
                    Spacer()

                    MindMattersLogoView(size: 120)
                        .padding(20)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))

                    Text("Small daily wins for your mind, body, and wallet.")
                        .font(.subheadline)
                        .foregroundColor(Theme.textDark.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

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
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 40)

                    VStack(spacing: 8) {
                        TextField("Your name (prototype only)", text: $fallbackName)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal, 40)
                        Button("Continue without Apple Sign-In") {
                            appState.signIn(name: fallbackName)
                        }
                        .font(.footnote)
                        .foregroundColor(Theme.teal)
                    }
                    .padding(.top, 8)

                    Button("Browse campus resources") {
                        showResources = true
                    }
                    .font(.footnote)
                    .foregroundColor(Theme.teal)
                    .padding(.top, 8)

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
