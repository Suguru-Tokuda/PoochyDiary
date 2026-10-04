import Foundation
import Testing

@testable import PoochyDiary

@MainActor
struct WeightChartDataTests {
    @Test func averageUsesMeasurementsAndCurrentUsesLatestDate() {
        let first = Date(timeIntervalSince1970: 0)
        let last = first.addingTimeInterval(6 * 86_400)
        let data = WeightChartData(measurements: [
            WeightMeasurement(date: last, weight: 40),
            WeightMeasurement(date: first, weight: 44)
        ])
        #expect(data.currentWeight == 40)
        #expect(data.averageWeight == 42)
        #expect(data.measurements.map(\.date) == [first, last])
    }

    @Test func rangeExcludesOutsideAndInvalidMeasurements() {
        let start = Date(timeIntervalSince1970: 86_400)
        let end = start.addingTimeInterval(86_400)
        let data = WeightChartData(measurements: [
            WeightMeasurement(date: start.addingTimeInterval(-1), weight: 100),
            WeightMeasurement(date: start, weight: 40),
            WeightMeasurement(date: start.addingTimeInterval(100), weight: 0),
            WeightMeasurement(date: start.addingTimeInterval(200), weight: -1),
            WeightMeasurement(date: end, weight: 42),
            WeightMeasurement(date: end.addingTimeInterval(1), weight: 100)
        ], dateRange: start...end)
        #expect(data.measurements.count == 2)
        #expect(data.currentWeight == 42)
        #expect(data.averageWeight == 41)
    }

    @Test func emptyRangeShowsUnavailableInsteadOfZeroWeight() {
        let data = WeightChartData.empty
        #expect(data.currentWeight == nil)
        #expect(data.averageWeight == nil)
        #expect(data.formattedWeight(data.currentWeight) == Strings.Common.unavailableValue)
        #expect(data.selection(nearestTo: Date()) == nil)
        #expect(data.yDomain.lowerBound < data.yDomain.upperBound)
    }

    @Test func kilogramsConvertMetricsAndChartUsingSameMeasurements() throws {
        let date = Date(timeIntervalSince1970: 0)
        let data = WeightChartData(measurements: [
            WeightMeasurement(date: date, weight: 40),
            WeightMeasurement(date: date.addingTimeInterval(86_400), weight: 44)
        ], unit: .kilograms)
        #expect(data.currentWeight == WeightUnit.kilograms.displayValue(fromPounds: 44))
        #expect(data.averageWeight == WeightUnit.kilograms.displayValue(fromPounds: 42))
        let latest = try #require(data.measurements.last)
        let current = try #require(data.currentWeight)
        #expect(data.value(for: latest) == NSDecimalNumber(decimal: current).doubleValue)
        #expect(data.formattedWeight(current).hasSuffix("kg"))
    }

    @Test func singleMeasurementHasVisibleYAxisRangeAndNearestSelection() {
        let measurement = WeightMeasurement(date: Date(timeIntervalSince1970: 0), weight: 44.6)
        let data = WeightChartData(measurements: [measurement])
        #expect(data.yDomain.lowerBound < data.value(for: measurement))
        #expect(data.yDomain.upperBound > data.value(for: measurement))
        #expect(data.selection(nearestTo: measurement.date.addingTimeInterval(10)) == measurement)
    }

    @Test func selectionSnapsToMeasurementsRatherThanInventingDailyWeights() {
        let first = WeightMeasurement(date: Date(timeIntervalSince1970: 0), weight: 40)
        let last = WeightMeasurement(date: first.date.addingTimeInterval(6 * 86_400), weight: 44)
        let data = WeightChartData(measurements: [last, first])
        #expect(data.selection(nearestTo: first.date.addingTimeInterval(86_400)) == first)
        #expect(data.selection(nearestTo: first.date.addingTimeInterval(3 * 86_400)) == first)
        #expect(data.selection(nearestTo: first.date.addingTimeInterval(5 * 86_400)) == last)
    }
}
