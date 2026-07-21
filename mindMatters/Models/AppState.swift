import Combine
import Foundation

enum AppStage {
    case signIn
    case tutorial
    case intake
    case choosePlant
    case seedGiven
    case planting
    case home
}

final class AppState: ObservableObject {
    @Published var stage: AppStage = .signIn
    @Published var userName: String = ""
    @Published var selectedPlantKind: PlantKind = .sunflower

    @Published var likedTasks: [TaskItem] = []
    @Published var dailyActivities: [TaskItem] = []
    @Published var completedTaskIDs: Set<UUID> = []

    @Published var plant = PlantState()

    @Published var dislikedTasks: [TaskItem] = []
    @Published var currentStreak: Int = 0
    @Published var consecutiveMissedDays: Int = 0
    @Published var showStreakPopup: Bool = false
    @Published var streakBroken: Bool = false
    @Published var redemptionTask: TaskItem?

    @Published var energyPoints: Int = 0
    @Published var showResources: Bool = false
    @Published var showAppMenu: Bool = false
    @Published var connectionName: String = ""
    @Published var hasConnection: Bool = false

    func endDay() {
        if allDoneToday {
            currentStreak += 1
            consecutiveMissedDays = 0
            if redemptionTask != nil {
                redemptionTask = nil
            }
            showStreakPopup = true
        } else {
            consecutiveMissedDays += 1
            if consecutiveMissedDays >= 5 && currentStreak > 0 {
                currentStreak = 0
                streakBroken = true
                redemptionTask = dislikedTasks.randomElement()
            }
        }

        completedTaskIDs.removeAll()
        var picks = TaskDatabase.recommend(basedOn: likedTasks, excluding: [], count: 3)
        if let redemption = redemptionTask {
            picks = Array(picks.prefix(2)) + [redemption]
        }
        dailyActivities = picks
    }

    func acceptRedemption() {
        streakBroken = false
    }

    func signIn(name: String) {
        userName = name.isEmpty ? "there" : name
        stage = .tutorial
    }

    func finishTutorial() {
        stage = .intake
    }

    func finishIntake() {
        var picks = TaskDatabase.recommend(basedOn: likedTasks, excluding: [], count: 3)
        if picks.count < 3 {
            picks = Array(Set(picks + likedTasks).prefix(3))
        }
        dailyActivities = picks
        stage = .choosePlant
    }

    func selectPlant(_ kind: PlantKind) {
        selectedPlantKind = kind
        stage = .seedGiven
    }

    func plantSeed() {
        stage = .planting
    }

    func confirmPlanting() {
        stage = .home
    }

    func saveConnection(name: String) {
        connectionName = name
        hasConnection = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func toggleComplete(_ task: TaskItem) {
        if completedTaskIDs.contains(task.id) {
            completedTaskIDs.remove(task.id)
            energyPoints = max(0, energyPoints - 10)
        } else {
            completedTaskIDs.insert(task.id)
            plant.reward(for: task.category)
            energyPoints += 10
        }
    }

    var allDoneToday: Bool {
        !dailyActivities.isEmpty && dailyActivities.allSatisfy { completedTaskIDs.contains($0.id) }
    }
}
