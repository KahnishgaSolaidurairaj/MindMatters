import SwiftUI

/// Calendar view of activity history — tap a day to see completed tasks and journals.
struct StreakCalendarView: View {
    @EnvironmentObject var appState: AppState

    @State private var selectedDate = Calendar.current.startOfDay(for: Date())
    @State private var selectedJournalEntry: JournalEntry?

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = Calendar.current.shortWeekdaySymbols

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                streakSummary
                calendarGrid
                legendSection
                selectedDaySection
            }
            .padding()
        }
        .sheet(item: $selectedJournalEntry) { entry in
            JournalEntryDetailView(entry: entry)
                .presentationDetents([.medium])
        }
    }

    private var streakSummary: some View {
        VStack(spacing: 12) {
            HStack(spacing: 20) {
                summaryItem(
                    value: "\(appState.currentStreak)",
                    label: "Streak",
                    icon: "flame.fill"
                )
                summaryItem(
                    value: "\(appState.plantHealthScore)%",
                    label: "Health",
                    icon: "heart.fill"
                )
                summaryItem(
                    value: "\(appState.growthDaysOnCurrentPlant)",
                    label: "Growth",
                    icon: "leaf.fill"
                )
            }
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func summaryItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundStyle(Theme.teal)
            Text(value)
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)
            Text(label)
                .font(Theme.supportingText)
                .foregroundStyle(Theme.textDark.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }

    private var calendarGrid: some View {
        VStack(spacing: 8) {
            Text("Last 28 Days")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)
                .frame(maxWidth: .infinity, alignment: .leading)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Theme.textDark.opacity(0.5))
                }

                ForEach(calendarDays, id: \.self) { day in
                    if let day {
                        dayCell(for: day)
                    } else {
                        Color.clear.frame(height: 32)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var legendSection: some View {
        HStack(spacing: 16) {
            legendDot(color: Theme.teal, label: "Done")
            legendDot(color: Theme.teal.opacity(0.45), label: "Partial")
            legendDot(color: Theme.sage.opacity(0.4), label: "Missed")
        }
        .font(Theme.supportingText)
        .foregroundStyle(Theme.textDark.opacity(0.7))
    }

    private var selectedDaySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedDate, format: .dateTime.weekday(.wide).month().day())
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            let tasks = appState.completedTasks(on: selectedDate)

            if tasks.isEmpty {
                Text("No tasks completed this day.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.6))
            } else {
                ForEach(tasks) { task in
                    completedTaskRow(task)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func legendDot(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 10, height: 10)
            Text(label)
        }
    }

    private func dayCell(for date: Date) -> some View {
        let record = appState.activityRecord(for: date)
        let day = Calendar.current.component(.day, from: date)
        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
        let completedCount = appState.completedTasks(on: date).count

        return Button {
            selectedDate = Calendar.current.startOfDay(for: date)
        } label: {
            ZStack {
                Circle()
                    .fill(cellColor(for: date, record: record, completedCount: completedCount))
                    .frame(width: 32, height: 32)

                if isSelected {
                    Circle()
                        .stroke(Theme.textDark, lineWidth: 2)
                        .frame(width: 36, height: 36)
                }

                Text("\(day)")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(dayNumberColor(record: record, completedCount: completedCount))
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(dayAccessibilityLabel(for: date, completedCount: completedCount))
    }

    private func completedTaskRow(_ task: CompletedTaskRecord) -> some View {
        let journal = appState.journalEntry(for: task, on: selectedDate)

        return Group {
            if let journal {
                Button {
                    selectedJournalEntry = journal
                } label: {
                    taskRowContent(task, hasJournal: true)
                }
                .buttonStyle(.plain)
            } else {
                taskRowContent(task, hasJournal: false)
            }
        }
    }

    private func taskRowContent(_ task: CompletedTaskRecord, hasJournal: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(task.category.tint.opacity(0.15))
                    .frame(width: 44, height: 44)

                Image(systemName: task.category.symbol)
                    .foregroundStyle(task.category.tint)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(Theme.textDark)
                    .wrapping()

                Text(task.categoryLabels)
                    .font(Theme.supportingText)
                    .foregroundStyle(Theme.textDark.opacity(0.6))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            if hasJournal {
                Image(systemName: "book.closed.fill")
                    .foregroundStyle(Theme.teal)
                    .accessibilityLabel("View journal")
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(Theme.teal.opacity(0.6))
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(hasJournal ? Theme.teal.opacity(0.35) : Color.clear, lineWidth: 1)
        )
    }

    private func cellColor(for date: Date, record: ActivityDayRecord?, completedCount: Int) -> Color {
        if let record {
            if record.completedAllTasks { return Theme.teal }
            return record.completedTasks.isEmpty ? Theme.sage.opacity(0.4) : Theme.teal.opacity(0.45)
        }
        if completedCount == 0 { return Color.white }
        if completedCount >= TaskDatabase.requiredCategoriesForStreak { return Theme.teal }
        return Theme.teal.opacity(0.45)
    }

    private func dayNumberColor(record: ActivityDayRecord?, completedCount: Int) -> Color {
        if completedCount > 0 { return .white }
        if record != nil { return .white }
        return Theme.textDark.opacity(0.5)
    }

    private func dayAccessibilityLabel(for date: Date, completedCount: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateLabel = formatter.string(from: date)
        if completedCount == 0 { return "\(dateLabel), no tasks completed" }
        return "\(dateLabel), \(completedCount) tasks completed"
    }

    private var calendarDays: [Date?] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let start = calendar.date(byAdding: .day, value: -27, to: today) else { return [] }

        var days: [Date?] = []
        let startWeekday = calendar.component(.weekday, from: start)
        for _ in 1..<startWeekday { days.append(nil) }

        for offset in 0..<28 {
            if let date = calendar.date(byAdding: .day, value: offset, to: start) {
                days.append(date)
            }
        }
        return days
    }
}

/// Read-only sheet showing a saved journal reflection.
private struct JournalEntryDetailView: View {
    let entry: JournalEntry
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Reflection")
                    .font(Theme.sectionTitle)
                    .foregroundStyle(Theme.textDark)
                Spacer()
                Button("Done") { dismiss() }
                    .foregroundStyle(Theme.teal)
            }

            Text(entry.taskTitle)
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)
                .wrapping()

            Text(entry.date, format: .dateTime.month().day().year())
                .font(Theme.supportingText)
                .foregroundStyle(Theme.textDark.opacity(0.6))

            ScrollView {
                Text(entry.text)
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.85))
                    .wrapping()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}

#Preview {
    StreakCalendarView()
        .environmentObject(AppState())
}
