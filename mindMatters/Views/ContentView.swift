import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()

    var body: some View {
        Group {
            switch appState.stage {
            case .signIn:
                SignInView().environmentObject(appState)
            case .tutorial:
                TutorialView().environmentObject(appState)
            case .intake:
                IntakeFormView().environmentObject(appState)
            case .choosePlant:
                ChoosePlantView().environmentObject(appState)
            case .seedGiven:
                SeedGivenView().environmentObject(appState)
            case .planting:
                PlantingView().environmentObject(appState)
            case .home:
                NavigationStack {
                    HomeView()
                }
                .environmentObject(appState)
            }
        }
        .animation(.easeInOut, value: appState.stage)
    }
}

#Preview {
    ContentView()
}
