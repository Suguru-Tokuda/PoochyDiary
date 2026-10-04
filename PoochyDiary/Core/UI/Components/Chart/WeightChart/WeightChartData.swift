import Foundation

struct WeightMeasurement: Identifiable, Equatable {
    let date: Date
    let weight: Decimal // Stored in pounds, matching WeightDiaryData.

    var id: Date { date }
}

struct WeightChartData: Equatable {
    let measurements: [WeightMeasurement]
    let unit: WeightUnit
    let displaySettings: ChartData.DisplaySettings
    let dateRange: ClosedRange<Date>

    static let empty = WeightChartData(measurements: [])

    init(
        measurements: [WeightMeasurement],
        unit: WeightUnit = .pounds,
        displaySettings: ChartData.DisplaySettings = .sevenDays,
        dateRange: ClosedRange<Date>? = nil
    ) {
        self.measurements = measurements
            .filter { $0.weight > 0 && (dateRange?.contains($0.date) ?? true) }
            .sorted { $0.date < $1.date }
        self.unit = unit
        self.displaySettings = displaySettings
        let first = self.measurements.first?.date ?? Date(timeIntervalSince1970: 0)
        let last = self.measurements.last?.date ?? first
        self.dateRange = dateRange ?? first...max(last, first.addingTimeInterval(86_400))
    }

    var currentWeight: Decimal? {
        measurements.last.map { unit.displayValue(fromPounds: $0.weight) }
    }

    var averageWeight: Decimal? {
        guard !measurements.isEmpty else { return nil }
        let total = measurements.reduce(Decimal.zero) { $0 + $1.weight }
        return unit.displayValue(fromPounds: total / Decimal(measurements.count))
    }

    var unitLabel: String {
        switch unit {
        case .pounds: Strings.Diary.poundsAbbreviation
        case .kilograms: Strings.Diary.kilogramsAbbreviation
        }
    }

    var yDomain: ClosedRange<Double> {
        let values = measurements.map(value(for:))
        let minimum = values.min() ?? 0
        let maximum = values.max() ?? 1
        let padding = max(max((maximum - minimum) * 0.2, maximum * 0.02), 0.1)
        return max(0, minimum - padding)...(maximum + padding)
    }

    func value(for measurement: WeightMeasurement) -> Double {
        NSDecimalNumber(decimal: unit.displayValue(fromPounds: measurement.weight)).doubleValue
    }

    func formattedWeight(_ weight: Decimal?) -> String {
        guard let weight else { return Strings.Common.unavailableValue }
        let value = NSDecimalNumber(decimal: weight).doubleValue
            .formatted(.number.precision(.fractionLength(1)))
        return Strings.Diary.weightValue(weight: value, unit: unitLabel)
    }

    func selection(nearestTo date: Date) -> WeightMeasurement? {
        measurements.min {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }
    }
}
