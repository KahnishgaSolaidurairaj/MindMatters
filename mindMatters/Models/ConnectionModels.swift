import Foundation

// MARK: - Privacy

enum VisibilityLevel: String, CaseIterable, Identifiable {
    case nobody = "Nobody"
    case closeFriends = "Close Friends"
    case friendsOfFriends = "Friends of Friends"
    case publicProfile = "Public"

    var id: String { rawValue }
}

struct PrivacySettings: Hashable {
    var profileVisibility: VisibilityLevel = .friendsOfFriends
    var gardenVisibility: VisibilityLevel = .closeFriends
    var onlineStatusVisibility: VisibilityLevel = .closeFriends
    var groupsVisibility: VisibilityLevel = .friendsOfFriends
    var isSearchable: Bool = true
    var participateInCoOp: Bool = true
    var shareGreenhouseProgress: Bool = true
    var allowSharedActivities: Bool = true
}

// MARK: - Connections

struct DiscoverableUser: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let username: String
    let major: String
    let hobbies: [String]
    let focusedPriority: GardenPriority
    let bio: String
    let matchScore: Int
}

struct ConnectionProfile: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var username: String
    var streak: Int
    var growthDays: Int
    var plantKind: PlantKind
    var isOnline: Bool
    var focusedPriority: GardenPriority
}

// MARK: - Co-op Activities

enum CoOpMode: String, CaseIterable, Identifiable {
    case active = "Active Co-op"
    case group = "Group Co-op"

    var id: String { rawValue }

    var description: String {
        switch self {
        case .active: return "Two people, one activity."
        case .group: return "Three or more toward a shared goal."
        }
    }

    var icon: String {
        switch self {
        case .active: return "person.2.fill"
        case .group: return "person.3.fill"
        }
    }
}

struct CoOpActivity: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let detail: String
    let mode: CoOpMode
    let participantCount: Int
    let priority: GardenPriority
    var progress: Int
    var goal: Int
}

// MARK: - Streak & Activity History

struct ActivityDayRecord: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let completedAllTasks: Bool
    let streakDay: Int
    let energyEarned: Int
    var completedTasks: [CompletedTaskRecord] = []
}

struct StreakReward: Identifiable, Hashable {
    let id = UUID()
    let streakDay: Int
    let title: String
    let detail: String
    let energyBonus: Int
}

enum ConnectionCatalog {
    static let discoverableUsers: [DiscoverableUser] = [
        DiscoverableUser(
            name: "Guest user1",
            username: "guest1",
            major: "Computer Science",
            hobbies: ["Running", "Photography"],
            focusedPriority: .academicGrowth,
            bio: "Building habits one sprint at a time.",
            matchScore: 92
        ),
        DiscoverableUser(
            name: "Guest user2",
            username: "guest2",
            major: "Psychology",
            hobbies: ["Yoga", "Cooking"],
            focusedPriority: .physicalWellness,
            bio: "Prioritizing mental health and movement.",
            matchScore: 88
        ),
        DiscoverableUser(
            name: "Guest user3",
            username: "guest3",
            major: "Finance",
            hobbies: ["Hiking", "Budgeting"],
            focusedPriority: .financialGrowth,
            bio: "Saving smart, living well.",
            matchScore: 85
        ),
        DiscoverableUser(
            name: "guest user4",
            username: "guest4",
            major: "Biology",
            hobbies: ["Study groups", "Coffee"],
            focusedPriority: .socialGrowth,
            bio: "Love connecting with classmates.",
            matchScore: 79
        ),
        DiscoverableUser(
            name: "Guest user5",
            username: "guest5",
            major: "Computer Science",
            hobbies: ["Gaming", "Reading"],
            focusedPriority: .academicGrowth,
            bio: "CS major looking for accountability buddies.",
            matchScore: 95
        ),
    ]

    static let existingUsers: [ConnectionProfile] = [
        ConnectionProfile(
            name: "NPC1",
            username: "npc",
            streak: 4,
            growthDays: 3,
            plantKind: .sunflower,
            isOnline: true,
            focusedPriority: .socialGrowth
        ),
        ConnectionProfile(
            name: "NPC2",
            username: "npc2",
            streak: 7,
            growthDays: 5,
            plantKind: .rose,
            isOnline: false,
            focusedPriority: .academicGrowth
        ),
    ]

    static let coOpActivities: [CoOpActivity] = [
        CoOpActivity(
            title: "Go to a movie together",
            detail: "Pick a film and go with your co-op partner this week.",
            mode: .active,
            participantCount: 2,
            priority: .socialGrowth,
            progress: 0,
            goal: 1
        ),
        CoOpActivity(
            title: "Study session check-in",
            detail: "Complete a 30-minute focused study block together.",
            mode: .active,
            participantCount: 2,
            priority: .academicGrowth,
            progress: 1,
            goal: 1
        ),
        CoOpActivity(
            title: "Running group — 20 miles today",
            detail: "Collectively log 20 miles as a group today.",
            mode: .group,
            participantCount: 4,
            priority: .physicalWellness,
            progress: 12,
            goal: 20
        ),
        CoOpActivity(
            title: "Shared savings challenge",
            detail: "Each member saves $5 toward a group goal.",
            mode: .group,
            participantCount: 3,
            priority: .financialGrowth,
            progress: 2,
            goal: 3
        ),
    ]

    static let streakRewards: [StreakReward] = [
        StreakReward(streakDay: 1, title: "Day 1", detail: "Streak started.", energyBonus: 5),
        StreakReward(streakDay: 3, title: "3 Days", detail: "Consistency bonus.", energyBonus: 15),
        StreakReward(streakDay: 7, title: "7 Days", detail: "One week strong.", energyBonus: 30),
        StreakReward(streakDay: 14, title: "14 Days", detail: "Two weeks.", energyBonus: 50),
        StreakReward(streakDay: 30, title: "30 Days", detail: "One month.", energyBonus: 100),
    ]
}
