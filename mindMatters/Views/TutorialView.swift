import SwiftUI

struct TutorialView: View {
    @EnvironmentObject var appState: AppState
    @State private var pageIndex = 0

    private let pages: [(icon: String, title: String, body: String)] = [
        ("checklist", "Daily Activities", "Every day you'll get 3 small tasks across social, academic, financial, and mental health categories."),
        ("leaf.fill", "Your Plant", "Complete tasks to water, give sunlight, and fertilize your plant. Skip too many days and it'll wilt."),
        ("slider.horizontal.3", "Made For You", "Your intake form tells us what feels comfortable, so suggestions match your style — introverted or extroverted."),
        ("checkmark.circle.fill", "Check Things Off", "Mark tasks complete as you go. Small, 5-10 minute wins add up."),
    ]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack {
                Text("Welcome, \(appState.userName)!")
                    .font(.title2.bold())
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
                                .font(.title3.bold())
                                .foregroundColor(Theme.textDark)
                            Text(pages[index].body)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Theme.textDark.opacity(0.7))
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
                .font(.headline)
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
