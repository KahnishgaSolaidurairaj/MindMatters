import Foundation

enum TaskDatabase {
    static let dailyTaskCount = 5
    static let requiredCategoriesForStreak = TaskCategory.allCases.count

    /// Specific tasks shown one-by-one during intake.
    static let intakeQuestions: [TaskItem] = [
        task("Join a study group session", "Even 15 minutes with others helps retention.", .academic, .extroverted, 10,
             learnMore: "Study groups improve retention through active recall and explaining concepts to peers. UIC Academic Support offers tutoring and study spaces.",
             weights: [.academic: 50, .social: 25]),
        task("Review your notes from today's class", "Just a quick skim to reinforce it.", .academic, .introverted, 10,
             learnMore: "Spaced review strengthens memory before you forget new material. The UIC Library and Academic Support Center can help you build stronger study routines."),
        task("Strike up a conversation with a classmate", "Doesn't have to be deep — even small talk works.", .social, .extroverted, 10,
             learnMore: "Brief social contact reduces isolation and builds campus belonging. UIC has 200+ student organizations through Student Involvement."),
        task("Text a friend you haven't talked to in a while", "Just say hi — no big catch-up required.", .social, .introverted, 5,
             learnMore: "Maintaining weak ties supports emotional resilience during stressful semesters. Small check-ins count."),
        task("Track today's spending", "Jot down what you spent, no judgment.", .financial, .introverted, 5,
             learnMore: "Tracking spending builds awareness—the first step toward financial stability. UIC Financial Aid offers budgeting workshops."),
        task("Save $10 today", "Move it to savings, or just set it aside.", .financial, .introverted, 5,
             learnMore: "Small, consistent savings build an emergency buffer. UIC Financial Wellness resources can help you plan ahead."),
        task("Take a 5-minute walk outside", "Leave your phone behind if you can.", .physical, .introverted, 5,
             learnMore: "Short walks reduce stress and improve focus. UIC Campus Recreation offers free fitness classes and open gym access."),
        task("Do 10 sit-ups", "Small movement adds up.", .physical, .introverted, 5,
             learnMore: "Brief movement breaks counter the effects of sitting and studying. Campus Recreation has guided workout options."),
    ]

    static let all: [TaskItem] = [
        task("Text a friend you haven't talked to in a while", "Just say hi — no big catch-up required.", .social, .introverted, 5,
             learnMore: "Maintaining weak ties supports emotional resilience during stressful semesters. Explore UIC clubs and events to meet peers."),
        task("Compliment someone today", "Genuine and specific lands best.", .social, .extroverted, 5,
             learnMore: "Positive social interactions boost mood for both people. Student Involvement at UIC makes it easy to find community."),
        task("Thank someone who's helped you", "A quick message counts.", .social, .introverted, 5,
             learnMore: "Expressing gratitude strengthens relationships and your own sense of connection."),
        task("Strike up a conversation with a classmate", "Doesn't have to be deep — even small talk works.", .social, .extroverted, 10,
             learnMore: "Campus connections reduce isolation and make academic life feel more manageable. UIC Involvement hosts events to meet people."),
        task("Go to the gym with a friend", "Move your body and connect at the same time.", .physical, .extroverted, 30,
             learnMore: "Combining movement and social time supports both physical health and belonging. UIC Campus Recreation offers group fitness.",
             weights: [.physical: 50, .social: 25]),
        task("Read an excerpt of a book you've been meaning to start", "One chapter, or even a few pages.", .academic, .introverted, 10,
             learnMore: "Reading outside class expands knowledge and gives your brain a focused break from screens. The UIC Library has study spaces and collections."),
        task("Review your notes from today's class", "Just a quick skim to reinforce it.", .academic, .introverted, 10,
             learnMore: "Reviewing within 24 hours helps move information into long-term memory. UIC Academic Support offers tutoring and study strategies."),
        task("Plan tomorrow's top 3 priorities", "Write them down somewhere you'll see them.", .academic, .neutral, 5,
             learnMore: "Planning reduces overwhelm and helps you start the next day with clarity. Academic coaches at UIC can help with time management."),
        task("Join a study group session", "Even 15 minutes with others helps retention.", .academic, .extroverted, 10,
             learnMore: "Study groups improve retention through active recall and peer accountability. UIC Academic Support offers group study resources.",
             weights: [.academic: 50, .social: 25]),
        task("Save $10 today", "Move it to savings, or just set it aside.", .financial, .introverted, 5,
             learnMore: "Small, consistent savings build an emergency buffer. UIC Financial Aid and wellness workshops cover budgeting basics."),
        task("Track today's spending", "Jot down what you spent, no judgment.", .financial, .introverted, 5,
             learnMore: "Awareness is the foundation of financial wellness. UIC Financial Aid offers tools and workshops for student money management."),
        task("Skip one non-essential purchase", "Notice the urge, then let it pass.", .financial, .neutral, 5,
             learnMore: "Pausing before spending builds mindful financial habits that add up over a semester."),
        task("Do 10 sit-ups", "Small movement adds up.", .physical, .introverted, 5,
             learnMore: "Brief strength work energizes your body between study sessions. Campus Recreation offers free workout orientations."),
        task("Take a 5-minute walk outside", "Leave your phone behind if you can.", .physical, .introverted, 5,
             learnMore: "Walking lowers stress hormones and clears mental fog. UIC Campus Recreation also offers Mind Body workshops."),
        task("Stretch for 5 minutes", "Loosen up your neck, shoulders, and back.", .physical, .introverted, 5,
             learnMore: "Stretching counteracts desk strain from long study sessions. Campus Recreation offers yoga and mobility classes."),
        task("Hold a 30-second plank", "Build core strength in under a minute.", .physical, .introverted, 5,
             learnMore: "Core strength supports posture and energy throughout the day. F45 and group workouts are available through UIC."),
        task("Cook a healthy meal at home", "Save money and nourish your body.", .physical, .neutral, 20,
             learnMore: "Home cooking supports both physical health and financial goals. Wellness workshops at UIC cover nutrition basics.",
             weights: [.physical: 50, .financial: 25]),
    ]

    static func items(in category: TaskCategory) -> [TaskItem] {
        all.filter { $0.category == category || $0.categoryWeights.keys.contains(category) }
    }

    /// Tasks whose primary category matches — used to guarantee streak coverage.
    static func primaryItems(in category: TaskCategory) -> [TaskItem] {
        all.filter { $0.category == category }
    }

    /// Recommends daily tasks with at least one primary-category task per priority, then fills by preference.
    static func recommend(
        basedOn preferences: [CategoryPreference],
        excluding used: Set<UUID>,
        count: Int = dailyTaskCount
    ) -> [TaskItem] {
        var picks: [TaskItem] = []
        var usedIDs = used

        for category in TaskCategory.allCases {
            let candidates = primaryItems(in: category)
                .filter { !usedIDs.contains($0.id) && !picks.contains($0) }
                .shuffled()
            if let task = candidates.first {
                picks.append(task)
                usedIDs.insert(task.id)
            }
        }

        let rankedCategories = (preferences.isEmpty ? TaskCategory.allCases.map { CategoryPreference(category: $0) } : preferences)
            .sorted { $0.combinedScore > $1.combinedScore }
            .map(\.category)

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

        return ensurePrimaryCategoryCoverage(
            in: picks,
            count: max(count, requiredCategoriesForStreak),
            excluding: used
        )
    }

    /// Ensures each priority category has at least one daily task users can complete for their streak.
    static func ensurePrimaryCategoryCoverage(
        in tasks: [TaskItem],
        count: Int,
        excluding used: Set<UUID> = []
    ) -> [TaskItem] {
        var result = tasks
        var usedIDs = Set(result.map(\.id)).union(used)

        for category in TaskCategory.allCases {
            guard !result.contains(where: { $0.category == category }) else { continue }

            guard let replacement = primaryItems(in: category)
                .filter({ !usedIDs.contains($0.id) })
                .shuffled()
                .first else { continue }

            if result.count < count {
                result.append(replacement)
            } else if let duplicateIndex = result.indices.reversed().first(where: { index in
                let existingCategory = result[index].category
                return result.filter { $0.category == existingCategory }.count > 1
            }) {
                usedIDs.remove(result[duplicateIndex].id)
                result[duplicateIndex] = replacement
            } else {
                result[result.count - 1] = replacement
            }

            usedIDs.insert(replacement.id)
        }

        return Array(result.prefix(max(count, requiredCategoriesForStreak)))
    }

    /// Builds a readable intake summary from task responses.
    static func intakeSummary(from responses: [IntakeTaskResponse]) -> IntakeSummary {
        let preferences = CategoryPreference.from(responses: responses)
        let answered = responses.filter { !$0.skipped && $0.rank != nil }

        guard !answered.isEmpty else {
            return IntakeSummary(
                headline: "You skipped all intake questions.",
                detailLines: ["We'll start with a balanced mix of social, academic, financial, and physical tasks."],
                categoryRankings: preferences.map { ($0.category, $0.rank) }
            )
        }

        let ranked = preferences.sorted { $0.rank > $1.rank }
        let strongest = ranked.first!
        let weakest = ranked.last!

        var detailLines: [String] = []

        if strongest.category != weakest.category {
            detailLines.append(
                "You are likely to do \(strongest.category.rawValue) tasks rather than \(weakest.category.rawValue) tasks."
            )
        }

        let highCategories = ranked.filter { $0.rank >= 4 }.map(\.category.rawValue)
        if highCategories.count > 1 {
            detailLines.append("You feel most confident with: \(highCategories.joined(separator: ", ")).")
        }

        let lowCategories = ranked.filter { $0.rank <= 2 }.map(\.category.rawValue)
        if !lowCategories.isEmpty {
            detailLines.append("These may need extra support: \(lowCategories.joined(separator: ", ")).")
        }

        let skippedCount = responses.filter(\.skipped).count
        if skippedCount > 0 {
            detailLines.append("You skipped \(skippedCount) question\(skippedCount == 1 ? "" : "s") — that's okay.")
        }

        let headline = strongest.category != weakest.category
            ? "\(strongest.category.rawValue) looks like your strongest fit right now."
            : "Your preferences look balanced across categories."

        return IntakeSummary(
            headline: headline,
            detailLines: detailLines,
            categoryRankings: ranked.map { ($0.category, $0.rank) }
        )
    }

    private static func task(
        _ title: String,
        _ detail: String,
        _ category: TaskCategory,
        _ style: SocialStyle,
        _ minutes: Int,
        learnMore: String,
        weights: [TaskCategory: Int] = [:]
    ) -> TaskItem {
        TaskItem(
            title: title,
            detail: detail,
            category: category,
            style: style,
            minutes: minutes,
            categoryWeights: weights,
            learnMore: learnMore
        )
    }
}
