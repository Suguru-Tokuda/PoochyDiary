//
//  TrendsViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import Foundation
import SwiftUI

class TrendsViewModel {
    struct Model {
        let totalPoops: Int
        let averagePerDay: Float
        let chartData: ChartData
    }

    @Published private(set) var model: Model?
    @Published private(set) var timeFrame: TrendTimeFramesView.TimeFrame = .week

    init() {
        loadData()
    }

    func selectTimeFrame(_ timeFrame: TrendTimeFramesView.TimeFrame) {
        self.timeFrame = timeFrame
        loadData()
    }

    private func loadData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let poopCounts = [1, 2, 1, 2, 2, 3, 4]
        let bloodCounts = [0, 0, 1, 0, 0, 0, 1]
        let mucusCounts = [0, 1, 0, 1, 1, 0, 2]

        // Anchor the pattern to today so overlapping ranges contain the same counts.
        func dailyCounts(_ counts: [Int]) -> [DailyCount] {
            (0..<timeFrame.rawValue).reversed().compactMap { daysAgo in
                guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else {
                    return nil
                }
                let index = counts.count - 1 - daysAgo % counts.count
                return DailyCount(date: date, count: counts[index])
            }
        }

        let settings: ChartData.DisplaySettings

        switch timeFrame {
        case .week:
            settings = .sevenDays
        case .month:
            settings = .thirtyDays
        case .quarter:
            settings = .ninetyDays
        }

        let poops = dailyCounts(poopCounts)
        let totalPoops = poops.reduce(0) { $0 + $1.count }
        model = Model(
            totalPoops: totalPoops,
            averagePerDay: poops.isEmpty ? 0 : Float(totalPoops) / Float(poops.count),
            chartData: ChartData(
                dataSet: [
                    ChartGroup(legendTitle: "Poops", data: poops, color: .green),
                    ChartGroup(legendTitle: "Blood", data: dailyCounts(bloodCounts), color: .red),
                    ChartGroup(legendTitle: "Mucus", data: dailyCounts(mucusCounts), color: .purple)
                ],
                displaySettings: settings
            )
        )
    }
}
