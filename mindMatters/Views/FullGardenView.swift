import SwiftUI

/// Full-screen greenhouse scene reflecting priority balance and weekly streak progress.
struct FullGardenView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedWeekIndex = 0

    private var weeklyBreakdowns: [WeeklyPriorityBreakdown] {
        appState.weeklyPriorityBreakdowns()
    }

    private var selectedBreakdown: WeeklyPriorityBreakdown {
        let breakdowns = weeklyBreakdowns
        let index = min(selectedWeekIndex, max(breakdowns.count - 1, 0))
        return breakdowns.isEmpty
            ? WeeklyPriorityBreakdown(
                id: "current",
                title: "This Week",
                taskCounts: Dictionary(uniqueKeysWithValues: GardenPriority.allCases.map { ($0, 0) }),
                percentages: Dictionary(uniqueKeysWithValues: GardenPriority.allCases.map { ($0, 0) })
            )
            : breakdowns[index]
    }

    private var previousBreakdown: WeeklyPriorityBreakdown? {
        let nextIndex = selectedWeekIndex + 1
        guard nextIndex < weeklyBreakdowns.count else { return nil }
        return weeklyBreakdowns[nextIndex]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(appState.greenhouseSceneAsset)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
                    .padding(.horizontal)
                    .accessibilityLabel("Your greenhouse")

                gardenStatusCard
                prioritySummaryCard
            }
            .padding(.vertical)
        }
    }

    private var gardenStatusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Plant Health: \(appState.plantHealthScore)%", systemImage: "heart.fill")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.teal)

            if appState.growthDaysOnCurrentPlant > 0 {
                Text("Growth Day \(appState.growthDaysOnCurrentPlant)")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
            }

            Text(appState.greenhouseSceneDescription)
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.8))

            if appState.streakBroken {
                Label("Streak recently reset", systemImage: "exclamationmark.triangle.fill")
                    .font(Theme.bodyText)
                    .foregroundStyle(.orange)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private var prioritySummaryCard: some View {
        let slices = PriorityPieChartView.slices(from: selectedBreakdown)

        return VStack(alignment: .leading, spacing: 16) {
            Text("Priorities")
                .font(Theme.sectionTitle)
                .foregroundStyle(Theme.teal)

            if weeklyBreakdowns.count > 1 {
                Picker("Week", selection: $selectedWeekIndex) {
                    ForEach(Array(weeklyBreakdowns.enumerated()), id: \.offset) { index, breakdown in
                        Text(breakdown.title).tag(index)
                    }
                }
                .pickerStyle(.segmented)
            } else {
                Text(selectedBreakdown.title)
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(Theme.textDark)
            }

            Text("Avg. \(selectedBreakdown.averageProgress)% · \(selectedBreakdown.completedTaskCount) tasks")
                .font(Theme.bodyText)
                .foregroundStyle(Theme.textDark.opacity(0.75))

            HStack(alignment: .center, spacing: 20) {
                PriorityPieChartView(slices: slices)
                    .frame(width: 160, height: 160)

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(slices) { slice in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(slice.color)
                                .frame(width: 10, height: 10)

                            Text(slice.label)
                                .font(Theme.supportingText)
                                .foregroundStyle(Theme.textDark.opacity(0.8))
                                .wrapping()

                            Spacer(minLength: 4)

                            Text("\(Int(slice.value))%")
                                .font(Theme.supportingText.weight(.semibold))
                                .foregroundStyle(Theme.teal)
                        }
                    }
                }
            }

            if let previousBreakdown {
                comparisonSection(current: selectedBreakdown, previous: previousBreakdown)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }

    private func comparisonSection(
        current: WeeklyPriorityBreakdown,
        previous: WeeklyPriorityBreakdown
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Compared to \(previous.title)")
                .font(Theme.bodyText.weight(.semibold))
                .foregroundStyle(Theme.textDark)

            ForEach(GardenPriority.allCases) { priority in
                let delta = current.percentages[priority, default: 0] - previous.percentages[priority, default: 0]
                if delta != 0 || current.percentages[priority, default: 0] > 0 || previous.percentages[priority, default: 0] > 0 {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(PriorityPieChartView.chartTint(for: priority))
                            .frame(width: 8, height: 8)

                        Text(priority.rawValue)
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.textDark.opacity(0.75))

                        Spacer()

                        Text(formattedDelta(delta))
                            .font(Theme.supportingText.weight(.semibold))
                            .foregroundStyle(delta >= 0 ? Theme.teal : .orange)
                    }
                }
            }
        }
        .padding(.top, 4)
    }

    private func formattedDelta(_ delta: Int) -> String {
        if delta > 0 { return "+\(delta)%" }
        if delta < 0 { return "\(delta)%" }
        return "No change"
    }
}

#Preview {
    NavigationStack {
        FullGardenView()
            .environmentObject(AppState())
    }
}
