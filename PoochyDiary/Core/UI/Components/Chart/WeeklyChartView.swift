//
//  WeeklyChartView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 9/24/26.
//

import Charts
import SwiftUI

struct DailyCount: Identifiable {
    let date: Date
    let count: Int

    var id: Date { date }
}

struct ChartGroup: Identifiable {
    let legendTitle: String
    let data: [DailyCount]
    let color: Color

    let id = UUID()
}

struct WeeklyChartData {
    let dataSet: [ChartGroup]
}

struct WeeklyChartView: View {
    let data: WeeklyChartData

    var body: some View {
        Chart {
            ForEach(data.dataSet) { group in
                series(group.data, name: group.legendTitle)
            }
        }
        .chartForegroundStyleScale(
            domain: data.dataSet.map(\.legendTitle),
            range: data.dataSet.map(\.color)
        )
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisValueLabel(
                    format: .dateTime.weekday(.abbreviated)
                )
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 1))
        }
        .chartLegend(position: .bottom)
        .padding(Spacing.space20)
    }

    @ChartContentBuilder
    private func series(
        _ points: [DailyCount],
        name: String
    ) -> some ChartContent {
        ForEach(points.sorted { $0.date < $1.date }) { point in
            LineMark(
                x: .value("Day", point.date, unit: .day),
                y: .value("Count", point.count)
            )
            .foregroundStyle(by: .value("Category", name))
            .symbol(.circle)
            .symbolSize(Spacing.space40)
            .lineStyle(StrokeStyle(lineWidth: Spacing.space2))
        }
    }
}

#Preview {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())

    let dates = (-6...0).map { offset in
        calendar.date(byAdding: .day, value: offset, to: today)!
    }

    let poopCounts = [1, 2, 1, 2, 2, 3, 4]
    let bloodCounts = [0, 0, 1, 0, 0, 0, 1]
    let mucusCounts = [0, 1, 0, 1, 1, 0, 2]

    let data = WeeklyChartData(dataSet: [
        ChartGroup(
            legendTitle: "Poops",
            data: dates.indices.map {
                DailyCount(date: dates[$0], count: poopCounts[$0])
            },
            color: .green
        ),
        ChartGroup(
            legendTitle: "Blood",
            data: dates.indices.map {
                DailyCount(date: dates[$0], count: bloodCounts[$0])
            },
            color: .red
        ),
        ChartGroup(
            legendTitle: "Mucus",
            data: dates.indices.map {
                DailyCount(date: dates[$0], count: mucusCounts[$0])
            },
            color: .purple
        )
    ])

    WeeklyChartView(data: data)
        .frame(height: 200)
        .background(
            Color(uiColor: .secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 20)
        )
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
}
