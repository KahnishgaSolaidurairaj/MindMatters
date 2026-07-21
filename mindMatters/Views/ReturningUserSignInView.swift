import SwiftUI

struct ReturningUserSignInView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.89, green: 0.88, blue: 0.82)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    Image(MindMattersAssets.logo)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)

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
        }
    }
}

#Preview {
    ReturningUserSignInView()
}
