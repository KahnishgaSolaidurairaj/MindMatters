import SwiftUI

/// One slice of the priority pie chart.
struct PriorityPieSlice: Identifiable {
    let id: GardenPriority
    let label: String
    let value: Double
    let color: Color
}

/// Draws a single pie-slice wedge.
private struct PieSliceShape: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

/// Combined pie chart for garden priority progress.
struct PriorityPieChartView: View {
    let slices: [PriorityPieSlice]

    private var totalValue: Double {
        slices.map(\.value).reduce(0, +)
    }

    var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                if totalValue == 0 {
                    Circle()
                        .fill(Theme.sage.opacity(0.25))

                    ForEach(equalPlaceholderSlices) { slice in
                        PieSliceShape(
                            startAngle: slice.startAngle,
                            endAngle: slice.endAngle
                        )
                        .fill(slice.color.opacity(0.35))
                    }
                } else {
                    ForEach(Array(displaySlices.enumerated()), id: \.element.id) { _, slice in
                        PieSliceShape(
                            startAngle: slice.startAngle,
                            endAngle: slice.endAngle
                        )
                        .fill(slice.color)
                    }
                }
            }
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var displaySlices: [RenderedPieSlice] {
        var runningTotal = 0.0
        return slices.compactMap { slice in
            guard slice.value > 0 else { return nil }

            let start = Angle.degrees(runningTotal / totalValue * 360 - 90)
            runningTotal += slice.value
            let end = Angle.degrees(runningTotal / totalValue * 360 - 90)

            return RenderedPieSlice(id: slice.id, color: slice.color, startAngle: start, endAngle: end)
        }
    }

    private var equalPlaceholderSlices: [RenderedPieSlice] {
        let count = max(slices.count, 1)
        let segment = 360.0 / Double(count)

        return slices.enumerated().map { index, slice in
            RenderedPieSlice(
                id: slice.id,
                color: slice.color,
                startAngle: .degrees(Double(index) * segment - 90),
                endAngle: .degrees(Double(index + 1) * segment - 90)
            )
        }
    }

    /// Builds pie slices from garden profiles.
    static func slices(from profiles: [GardenPlantProfile]) -> [PriorityPieSlice] {
        profiles.map { profile in
            PriorityPieSlice(
                id: profile.id,
                label: profile.category,
                value: Double(profile.progress),
                color: chartTint(for: profile.id)
            )
        }
    }

    /// Builds pie slices from weekly priority percentages.
    static func slices(from breakdown: WeeklyPriorityBreakdown) -> [PriorityPieSlice] {
        GardenPriority.allCases.map { priority in
            PriorityPieSlice(
                id: priority,
                label: priority.rawValue,
                value: Double(breakdown.percentages[priority, default: 0]),
                color: chartTint(for: priority)
            )
        }
    }

    static func chartTint(for priority: GardenPriority) -> Color {
        switch priority {
        case .academicGrowth: return TaskCategory.academic.tint
        case .financialGrowth: return TaskCategory.financial.tint
        case .socialGrowth: return TaskCategory.social.tint
        case .physicalWellness: return TaskCategory.physical.tint
        }
    }

    private static func tint(for priority: GardenPriority) -> Color {
        chartTint(for: priority)
    }
}

private struct RenderedPieSlice: Identifiable {
    let id: GardenPriority
    let color: Color
    let startAngle: Angle
    let endAngle: Angle
}

#Preview {
    PriorityPieChartView(
        slices: [
            PriorityPieSlice(id: .academicGrowth, label: "Academic Growth", value: 33, color: .blue),
            PriorityPieSlice(id: .financialGrowth, label: "Financial Growth", value: 33, color: .green),
            PriorityPieSlice(id: .socialGrowth, label: "Social Growth", value: 33, color: .orange),
            PriorityPieSlice(id: .physicalWellness, label: "Physical Wellness", value: 0, color: .red),
        ]
    )
    .frame(width: 180, height: 180)
    .padding()
    .background(Theme.background)
}
