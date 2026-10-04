import Foundation
import Testing

@testable import PoochyDiary

@MainActor
struct TrendsViewModelTests {
    @Test func loadsWeeklyMockDataOnInitialization() throws {
        let viewModel = TrendsViewModel()
        let model = try #require(viewModel.model)
        #expect(viewModel.timeFrame == .week)
        #expect(model.summary.totalPoops == 15)
        #expect(model.summary.averagePerDay == Float(15) / 7)
        #expect(model.chartData.dataSet.map(\.legendTitle) == ["Poops", "Blood", "Mucus"])
        #expect(model.summary.bloodCount == 2)
        #expect(model.summary.mucusCount == 5)
        #expect(model.summary.bloodFraction == Double(2) / 15)
        #expect(model.summary.mucusFraction == Double(5) / 15)
        #expect(model.summary.daysLogged == 7)
    }

    @Test(arguments: TrendTimeFramesView.TimeFrame.allCases)
    func selectedRangeIncludesEveryDayAndConsistentSummary(
        timeFrame: TrendTimeFramesView.TimeFrame
    ) throws {
        let viewModel = TrendsViewModel()
        let weeklyPoops = try #require(viewModel.model).chartData.dataSet[0].data.map(\.count)
        viewModel.selectTimeFrame(timeFrame)
        let model = try #require(viewModel.model)
        #expect(viewModel.timeFrame == timeFrame)
        let weights = model.weightChartData
        #expect(weights.measurements.count == (timeFrame.rawValue + 2) / 3)
        #expect(weights.currentWeight == Decimal(446) / 10)
        #expect(weights.measurements.allSatisfy { weights.dateRange.contains($0.date) })
        #expect(model.summary.weightData == weights)
        for group in model.chartData.dataSet {
            #expect(group.data.count == timeFrame.rawValue)
            #expect(Set(group.data.map(\.date)).count == timeFrame.rawValue)
            #expect(group.data.map(\.date) == group.data.map(\.date).sorted())
            #expect(Calendar.current.isDateInToday(try #require(group.data.last).date))
        }
        let poops = model.chartData.dataSet[0].data
        #expect(Array(poops.suffix(7).map(\.count)) == weeklyPoops)
        #expect(model.summary.totalPoops == poops.reduce(0) { $0 + $1.count })
        #expect(model.summary.averagePerDay == Float(model.summary.totalPoops) / Float(timeFrame.rawValue))
        #expect(model.summary.totalDays == timeFrame.rawValue)
        let bloodCount = model.chartData.dataSet[1].data.reduce(0) { $0 + $1.count }
        let mucusCount = model.chartData.dataSet[2].data.reduce(0) { $0 + $1.count }
        #expect(model.summary.bloodFraction == Double(bloodCount) / Double(model.summary.totalPoops))
        #expect(model.summary.mucusFraction == Double(mucusCount) / Double(model.summary.totalPoops))
        #expect(model.summary.startDate == poops.first?.date)
        #expect(model.summary.endDate == poops.last?.date)
    }

    @Test func changingUnitConvertsWeightWithoutChangingPeriodOrMeasurements() throws {
        let viewModel = TrendsViewModel()
        viewModel.selectTimeFrame(.month)
        let original = try #require(viewModel.model).weightChartData
        viewModel.updateWeightUnit(.kilograms)
        let converted = try #require(viewModel.model).weightChartData
        #expect(viewModel.timeFrame == .month)
        #expect(converted.measurements == original.measurements)
        #expect(converted.dateRange == original.dateRange)
        #expect(converted.unit == .kilograms)
        let currentWeight = try #require(original.currentWeight)
        let averageWeight = try #require(original.averageWeight)
        #expect(converted.currentWeight == WeightUnit.kilograms.displayValue(fromPounds: currentWeight))
        #expect(converted.averageWeight == WeightUnit.kilograms.displayValue(fromPounds: averageWeight))
    }
}
