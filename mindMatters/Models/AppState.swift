import Combine
import Foundation
import SwiftUI

enum AppStage {
    case signIn
    case tutorial
    case intake
    case choosePlant
    case planting
    case home
}

final class AppState: ObservableObject {
    @Published var stage: AppStage = .signIn
    @Published var userName: String = ""
    @Published var username: String = ""
    @Published var phoneNumber: String = ""
    @Published var major: String = ""
    @Published var hobbies: String = ""
    @Published var bio: String = ""
    @Published var profileImageData: Data?
    @Published var focusedPriority: GardenPriority = .physicalWellness
    @Published var selectedPlantKind: PlantKind = .sunflower
    @Published var priorityPlantMapping: [GardenPriority: PlantKind] = Dictionary(
        uniqueKeysWithValues: GardenPriority.allCases.map { ($0, $0.plantKind) }
    )
    @Published var weeklyPlantStartDate: Date = Date()
    @Published var growthDaysAtPlantStart: Int = 0
    @Published var showWeeklyPlantPicker: Bool = false
    @Published var showPlantingAfterReplacement: Bool = false

    @Published var categoryPreferences: [CategoryPreference] = TaskCategory.allCases.map {
        CategoryPreference(category: $0)
    }
    @Published var intakeResponses: [IntakeTaskResponse] = []
    @Published var likedTasks: [TaskItem] = []
    @Published var dailyActivities: [TaskItem] = []
    @Published var completedTaskIDs: Set<UUID> = []

    @Published var plant = PlantState()

    @Published var dislikedTasks: [TaskItem] = []
    @Published var currentStreak: Int = 0
    @Published var growthDaysOnCurrentPlant: Int = 0
    @Published var consecutiveMissedDays: Int = 0
    @Published var showStreakPopup: Bool = false
    @Published var streakBroken: Bool = false
    @Published var redemptionTask: TaskItem?
    @Published var activityHistory: [ActivityDayRecord] = []
    @Published var earnedRewards: [StreakReward] = []

    @Published var energyPoints: Int = 0
    @Published var navigationPath = NavigationPath()

    @Published var ownedShopItemIDs: Set<String> = []
    @Published var unlockedGardenBeds: Int = 1
    @Published var potLevel: Int = 1
    @Published var plantLevel: Int = 1
    @Published var transplantedPlants: [TransplantedPlant] = []
    @Published var equippedProfileFrame: String?
    @Published var equippedPin: String?
    @Published var equippedPotStyle: String?

    @Published var privacySettings = PrivacySettings()
    @Published var connections: [ConnectionProfile] = []
    @Published var connectionName: String = ""
    @Published var hasConnection: Bool = false
    @Published var coOpActivities: [CoOpActivity] = ConnectionCatalog.coOpActivities

    @Published var journalEntries: [JournalEntry] = []
    @Published var showJournalReflection: Bool = false
    @Published var pendingJournalTask: TaskItem?
    @Published var showConfetti: Bool = false
    @Published var showWateringCelebration: Bool = false
    @Published var wateringCelebrationToken: Int = 0
    @Published var plantGrowthPulse: Bool = false
    @Published var highlightEndDay: Bool = false
    @Published var taskCompletionCount: Int = 0
    @Published var showMotivationPopup: Bool = false
    @Published var motivationMessage: String = ""

    @Published private(set) var completedCountByPriority: [GardenPriority: Int] = {
        Dictionary(uniqueKeysWithValues: GardenPriority.allCases.map { ($0, 0) })
    }()

    var totalCompletedTasks: Int {
        completedCountByPriority.values.reduce(0, +)
    }

    var todayTaskProgress: Double {
        guard !dailyActivities.isEmpty else { return 0 }
        return Double(completedTaskIDs.count) / Double(dailyActivities.count)
    }

    /// Streak-driven vitality (0–100). Keeps the plant healthy; separate from growth.
    var plantHealthScore: Int {
        if streakBroken { return 15 }
        if consecutiveMissedDays >= 3 { return max(20, 100 - consecutiveMissedDays * 15) }
        guard currentStreak > 0 else { return 60 }
        return min(100, 60 + currentStreak * 5)
    }

    var isPlantHealthy: Bool {
        plantHealthScore >= 40 && !streakBroken
    }

    var gardenProfiles: [GardenPlantProfile] {
        GardenPriority.allCases.map { priority in
            let progress = progressPercentage(for: priority)
            return GardenPlantProfile(
                priority: priority,
                kind: plantKind(for: priority),
                stage: PlantStage.from(progressPercentage: progress),
                progress: progress
            )
        }
    }

    /// Returns the plant the user assigned to a garden priority.
    func plantKind(for priority: GardenPriority) -> PlantKind {
        priorityPlantMapping[priority] ?? priority.plantKind
    }

    var greenhouseSceneAsset: String {
        if plantHealthScore <= 50 {
            return GardenCatalog.neglectedGreenhouse
        }

        if totalCompletedTasks == 0 && growthDaysOnCurrentPlant == 0 {
            return GardenCatalog.seedGreenhouse
        }

        let profiles = gardenProfiles
        let neglectedCount = profiles.filter { $0.progress == 0 }.count
        let progressValues = profiles.map(\.progress)
        let averageProgress = progressValues.isEmpty
            ? 0
            : progressValues.reduce(0, +) / progressValues.count
        let spread = (progressValues.max() ?? 0) - (progressValues.min() ?? 0)

        let hasStrongStreak = currentStreak >= 5
        let hasFullWeeklyGrowth = growthDaysOnCurrentPlant >= 7
        let hasHealthyPriorities = averageProgress >= 30 && neglectedCount <= 1

        if (hasFullWeeklyGrowth && hasHealthyPriorities)
            || (hasStrongStreak && averageProgress >= 45 && spread <= 35) {
            return GardenCatalog.flourishingGreenhouse
        }

        if growthDaysOnCurrentPlant >= 3 || averageProgress >= 20 {
            return GardenCatalog.secondGrowthGreenhouse
        }

        if growthDaysOnCurrentPlant >= 1 || totalCompletedTasks > 0 {
            return GardenCatalog.firstGrowthGreenhouse
        }

        return GardenCatalog.seedGreenhouse
    }

    var greenhouseSceneDescription: String {
        switch greenhouseSceneAsset {
        case GardenCatalog.flourishingGreenhouse:
            return "Your greenhouse is thriving."
        case GardenCatalog.neglectedGreenhouse:
            return "Your greenhouse needs care — plant health is low."
        case GardenCatalog.firstGrowthGreenhouse:
            return "Early sprouts are appearing."
        case GardenCatalog.secondGrowthGreenhouse:
            return "Steady progress — keep it up."
        case GardenCatalog.seedGreenhouse:
            return "Complete tasks to plant your first seed."
        default:
            return "Complete tasks to grow. Check in daily for health."
        }
    }

    var averagePriorityProgress: Int {
        let values = gardenProfiles.map(\.progress)
        guard !values.isEmpty else { return 0 }
        return values.reduce(0, +) / values.count
    }

    /// Weekly priority snapshots for comparing greenhouse balance over time.
    func weeklyPriorityBreakdowns(maxWeeks: Int = 4) -> [WeeklyPriorityBreakdown] {
        (0..<maxWeeks).compactMap { weeksBack in
            breakdown(forWeeksBack: weeksBack)
        }
    }

    /// Builds a priority pie breakdown for a calendar week relative to today.
    func breakdown(forWeeksBack weeksBack: Int) -> WeeklyPriorityBreakdown? {
        let calendar = Calendar.current
        guard let anchorDate = calendar.date(byAdding: .weekOfYear, value: -weeksBack, to: Date()),
              let weekInterval = calendar.dateInterval(of: .weekOfYear, for: anchorDate) else {
            return nil
        }

        var counts = Dictionary(uniqueKeysWithValues: GardenPriority.allCases.map { ($0, 0) })

        for record in activityHistory where weekInterval.contains(record.date) {
            for task in record.completedTasks {
                let priority = GardenPriority.from(taskCategory: task.category)
                counts[priority, default: 0] += 1
            }
        }

        if weeksBack == 0 {
            let todayAlreadySaved = activityHistory.contains {
                calendar.isDate($0.date, inSameDayAs: Date())
            }
            if !todayAlreadySaved {
                for task in dailyActivities where completedTaskIDs.contains(task.id) {
                    let priority = GardenPriority.from(taskCategory: task.category)
                    counts[priority, default: 0] += 1
                }
            }
        }

        let title: String
        switch weeksBack {
        case 0: title = "This Week"
        case 1: title = "Last Week"
        default: title = "\(weeksBack) Weeks Ago"
        }

        let weekID = calendar.component(.weekOfYear, from: anchorDate)
        let year = calendar.component(.yearForWeekOfYear, from: anchorDate)

        return WeeklyPriorityBreakdown(
            id: "\(year)-W\(weekID)",
            title: title,
            taskCounts: counts,
            percentages: priorityPercentages(from: counts)
        )
    }

    private func priorityPercentages(from counts: [GardenPriority: Int]) -> [GardenPriority: Int] {
        let total = counts.values.reduce(0, +)
        guard total > 0 else {
            return Dictionary(uniqueKeysWithValues: GardenPriority.allCases.map { ($0, 0) })
        }

        return Dictionary(uniqueKeysWithValues: counts.map { priority, count in
            (priority, Int((Double(count) / Double(total) * 100).rounded()))
        })
    }

    /// Task-driven growth stage with same-day micro progress.
    var displayPlantStage: PlantStage {
        let stages = PlantStage.allCases
        let baseIndex = stages.firstIndex(of: plantGrowthStage) ?? 0
        let dayBonus = min(taskCompletionCount, max(dailyActivities.count, 1)) / 2
        let index = min(baseIndex + dayBonus, stages.count - 1)
        return stages[index]
    }

    func progressPercentage(for priority: GardenPriority) -> Int {
        let total = totalCompletedTasks
        guard total > 0 else { return 0 }
        let count = completedCountByPriority[priority, default: 0]
        return Int((Double(count) / Double(total) * 100).rounded())
    }

    var streakPlantStage: PlantStage {
        plantGrowthStage
    }

    var isStreakPlantWilted: Bool {
        !isPlantHealthy
    }

    var currentWeeklyPlantDay: Int {
        growthDaysOnCurrentPlant
    }

    /// Growth comes from completing all daily tasks, not from streak count.
    var plantGrowthStage: PlantStage {
        PlantStage.fromWeeklyStreakDays(growthDaysOnCurrentPlant)
    }

    var plantOfTheWeekStage: PlantStage {
        plantGrowthStage
    }

    var isWeeklyPlantMature: Bool {
        plantGrowthStage == .blooming
    }

    var canPickNewWeeklyPlant: Bool {
        streakBroken || growthDaysOnCurrentPlant >= 7 || hasWeeklyPlantPeriodEnded || isWeeklyPlantMature
    }

    var nextStreakReward: StreakReward? {
        ConnectionCatalog.streakRewards.first { $0.streakDay > currentStreak }
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
        highlightEndDay = false
        taskCompletionCount = 0
        let metStreakGoal = metStreakGoalToday

        if metStreakGoal {
            currentStreak += 1
            consecutiveMissedDays = 0
            growthDaysOnCurrentPlant += 1
            streakBroken = false
            if redemptionTask != nil { redemptionTask = nil }
            applyStreakReward(for: currentStreak)
            showStreakPopup = true
        } else {
            consecutiveMissedDays += 1
            if consecutiveMissedDays >= 5 && currentStreak > 0 {
                currentStreak = 0
                growthDaysAtPlantStart = growthDaysOnCurrentPlant
                streakBroken = true
                redemptionTask = dislikedTasks.randomElement()
            }
        }

        let completedTasks = dailyActivities
            .filter { completedTaskIDs.contains($0.id) }
            .map { CompletedTaskRecord(from: $0) }

        activityHistory.append(
            ActivityDayRecord(
                date: Date(),
                completedAllTasks: metStreakGoal,
                streakDay: currentStreak,
                energyEarned: metStreakGoal ? 10 * completedTasks.count : 0,
                completedTasks: completedTasks
            )
        )

        completedTaskIDs.removeAll()
        refreshDailyActivities()
    }

    func acceptRedemption() {
        streakBroken = false
    }

    func signIn(name: String) {
        updateUserName(name)
        stage = .tutorial
    }

    /// Persists the display name and derived username slug.
    func updateUserName(_ name: String) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        userName = trimmed.isEmpty ? "Guest" : trimmed
        username = userName.lowercased().replacingOccurrences(of: " ", with: "")
    }

    func finishTutorial() {
        stage = .intake
    }

    func finishIntake(from responses: [IntakeTaskResponse]) {
        intakeResponses = responses
        categoryPreferences = CategoryPreference.from(responses: responses)
        likedTasks = responses.compactMap { response in
            guard !response.skipped, let rank = response.rank, rank >= 4 else { return nil }
            return response.task
        }
        dislikedTasks = responses.compactMap { response in
            guard !response.skipped, let rank = response.rank, rank <= 2 else { return nil }
            return response.task
        }
        dailyActivities = TaskDatabase.recommend(basedOn: categoryPreferences, excluding: [], count: TaskDatabase.dailyTaskCount)
        focusedPriority = topCategoryPreference
        stage = .choosePlant
    }

    func finishIntake() {
        finishIntake(from: intakeResponses)
    }

    func applyPriorityPlantMapping(_ mapping: [GardenPriority: PlantKind]) {
        priorityPlantMapping = mapping
        selectedPlantKind = plantKind(for: focusedPriority)
        weeklyPlantStartDate = Date()
        growthDaysAtPlantStart = 0
        growthDaysOnCurrentPlant = 0
        stage = .planting
    }

    func savePriorityPlantMapping(_ mapping: [GardenPriority: PlantKind]) {
        priorityPlantMapping = mapping
    }

    func selectPlant(_ kind: PlantKind) {
        selectedPlantKind = kind
        if showWeeklyPlantPicker {
            replaceWeeklyPlant(with: kind)
            return
        }
        weeklyPlantStartDate = Date()
        growthDaysAtPlantStart = 0
        growthDaysOnCurrentPlant = 0
        stage = .planting
    }

    func beginWeeklyPlantReplacement() {
        showWeeklyPlantPicker = true
    }

    func replaceWeeklyPlant(with kind: PlantKind) {
        selectedPlantKind = kind
        weeklyPlantStartDate = Date()
        growthDaysAtPlantStart = growthDaysOnCurrentPlant
        growthDaysOnCurrentPlant = 0
        streakBroken = false
        showWeeklyPlantPicker = false
        showPlantingAfterReplacement = true
    }

    func plantSeed() {
        stage = .planting
    }

    func confirmPlanting() {
        showPlantingAfterReplacement = false
        if stage == .planting {
            stage = .home
        }
    }

    /// Shows a motivational pop-up when the app opens or returns to the foreground.
    func presentMotivationPopup() {
        /*
        guard stage == .home else { return }
        guard !showStreakPopup, !streakBroken, !showJournalReflection, !showWeeklyPlantPicker else { return }

        motivationMessage = MotivationMessages.random()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
            showMotivationPopup = true
        }
        */
    }

    func dismissMotivationPopup() {
        withAnimation(.easeOut(duration: 0.25)) {
            showMotivationPopup = false
        }
    }

    func saveConnection(name: String) {
        connectionName = name
        hasConnection = !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    func addConnection(from user: DiscoverableUser) {
        let profile = ConnectionProfile(
            name: user.name,
            username: user.username,
            streak: 0,
            growthDays: 0,
            plantKind: user.focusedPriority.plantKind,
            isOnline: true,
            focusedPriority: user.focusedPriority
        )
        connections.append(profile)
        connectionName = user.name
        hasConnection = true
    }

    func findExistingConnection(query: String) -> ConnectionProfile? {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !trimmed.isEmpty else { return nil }
        return ConnectionCatalog.existingUsers.first {
            $0.name.lowercased().contains(trimmed)
                || $0.username.lowercased() == trimmed
        }
    }

    func connectExisting(_ profile: ConnectionProfile) {
        guard !connections.contains(where: { $0.username == profile.username }) else { return }
        connections.append(profile)
        connectionName = profile.name
        hasConnection = true
    }

    func discoverUsers(matching priority: GardenPriority?) -> [DiscoverableUser] {
        let users = ConnectionCatalog.discoverableUsers
        guard let priority else { return users.sorted { $0.matchScore > $1.matchScore } }
        return users
            .filter { $0.focusedPriority == priority }
            .sorted { $0.matchScore > $1.matchScore }
    }

    func toggleComplete(_ task: TaskItem) {
        if completedTaskIDs.contains(task.id) {
            completedTaskIDs.remove(task.id)
            energyPoints = max(0, energyPoints - 10)
            applyGardenCredit(for: task, adding: false)
            taskCompletionCount = max(0, taskCompletionCount - 1)
        } else {
            completedTaskIDs.insert(task.id)
            energyPoints += 10
            applyGardenCredit(for: task, adding: true)
            taskCompletionCount += 1
            pendingJournalTask = task
            showJournalReflection = true
            triggerWateringCelebration()
            triggerPlantGrowthFeedback()
        }
    }

    func addCustomTask(title: String, category: TaskCategory) {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let task = TaskItem(
            title: trimmed,
            detail: "Your custom task for today.",
            category: category,
            style: .neutral,
            minutes: 10,
            isCustom: true
        )
        dailyActivities.append(task)
    }

    func saveJournalEntry(text: String) {
        guard let task = pendingJournalTask else { return }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        journalEntries.append(
            JournalEntry(taskID: task.id, taskTitle: task.title, text: trimmed, date: Date())
        )
        dismissJournalReflection()
    }

    /// Returns completed tasks for a calendar day (saved history first, then live today).
    func completedTasks(on date: Date) -> [CompletedTaskRecord] {
        let calendar = Calendar.current
        if let record = activityHistory.last(where: { calendar.isDate($0.date, inSameDayAs: date) }) {
            return record.completedTasks
        }
        if calendar.isDateInToday(date) {
            return dailyActivities
                .filter { completedTaskIDs.contains($0.id) }
                .map { CompletedTaskRecord(from: $0) }
        }
        return []
    }

    /// Finds a journal entry linked to a completed task on the given day.
    func journalEntry(for task: CompletedTaskRecord, on date: Date) -> JournalEntry? {
        journalEntries.first { entry in
            Calendar.current.isDate(entry.date, inSameDayAs: date) && entry.taskID == task.id
        }
    }

    /// Activity summary for a calendar day, if one exists.
    func activityRecord(for date: Date) -> ActivityDayRecord? {
        activityHistory.last { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }

    func dismissJournalReflection() {
        showJournalReflection = false
        pendingJournalTask = nil
    }

    func updateCategoryPreference(_ preference: CategoryPreference) {
        guard let index = categoryPreferences.firstIndex(where: { $0.category == preference.category }) else { return }
        categoryPreferences[index] = preference
    }

    func refreshDailyActivities() {
        var picks = TaskDatabase.recommend(
            basedOn: categoryPreferences,
            excluding: [],
            count: TaskDatabase.dailyTaskCount
        )
        if let redemption = redemptionTask {
            picks.removeAll { $0.id == redemption.id }
            picks.append(redemption)
            if picks.count > TaskDatabase.dailyTaskCount {
                picks = Array(picks.prefix(TaskDatabase.dailyTaskCount))
            }
            picks = TaskDatabase.ensurePrimaryCategoryCoverage(
                in: picks,
                count: TaskDatabase.dailyTaskCount
            )
        }
        dailyActivities = picks
    }

    private var topCategoryPreference: GardenPriority {
        let top = categoryPreferences.max { $0.combinedScore < $1.combinedScore }
        return GardenPriority.from(taskCategory: top?.category ?? .physical)
    }

    private func applyStreakReward(for streakDay: Int) {
        guard let reward = ConnectionCatalog.streakRewards.first(where: { $0.streakDay == streakDay }) else { return }
        guard !earnedRewards.contains(where: { $0.streakDay == streakDay }) else { return }
        earnedRewards.append(reward)
        energyPoints += reward.energyBonus
    }

    /// Presents the watering-can celebration overlay after each completed task.
    func triggerWateringCelebration() {
        wateringCelebrationToken += 1
        showWateringCelebration = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.showWateringCelebration = false
        }
    }

    private func triggerPlantGrowthFeedback() {
        plantGrowthPulse = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            self?.plantGrowthPulse = false
        }

        if metStreakGoalToday {
            showConfetti = true
            highlightEndDay = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                self?.showConfetti = false
            }
        }
    }

    private func applyGardenCredit(for task: TaskItem, adding: Bool) {
        for (category, weight) in task.effectiveWeights where weight >= 25 {
            let priority = GardenPriority.from(taskCategory: category)
            if adding {
                completedCountByPriority[priority, default: 0] += 1
            } else {
                completedCountByPriority[priority] = max(0, completedCountByPriority[priority, default: 0] - 1)
            }
        }
    }

    var completedTasksTodayCount: Int {
        completedTaskIDs.count
    }

    /// Categories with at least one completed task today.
    var completedCategoriesToday: Set<TaskCategory> {
        Set(
            dailyActivities
                .filter { completedTaskIDs.contains($0.id) }
                .map(\.category)
        )
    }

    /// True when the user completed at least one task in each category today.
    var metStreakGoalToday: Bool {
        TaskCategory.allCases.allSatisfy { completedCategoriesToday.contains($0) }
    }

    func hasCompletedCategory(_ category: TaskCategory) -> Bool {
        completedCategoriesToday.contains(category)
    }

    var allDoneToday: Bool {
        !dailyActivities.isEmpty && dailyActivities.allSatisfy { completedTaskIDs.contains($0.id) }
    }

    func navigateToHome() {
        navigationPath = NavigationPath()
    }

    func navigateToMenu() {
        navigationPath.append(AppDestination.menu)
    }

    func navigateTo(_ destination: AppDestination) {
        navigationPath.append(destination)
    }

    var canTransplantCurrentPlant: Bool {
        isWeeklyPlantMature
            && transplantedPlants.count < unlockedGardenBeds
            && !transplantedPlants.contains(where: { $0.kind == selectedPlantKind })
    }

    func ownsShopItem(_ item: ShopItem) -> Bool {
        switch item.id {
        case "upgrade_pot":
            return potLevel >= RewardsCatalog.maxPotLevel
        case "upgrade_plant":
            return plantLevel >= RewardsCatalog.maxPlantLevel
        case "bed_second":
            return unlockedGardenBeds >= 2
        case "bed_third":
            return unlockedGardenBeds >= 3
        default:
            return ownedShopItemIDs.contains(item.id)
        }
    }

    @discardableResult
    func purchaseShopItem(_ item: ShopItem) -> String {
        guard !ownsShopItem(item) else { return "You already own this item." }
        guard energyPoints >= item.cost else { return "Not enough Bloom Points." }
        guard plantLevel >= item.requiredPlantLevel else { return "Requires Plant Level \(item.requiredPlantLevel)." }

        switch item.id {
        case "upgrade_pot":
            guard potLevel < RewardsCatalog.maxPotLevel else { return "Pot is already max level." }
            energyPoints -= item.cost
            potLevel += 1
            return "Pot leveled up to \(potLevel)!"

        case "upgrade_plant":
            guard plantLevel < RewardsCatalog.maxPlantLevel else { return "Plant is already max level." }
            energyPoints -= item.cost
            plantLevel += 1
            return "Plant leveled up to \(plantLevel)!"

        case "bed_second":
            guard unlockedGardenBeds < 2 else { return "Second bed already unlocked." }
            energyPoints -= item.cost
            unlockedGardenBeds = 2
            ownedShopItemIDs.insert(item.id)
            return "Second flower bed unlocked!"

        case "bed_third":
            guard unlockedGardenBeds < 3 else { return "Third bed already unlocked." }
            energyPoints -= item.cost
            unlockedGardenBeds = 3
            ownedShopItemIDs.insert(item.id)
            return "Third flower bed unlocked!"

        default:
            energyPoints -= item.cost
            ownedShopItemIDs.insert(item.id)
            applyCosmeticEquip(for: item)
            return "\(item.name) unlocked!"
        }
    }

    @discardableResult
    func transplantCurrentPlant() -> Bool {
        guard canTransplantCurrentPlant else { return false }
        let bedIndex = transplantedPlants.count
        transplantedPlants.append(
            TransplantedPlant(
                name: selectedPlantKind.displayName,
                kind: selectedPlantKind,
                bedIndex: bedIndex,
                transplantedAt: Date()
            )
        )
        growthDaysOnCurrentPlant = 0
        return true
    }

    private func applyCosmeticEquip(for item: ShopItem) {
        switch item.cosmeticKind {
        case .profileFrame: equippedProfileFrame = item.name
        case .pin: equippedPin = item.name
        case .pot: equippedPotStyle = item.name
        case .none: break
        }
    }
}
