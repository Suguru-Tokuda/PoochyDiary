//
//  ChartView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 9/24/26.
//

import Charts
import SwiftUI

struct DailyCount: Identifiable, Equatable {
    let date: Date
    let count: Int

    var id: Date { date }
}

struct ChartGroup: Identifiable, Equatable {
    let legendTitle: String
    let data: [DailyCount]
    let color: Color

    var id: String { legendTitle }
}

struct ChartData: Equatable {
    enum DateLabelStyle {
        case weekday
        case monthDay
    }

    enum MarkerStyle {
        case regular
        case small
        case hidden
    }

    enum Granularity {
        case daily
        case weekly
    }

    struct DisplaySettings: Equatable {
        let xAxisDayStride: Int
        let dateLabelStyle: DateLabelStyle
        let markerStyle: MarkerStyle
        let granularity: Granularity

        static let sevenDays = DisplaySettings(
            xAxisDayStride: 1,
            dateLabelStyle: .weekday,
            markerStyle: .regular,
            granularity: .daily
        )

        static let thirtyDays = DisplaySettings(
            xAxisDayStride: 5,
            dateLabelStyle: .monthDay,
            markerStyle: .hidden,
            granularity: .daily
        )

        static let ninetyDays = DisplaySettings(
            xAxisDayStride: 14,
            dateLabelStyle: .monthDay,
            markerStyle: .small,
            granularity: .weekly
        )
    }

    let dataSet: [ChartGroup]
    let displaySettings: DisplaySettings

    init(dataSet: [ChartGroup], displaySettings: DisplaySettings = .sevenDays) {
        self.dataSet = dataSet
        self.displaySettings = displaySettings
    }
}

enum WeeklyChartStyle {
    case line
    case bar
}

struct ChartView: View {
    let data: ChartData
    var style: WeeklyChartStyle = .line

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasAppeared = false
    @State private var selectedDate: Date?
    @State private var selectionGesture = ChartSelectionGestureState()

    private var selection: ChartData.Selection? {
        selectedDate.flatMap { data.selection(nearestTo: $0) }
    }

    private var animation: Animation? {
        reduceMotion ? nil : .easeInOut(duration: 0.45)
    }

    private var maximumCount: Double {
        Double(max(1, data.dataSet.flatMap(\.data).map(\.count).max() ?? 0))
    }

    var body: some View {
        Chart {
            ForEach(data.dataSet) { group in
                series(group.data, name: group.legendTitle)
            }
            if let selection {
                selectionMarks(selection)
            }
        }
        .chartForegroundStyleScale(
            domain: data.dataSet.map(\.legendTitle),
            range: data.dataSet.map(\.color)
        )
        // Keep the scale based on the actual data while marks rise from zero.
        .chartYScale(domain: 0...maximumCount)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: max(1, data.displaySettings.xAxisDayStride))) { _ in
                switch data.displaySettings.dateLabelStyle {
                case .weekday:
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                case .monthDay:
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .stride(by: 1))
        }
        .chartLegend(position: .bottom)
        .chartXSelection(value: $selectedDate)
        .chartGesture { proxy in
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    selectionGesture.update(currentSelection: selection?.date, translation: value.translation)
                    proxy.selectXValue(at: value.location.x)
                }
                .onEnded { value in
                    selectionGesture.update(currentSelection: selection?.date, translation: value.translation)
                    proxy.selectXValue(at: value.location.x)
                    if selectionGesture.shouldDismiss(endingSelection: selection?.date) {
                        selectedDate = nil
                    }
                }
        }
        .padding(Spacing.space20)
        .animation(animation, value: hasAppeared)
        .animation(animation, value: data)
        .onAppear {
            hasAppeared = true
        }
        .onChange(of: data) {
            selectedDate = nil
            selectionGesture = ChartSelectionGestureState()
        }
        .onDisappear {
            selectionGesture = ChartSelectionGestureState()
        }
    }

    @ChartContentBuilder
    private func selectionMarks(_ selection: ChartData.Selection) -> some ChartContent {
        RuleMark(x: .value("Selected date", selection.date, unit: dateUnit))
            .foregroundStyle(.secondary)
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
            // The annotation shares this mark's layer, so keep it above the data series.
            .zIndex(1)
            .annotation(
                position: .overlay,
                alignment: .top,
                overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))
            ) {
                selectionDetails(selection)
            }

        ForEach(selection.values) { value in
            PointMark(
                x: .value("Selected date", selection.date, unit: dateUnit),
                y: .value("Count", value.count)
            )
            .foregroundStyle(value.color)
            .symbolSize(Spacing.space40 * 2)
        }
    }

    private func selectionDetails(_ selection: ChartData.Selection) -> some View {
        VStack(alignment: .leading, spacing: Spacing.space2 + Spacing.space4) {
            Text(selection.date, format: .dateTime.month(.abbreviated).day().year())
                .font(.caption.weight(.semibold))
            ForEach(selection.values) { value in
                HStack(spacing: Spacing.space2 + Spacing.space4) {
                    Circle()
                        .fill(value.color)
                        .frame(width: Spacing.space2 + Spacing.space4, height: Spacing.space2 + Spacing.space4)
                    Text(value.legendTitle)
                    Spacer(minLength: Spacing.space12)
                    Text(value.count, format: .number)
                        .monospacedDigit()
                }
                .font(.caption)
            }
        }
        .padding(Spacing.space2 + Spacing.space8)
        .frame(width: 160)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: Spacing.space2 + Spacing.space8))
        .accessibilityElement(children: .combine)
        .allowsHitTesting(false)
    }

    @ChartContentBuilder
    private func series(
        _ points: [DailyCount],
        name: String
    ) -> some ChartContent {
        ForEach(points.sorted { $0.date < $1.date }) { point in
            switch style {
            case .line:
                LineMark(
                    x: .value("Day", point.date, unit: dateUnit),
                    y: .value("Count", displayedCount(for: point))
                )
                .foregroundStyle(by: .value("Category", name))
                .symbol(.circle)
                .symbolSize(markerSize)
                .lineStyle(StrokeStyle(lineWidth: Spacing.space2))

            case .bar:
                BarMark(
                    x: .value("Day", point.date, unit: dateUnit),
                    y: .value("Count", displayedCount(for: point)),
                    width: .ratio(0.3)
                )
                .foregroundStyle(by: .value("Category", name))
            }
        }
    }

    private func displayedCount(for point: DailyCount) -> Double {
        hasAppeared || reduceMotion ? Double(point.count) : 0
    }

    private var markerSize: CGFloat {
        switch data.displaySettings.markerStyle {
        case .regular:
            Spacing.space40
        case .small:
            Spacing.space16
        case .hidden:
            0
        }
    }

    private var dateUnit: Calendar.Component {
        switch data.displaySettings.granularity {
        case .daily:
                .day
        case .weekly:
                .weekOfYear
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

    let data = ChartData(dataSet: [
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

    ChartView(data: data, style: .bar)
        .frame(height: 200)
        .background(
            Color(uiColor: .secondarySystemGroupedBackground),
            in: RoundedRectangle(cornerRadius: 20)
        )
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
}
