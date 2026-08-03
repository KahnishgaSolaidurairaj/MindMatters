import Foundation

enum TaskDatabase {
    static let dailyTaskCount = 5
    static let minimumTasksForStreak = 5

    static let all: [TaskItem] = [
        TaskItem(title: "Text a friend you haven't talked to in a while", detail: "Just say hi — no big catch-up required.", category: .social, style: .introverted, minutes: 5),
        TaskItem(title: "Compliment someone today", detail: "Genuine and specific lands best.", category: .social, style: .extroverted, minutes: 5),
        TaskItem(title: "Thank someone who's helped you", detail: "A quick message counts.", category: .social, style: .introverted, minutes: 5),
        TaskItem(title: "Strike up a conversation with a classmate", detail: "Doesn't have to be deep — even small talk works.", category: .social, style: .extroverted, minutes: 10),
        TaskItem(title: "Go to the gym with a friend", detail: "Move your body and connect at the same time.", category: .mentalHealth, style: .extroverted, minutes: 30, categoryWeights: [.mentalHealth: 50, .social: 25]),
        TaskItem(title: "Read an excerpt of a book you've been meaning to start", detail: "One chapter, or even a few pages.", category: .academic, style: .introverted, minutes: 10),
        TaskItem(title: "Review your notes from today's class", detail: "Just a quick skim to reinforce it.", category: .academic, style: .introverted, minutes: 10),
        TaskItem(title: "Plan tomorrow's top 3 priorities", detail: "Write them down somewhere you'll see them.", category: .academic, style: .neutral, minutes: 5),
        TaskItem(title: "Join a study group session", detail: "Even 15 minutes with others helps retention.", category: .academic, style: .extroverted, minutes: 10, categoryWeights: [.academic: 50, .social: 25]),
        TaskItem(title: "Save $10 today", detail: "Move it to savings, or just set it aside.", category: .finance, style: .introverted, minutes: 5),
        TaskItem(title: "Track today's spending", detail: "Jot down what you spent, no judgment.", category: .finance, style: .introverted, minutes: 5),
        TaskItem(title: "Skip one non-essential purchase", detail: "Notice the urge, then let it pass.", category: .finance, style: .neutral, minutes: 5),
        TaskItem(title: "Do 10 sit-ups", detail: "Small movement, real mood boost.", category: .mentalHealth, style: .introverted, minutes: 5),
        TaskItem(title: "Take a 5-minute walk outside", detail: "Leave your phone behind if you can.", category: .mentalHealth, style: .introverted, minutes: 5),
        TaskItem(title: "Write down one thing you're grateful for", detail: "One sentence is enough.", category: .mentalHealth, style: .introverted, minutes: 5),
        TaskItem(title: "Try a 5-minute breathing exercise", detail: "In for 4, hold for 4, out for 4.", category: .mentalHealth, style: .introverted, minutes: 5),
        TaskItem(title: "Cook a healthy meal at home", detail: "Save money and nourish your body.", category: .mentalHealth, style: .neutral, minutes: 20, categoryWeights: [.mentalHealth: 50, .finance: 25]),
    ]

    static func items(in category: TaskCategory) -> [TaskItem] {
        all.filter { $0.category == category || $0.categoryWeights.keys.contains(category) }
    }

    /// Recommends daily tasks weighted by intake category rankings.
    static func recommend(
        basedOn preferences: [CategoryPreference],
        excluding used: Set<UUID>,
        count: Int = dailyTaskCount
    ) -> [TaskItem] {
        guard !preferences.isEmpty else {
            return Array(all.shuffled().prefix(count))
        }

        let rankedCategories = preferences
            .sorted { $0.combinedScore > $1.combinedScore }
            .map(\.category)

        var picks: [TaskItem] = []
        var usedIDs = used

        for category in rankedCategories where picks.count < count {
            let candidates = items(in: category)
                .filter { !usedIDs.contains($0.id) && !picks.contains($0) }
                .shuffled()
            if let task = candidates.first {
                picks.append(task)
                usedIDs.insert(task.id)
            }
        }

        if picks.count < count {
            let remaining = all
                .filter { !usedIDs.contains($0.id) && !picks.contains($0) }
                .shuffled()
            picks.append(contentsOf: remaining.prefix(count - picks.count))
        }

        return picks
    }
}
