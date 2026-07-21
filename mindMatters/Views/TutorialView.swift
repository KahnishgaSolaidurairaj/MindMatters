import SwiftUI

struct TutorialView: View {
    @EnvironmentObject var appState: AppState
    @State private var pageIndex = 0

    private let pages: [(icon: String, title: String, body: String)] = [
        ("checklist", "Daily Tasks", "Get 3 short tasks each day across social, academic, financial, and wellness areas."),
        ("flame.fill", "Plant of the Week", "Your weekly plant grows one stage for each day you finish your streak."),
        ("leaf.circle.fill", "Your Garden", "Four priority plants show where your completed tasks are focused."),
        ("checkmark.circle.fill", "Check Them Off", "Mark tasks done as you go. Small wins add up."),
    ]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack {
                Text("Welcome, \(appState.userName)!")
                    .font(Theme.sectionTitle)
                    .foregroundColor(Theme.textDark)
                    .padding(.top)

                TabView(selection: $pageIndex) {
                    ForEach(pages.indices, id: \.self) { index in
                        VStack(spacing: 20) {
                            Image(systemName: pages[index].icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Theme.teal)
                                .padding(20)
                                .background(Color.white)
                                .clipShape(Circle())

                            Text(pages[index].title)
                                .font(Theme.rowTitle)
                                .foregroundColor(Theme.textDark)
                            Text(pages[index].body)
                                .font(Theme.bodyText)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Theme.textDark.opacity(0.8))
                                .padding(.horizontal, 30)
                        }
                        .tag(index)
                    }
                }
                #if os(iOS)
                .tabViewStyle(.page)
                #endif
                .frame(height: 380)

                Button(pageIndex == pages.count - 1 ? "Get Started" : "Next") {
                    if pageIndex == pages.count - 1 {
                        appState.finishTutorial()
                    } else {
                        pageIndex += 1
                    }
                }
                .font(Theme.buttonText)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Theme.teal)
                .clipShape(Capsule())
                .padding(.bottom, 30)
            }
        }
    }
}
