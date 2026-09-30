import Foundation
import SwiftUI
import Testing

@testable import PoochyDiary

@MainActor
struct HomeWeeklyChartTests {
    @Test func mockProvidesAlignedSevenDaySeriesIncludingZeroCounts() throws {
        let calendar = Calendar.current
        let before = calendar.startOfDay(for: Date())
        let model = HomeView.Model.mock(petName: "Poochy")
        let after = calendar.startOfDay(for: Date())
        let groups = model.weeklyChartData.dataSet

        #expect(model.petName == "Poochy")
        #expect(groups.map(\.legendTitle) == [Strings.Home.poops, Strings.Home.blood, Strings.Home.mucus])
        #expect(groups.map(\.color) == [.green, .red, .purple])
        #expect(groups.map { $0.data.map(\.count) } == [
            [1, 1, 0, 1, 1, 1, 1],
            [0, 0, 0, 1, 0, 0, 0],
            [0, 1, 0, 0, 0, 0, 0]
        ])
        let dates = try #require(groups.first).data.map(\.date)
        #expect(dates.count == 7)
        let last = try #require(dates.last)
        #expect(last == before || last == after)
        for group in groups {
            #expect(group.data.map(\.date) == dates)
        }
        for (index, date) in dates.enumerated() {
            #expect(date == calendar.date(byAdding: .day, value: index - 6, to: last))
            #expect(date == calendar.startOfDay(for: date))
        }
    }
}
