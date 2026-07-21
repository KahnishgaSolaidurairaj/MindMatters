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
    @Published var weeklyPlantStartDate: Date = Date()
    /// Overall streak count when the current weekly plant was chosen.
    @Published var streakAtWeeklyPlantStart: Int = 0
    @Published var showWeeklyPlantPicker: Bool = false

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
    @Published var showPriorityBreakdown: Bool = false
    @Published var connectionName: String = ""
    @Published var hasConnection: Bool = false
    @Published private(set) var completedCountByPriority: [GardenPriority: Int] = {
        Dictionary(uniqueKeysWithValues: GardenPriority.allCases.map { ($0, 0) })
    }()

    var totalCompletedTasks: Int {
        completedCountByPriority.values.reduce(0, +)
    }

    var gardenProfiles: [GardenPlantProfile] {
        GardenPriority.allCases.map { priority in
            let progress = progressPercentage(for: priority)
            return GardenPlantProfile(
                priority: priority,
                stage: PlantStage.from(progressPercentage: progress),
                progress: progress
            )
        }
    }

    /// Picks a greenhouse illustration from priority balance and weekly streak progress.
    var greenhouseSceneAsset: String {
        let profiles = gardenProfiles
        let neglectedCount = profiles.filter { $0.progress == 0 }.count
        let progressValues = profiles.map(\.progress)
        let averageProgress = progressValues.isEmpty
            ? 0
            : progressValues.reduce(0, +) / progressValues.count
        let spread = (progressValues.max() ?? 0) - (progressValues.min() ?? 0)
        let streakDays = currentStreak

        if totalCompletedTasks == 0 && streakDays == 0 {
            return GardenCatalog.starterGreenhouse
        }

        if streakBroken || (neglectedCount >= 2 && streakDays < 3) {
            return GardenCatalog.strugglingGreenhouse
        }

        if spread >= 50 && averageProgress < 40 {
            return GardenCatalog.strugglingGreenhouse
        }

        let hasStrongStreak = streakDays >= 5
        let hasFullWeeklyStreak = streakDays >= 7
        let hasHealthyPriorities = averageProgress >= 30 && neglectedCount <= 1

        if (hasFullWeeklyStreak && hasHealthyPriorities)
            || (hasStrongStreak && averageProgress >= 45 && spread <= 35) {
            return GardenCatalog.flourishingGreenhouse
        }

        if streakDays <= 2 && averageProgress < 25 {
            return GardenCatalog.earlyStreakGreenhouse
        }

        if streakDays >= 3 || averageProgress >= 20 {
            return GardenCatalog.growingGreenhouse
        }

        return GardenCatalog.starterGreenhouse
    }

    /// Short explanation of why the current greenhouse scene was chosen.
    var greenhouseSceneDescription: String {
        let asset = greenhouseSceneAsset

        switch asset {
        case GardenCatalog.flourishingGreenhouse:
            return "Your \(currentStreak)-day streak and balanced priorities keep the greenhouse thriving."
        case GardenCatalog.strugglingGreenhouse:
            if streakBroken {
                return "A broken streak and uneven priorities need attention — your greenhouse looks quiet."
            }
            return "Some priorities need care. Focus on neglected areas to brighten your garden."
        case GardenCatalog.earlyStreakGreenhouse:
            return "Your streak is just starting. Keep completing daily tasks to grow your garden."
        case GardenCatalog.growingGreenhouse:
            return "Steady streak progress and task activity are helping your garden grow."
        default:
            return "Complete tasks and build your streak to bring your greenhouse to life."
        }
    }

    var averagePriorityProgress: Int {
        let values = gardenProfiles.map(\.progress)
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / values.count
    }

    func progressPercentage(for priority: GardenPriority) -> Int {
        let total = totalCompletedTasks
        guard total > 0 else { return 0 }
        let count = completedCountByPriority[priority, default: 0]
        return Int((Double(count) / Double(total) * 100).rounded())
    }

    /// Growth stage for the user's weekly streak plant — separate from category priorities.
    var streakPlantStage: PlantStage {
        plantOfTheWeekStage
    }

    var isStreakPlantWilted: Bool {
        streakBroken
    }

    /// Days completed on the current weekly plant since it was chosen.
    var currentWeeklyPlantDay: Int {
        max(0, currentStreak - streakAtWeeklyPlantStart)
    }

    /// Weekly plant growth reflects days on this plant — one stage per streak day on the plant.
    var plantOfTheWeekStage: PlantStage {
        PlantStage.fromWeeklyStreakDays(currentWeeklyPlantDay)
    }

    /// True when the user may choose a new weekly plant.
    var canPickNewWeeklyPlant: Bool {
        streakBroken || currentWeeklyPlantDay >= 7 || hasWeeklyPlantPeriodEnded
    }

    private var hasWeeklyPlantPeriodEnded: Bool {
        let calendar = Calendar.current
        let startWeek = calendar.component(.weekOfYear, from: weeklyPlantStartDate)
        let startYear = calendar.component(.yearForWeekOfYear, from: weeklyPlantStartDate)
        let currentWeek = calendar.component(.weekOfYear, from: Date())
        let currentYear = calendar.component(.yearForWeekOfYear, from: Date())
        return startYear != currentYear || startWeek != currentWeek
    }

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
                streakAtWeeklyPlantStart = 0
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
        if showWeeklyPlantPicker {
            replaceWeeklyPlant(with: kind)
            return
        }
        weeklyPlantStartDate = Date()
        streakAtWeeklyPlantStart = 0
        stage = .seedGiven
    }

    /// Presents plant selection when the current weekly plant cycle is complete.
    func beginWeeklyPlantReplacement() {
        showWeeklyPlantPicker = true
    }

    /// Starts a fresh weekly plant without replaying onboarding or resetting the overall streak.
    func replaceWeeklyPlant(with kind: PlantKind) {
        selectedPlantKind = kind
        weeklyPlantStartDate = Date()
        streakAtWeeklyPlantStart = currentStreak
        streakBroken = false
        showWeeklyPlantPicker = false
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
        let priority = GardenPriority.from(taskCategory: task.category)

        if completedTaskIDs.contains(task.id) {
            completedTaskIDs.remove(task.id)
            energyPoints = max(0, energyPoints - 10)
            completedCountByPriority[priority] = max(0, completedCountByPriority[priority, default: 0] - 1)
        } else {
            completedTaskIDs.insert(task.id)
            energyPoints += 10
            completedCountByPriority[priority, default: 0] += 1
        }
    }

    var allDoneToday: Bool {
        !dailyActivities.isEmpty && dailyActivities.allSatisfy { completedTaskIDs.contains($0.id) }
    }
}
