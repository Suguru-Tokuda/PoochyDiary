import Foundation
import Testing

@testable import PoochyDiary

@MainActor
struct TrendsViewModelTests {
    @Test func loadsWeeklyMockDataOnInitialization() throws {
        let viewModel = TrendsViewModel()
        let model = try #require(viewModel.model)
        #expect(viewModel.timeFrame == .week)
        #expect(model.totalPoops == 15)
        #expect(model.averagePerDay == Float(15) / 7)
        #expect(model.chartData.dataSet.map(\.legendTitle) == ["Poops", "Blood", "Mucus"])
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
        for group in model.chartData.dataSet {
            #expect(group.data.count == timeFrame.rawValue)
            #expect(Set(group.data.map(\.date)).count == timeFrame.rawValue)
            #expect(group.data.map(\.date) == group.data.map(\.date).sorted())
            #expect(Calendar.current.isDateInToday(try #require(group.data.last).date))
        }
        let poops = model.chartData.dataSet[0].data
        #expect(Array(poops.suffix(7).map(\.count)) == weeklyPoops)
        #expect(model.totalPoops == poops.reduce(0) { $0 + $1.count })
        #expect(model.averagePerDay == Float(model.totalPoops) / Float(timeFrame.rawValue))
    }
}
