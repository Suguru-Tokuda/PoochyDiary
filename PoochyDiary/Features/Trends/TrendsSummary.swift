import Foundation

struct TrendsSummary {
    let startDate: Date?
    let endDate: Date?
    let totalPoops: Int
    let bloodCount: Int
    let mucusCount: Int
    let daysLogged: Int
    let totalDays: Int
    let weightData: WeightChartData

    var averagePerDay: Float {
        totalDays > 0 ? Float(totalPoops) / Float(totalDays) : 0
    }

    var bloodFraction: Double? { fraction(for: bloodCount) }
    var mucusFraction: Double? { fraction(for: mucusCount) }

    init(
        poops: [DailyCount],
        blood: [DailyCount],
        mucus: [DailyCount],
        weightData: WeightChartData = .empty
    ) {
        self.weightData = weightData
        startDate = poops.map(\.date).min()
        endDate = poops.map(\.date).max()
        totalPoops = poops.reduce(0) { $0 + $1.count }
        bloodCount = blood.reduce(0) { $0 + $1.count }
        mucusCount = mucus.reduce(0) { $0 + $1.count }
        daysLogged = poops.filter { $0.count >= 1 }.count
        totalDays = poops.count
    }

    private func fraction(for count: Int) -> Double? {
        guard totalPoops > 0 else { return nil }
        return Double(count) / Double(totalPoops)
    }
}
