import Foundation
import Testing
import UIKit

@testable import PoochyDiary

@MainActor
struct TrendsSummaryTests {
    @Test func noRecordsHaveNoSymptomPercentage() {
        let summary = TrendsSummary(poops: [], blood: [], mucus: [])
        #expect(summary.bloodFraction == nil)
        #expect(summary.mucusFraction == nil)
        #expect(summary.averagePerDay == 0)
        #expect(summary.totalPoops == 0)
        #expect(summary.daysLogged == 0)
        #expect(summary.startDate == nil)
        #expect(summary.endDate == nil)
    }

    @Test func averageIncludesUnloggedDaysAndSymptomsMayOverlap() {
        let date = Date(timeIntervalSince1970: 0)
        let nextDate = date.addingTimeInterval(86_400)
        let summary = TrendsSummary(
            poops: [DailyCount(date: date, count: 0), DailyCount(date: nextDate, count: 2)],
            blood: [DailyCount(date: nextDate, count: 2)],
            mucus: [DailyCount(date: nextDate, count: 2)]
        )
        #expect(summary.daysLogged == 1)
        #expect(summary.totalDays == 2)
        #expect(summary.averagePerDay == 1)
        #expect(summary.bloodFraction == 1)
        #expect(summary.mucusFraction == 1)
    }

    @Test func zeroCountsAcrossRangeDoNotDivideByZero() {
        let summary = TrendsSummary(
            poops: [DailyCount(date: Date(), count: 0)], blood: [], mucus: []
        )
        #expect(summary.totalDays == 1)
        #expect(summary.daysLogged == 0)
        #expect(summary.bloodFraction == nil)
        #expect(summary.mucusFraction == nil)
    }

    @Test(arguments: [UIContentSizeCategory.large, .accessibilityExtraExtraExtraLarge])
    func summaryFitsNarrowWidthAndShowsMockValues(textSize: UIContentSizeCategory) throws {
        let view = TrendsSummaryView()
        view.traitOverrides.preferredContentSizeCategory = textSize
        view.model = try #require(TrendsViewModel().model).summary
        let size = view.systemLayoutSizeFitting(
            CGSize(width: 320, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        view.frame = CGRect(origin: .zero, size: size)
        view.layoutIfNeeded()
        #expect(size.height > 0)
        #expect(size.width == 320)
        #expect(!view.hasAmbiguousLayout)
        let elements = descendants(of: view)
        let labels = elements.compactMap { $0 as? UILabel }.compactMap(\.text)
        #expect(labels.contains("13%"))
        #expect(labels.contains("33%"))
        #expect(labels.contains("2 of 15 logged poops"))
        #expect(labels.contains("5 of 15 logged poops"))
        #expect(labels.contains(Strings.Trends.currentWeight))
        #expect(labels.contains(Strings.Trends.averageWeight))
        let weights = try #require(TrendsViewModel().model).weightChartData
        #expect(labels.contains(weights.formattedWeight(weights.currentWeight)))
        #expect(labels.contains(weights.formattedWeight(weights.averageWeight)))
        for card in elements.compactMap({ $0 as? TrendsPercentageCardView }) {
            let frame = card.convert(card.bounds, to: view)
            #expect(view.bounds.contains(frame))
            #expect(card.isAccessibilityElement)
        }
    }

    private func descendants(of view: UIView) -> [UIView] {
        view.subviews.flatMap { [$0] + descendants(of: $0) }
    }
}
