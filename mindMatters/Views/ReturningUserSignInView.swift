import SwiftUI

struct ReturningUserSignInView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    MindMattersLogoView(size: 240)

                    Text("Mind Matters")
                        .font(Theme.pageTitle)
                        .foregroundStyle(Theme.textDark)

                    Text("Grow independently while staying connected.")
                        .font(Theme.bodyText)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Theme.textDark.opacity(0.8))

                    NavigationLink {
                        RelationshipCheckInView()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "apple.logo")

                            Text("Sign in with Apple")
                                .font(Theme.buttonText)
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
        }
    }
}

#Preview {
    ReturningUserSignInView()
}
