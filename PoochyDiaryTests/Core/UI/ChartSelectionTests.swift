import Foundation
import SwiftUI
import Testing

@testable import PoochyDiary

@MainActor
struct ChartSelectionTests {
    private let firstDate = Date(timeIntervalSince1970: 0)
    private let lastDate = Date(timeIntervalSince1970: 86_400)

    private var data: ChartData {
        ChartData(dataSet: [
            ChartGroup(legendTitle: "Poops", data: [
                DailyCount(date: firstDate, count: 2),
                DailyCount(date: lastDate, count: 4)
            ], color: .green),
            ChartGroup(legendTitle: "Blood", data: [
                DailyCount(date: firstDate, count: 0),
                DailyCount(date: lastDate, count: 1)
            ], color: .red)
        ])
    }

    @Test func emptyChartHasNoSelection() {
        #expect(ChartData(dataSet: []).selection(nearestTo: firstDate) == nil)
    }

    @Test func snapsToNearestPointAndReturnsAllSeriesIncludingZeroCounts() throws {
        let first = try #require(data.selection(nearestTo: firstDate.addingTimeInterval(3_600)))
        #expect(first.date == firstDate)
        #expect(first.values.map(\.legendTitle) == ["Poops", "Blood"])
        #expect(first.values.map(\.count) == [2, 0])
        let last = try #require(data.selection(nearestTo: lastDate.addingTimeInterval(-3_600)))
        #expect(last.date == lastDate)
        #expect(last.values.map(\.count) == [4, 1])
    }

    @Test func midpointConsistentlySelectsEarlierDate() {
        #expect(data.selection(nearestTo: firstDate.addingTimeInterval(43_200))?.date == firstDate)
    }

    @Test func datesOutsideRangeSelectNearestEndpoint() {
        #expect(data.selection(nearestTo: firstDate.addingTimeInterval(-86_400))?.date == firstDate)
        #expect(data.selection(nearestTo: lastDate.addingTimeInterval(86_400))?.date == lastDate)
    }

    @Test func missingSeriesPointIsNotReportedAsZero() throws {
        let sparseData = ChartData(dataSet: [
            data.dataSet[0],
            ChartGroup(legendTitle: "Mucus", data: [
                DailyCount(date: firstDate, count: 1)
            ], color: .purple)
        ])
        let selection = try #require(sparseData.selection(nearestTo: lastDate))
        #expect(selection.values.map(\.legendTitle) == ["Poops"])
        #expect(selection.values.map(\.count) == [4])
    }
}
