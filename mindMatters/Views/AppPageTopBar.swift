import SwiftUI

/// Shared top bar: menu (left), MindMatters logo home button (center), profile (right).
struct AppPageTopBar: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        HStack {
            Button {
                appState.navigateToMenu()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundStyle(Theme.teal)
                    .padding(8)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Open menu")

            Spacer()

            Button {
                appState.navigateToHome()
            } label: {
                MindMattersLogoView(size: 52)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Go to home")

            Spacer()

            Button {
                appState.navigateTo(.profile)
            } label: {
                profileButtonImage
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Open profile")
        }
        .padding(.horizontal, 4)
    }

    @ViewBuilder
    private var profileButtonImage: some View {
        if let data = appState.profileImageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .overlay(Circle().stroke(Theme.teal, lineWidth: 2))
        } else {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 34))
                .foregroundStyle(Theme.teal)
        }
    }
}

/// Standard full-page layout with the shared top bar and themed background.
struct AppPageShell<Content: View>: View {
    let title: String?
    @ViewBuilder let content: () -> Content

    init(title: String? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 0) {
                AppPageTopBar()
                    .padding(.horizontal)
                    .padding(.top, 8)

                if let title {
                    Text(title)
                        .font(Theme.pageTitle)
                        .foregroundStyle(Theme.textDark)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 12)
                        .padding(.bottom, 4)
                }

                content()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}
