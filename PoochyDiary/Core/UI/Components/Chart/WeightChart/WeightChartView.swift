import Charts
import SwiftUI

struct WeightChartView: View {
    let data: WeightChartData

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var hasAppeared = false
    @State private var selectedDate: Date?
    @State private var selectionGesture = ChartSelectionGestureState()

    private var selection: WeightMeasurement? {
        selectedDate.flatMap { data.selection(nearestTo: $0) }
    }

    var body: some View {
        Group {
            if data.measurements.isEmpty {
                Text(Strings.Trends.noWeightsLogged)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                chart
            }
        }
        .padding(Spacing.space20)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.45), value: hasAppeared)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.45), value: data)
        .onAppear { hasAppeared = true }
        .onChange(of: data) {
            selectedDate = nil
            selectionGesture = ChartSelectionGestureState()
        }
        .onDisappear { selectionGesture = ChartSelectionGestureState() }
    }

    private var chart: some View {
        Chart {
            ForEach(data.measurements) { measurement in
                let value = hasAppeared || reduceMotion
                    ? data.value(for: measurement) : data.yDomain.lowerBound
                LineMark(
                    x: .value(Strings.Chart.day, measurement.date),
                    y: .value(Strings.Diary.weight, value)
                )
                .foregroundStyle(Color(uiColor: PoochyTheme.accent))
                PointMark(
                    x: .value(Strings.Chart.day, measurement.date),
                    y: .value(Strings.Diary.weight, value)
                )
                .foregroundStyle(Color(uiColor: PoochyTheme.accent))
                .symbolSize(Spacing.space24)
                .accessibilityLabel(Text(measurement.date, format: .dateTime.month().day().year()))
                .accessibilityValue(Text(
                    data.formattedWeight(data.unit.displayValue(fromPounds: measurement.weight))
                ))
            }
            if let selection {
                selectionMarks(selection)
            }
        }
        .chartXScale(domain: data.dateRange)
        .chartYScale(domain: data.yDomain)
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
            AxisMarks(position: .leading, values: .automatic(desiredCount: 4)) {
                AxisGridLine()
                AxisValueLabel(format: FloatingPointFormatStyle<Double>.number.precision(.fractionLength(1)))
            }
        }
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
    }

    @ChartContentBuilder
    private func selectionMarks(_ measurement: WeightMeasurement) -> some ChartContent {
        RuleMark(x: .value(Strings.Chart.selectedDate, measurement.date))
            .foregroundStyle(.secondary)
            .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))
            .zIndex(1)
            .annotation(
                position: .overlay,
                alignment: .top,
                overflowResolution: .init(x: .fit(to: .chart), y: .fit(to: .chart))
            ) {
                VStack(alignment: .leading, spacing: Spacing.space4) {
                    Text(measurement.date, format: .dateTime.month(.abbreviated).day().year())
                        .font(.caption.weight(.semibold))
                    Text(data.formattedWeight(data.unit.displayValue(fromPounds: measurement.weight)))
                        .font(.caption)
                        .monospacedDigit()
                }
                .padding(Spacing.space10)
                .frame(width: 100)
                .fixedSize(horizontal: true, vertical: true)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: Spacing.space10))
                .accessibilityElement(children: .combine)
                .allowsHitTesting(false)
            }
        PointMark(
            x: .value(Strings.Chart.selectedDate, measurement.date),
            y: .value(Strings.Diary.weight, data.value(for: measurement))
        )
        .foregroundStyle(Color(uiColor: PoochyTheme.accent))
        .symbolSize(Spacing.space40 * 2)
    }
}
