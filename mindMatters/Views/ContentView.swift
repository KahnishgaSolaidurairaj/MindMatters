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
                PriorityPlantMappingView(isOnboarding: true)
                    .environmentObject(appState)
//            case .seedGiven:  // removed — weekly plant intro skipped
            case .planting:
                PlantingView().environmentObject(appState)
            case .home:
                NavigationStack(path: $appState.navigationPath) {
                    HomeView()
                        .navigationDestination(for: AppDestination.self) { destination in
                            AppDestinationView(destination: destination)
                                .environmentObject(appState)
                        }
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
