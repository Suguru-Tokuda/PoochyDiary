import SwiftUI
import Testing

@testable import PoochyDiary

@MainActor
struct DistributionChartViewTests {
    @Test func totalIncludesEveryCategory() {
        let chart = DistributionChartView(items: [
            .init(title: "Type 1", count: 1, color: .teal),
            .init(title: "Type 2", count: 2, color: .brown),
            .init(title: "Type 3", count: 4, color: .green),
            .init(title: "Type 4", count: 3, color: .purple),
            .init(title: "Type 5", count: 1, color: .red),
            .init(title: "Type 6", count: 1, color: .gray)
        ])
        #expect(chart.total == 12)
    }

    @Test(arguments: [0, 1, 2, 3, 4, 12])
    func percentageUsesCategoryShareAndRoundsToWholePercent(count: Int) {
        let chart = DistributionChartView(items: [
            .init(title: "Selected", count: count, color: .green),
            .init(title: "Other", count: 12 - count, color: .gray)
        ])
        let expectedPercent = [0: 0, 1: 8, 2: 17, 3: 25, 4: 33, 12: 100][count]!
        // Format the expected whole percentage with the current locale too.
        let expected = (Double(expectedPercent) / 100)
            .formatted(.percent.precision(.fractionLength(0)))
        #expect(chart.percentage(for: count) == expected)
    }

    @Test func emptyDistributionHasZeroTotalAndPercentage() {
        let chart = DistributionChartView(items: [])
        #expect(chart.total == 0)
        #expect(chart.percentage(for: 0) == "0%")
    }

    @Test func allZeroCategoriesHaveZeroPercentage() {
        let chart = DistributionChartView(items: [
            .init(title: "Type 1", count: 0, color: .teal),
            .init(title: "Type 2", count: 0, color: .brown)
        ])
        #expect(chart.total == 0)
        for item in chart.items {
            #expect(chart.percentage(for: item.count) == "0%")
        }
    }
}
