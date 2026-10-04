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
        let chartData: ChartData
        let weightChartData: WeightChartData
        let summary: TrendsSummary
    }

    @Published private(set) var model: Model?
    @Published private(set) var timeFrame: TrendTimeFramesView.TimeFrame = .week
    @Published private(set) var pet: Pet?
    private(set) var weightUnit: WeightUnit

    init(pet: Pet? = nil, weightUnit: WeightUnit = .pounds) {
        self.pet = pet
        self.weightUnit = weightUnit
        loadData()
    }

    func updatePet(_ pet: Pet?) {
        self.pet = pet
        loadData()
    }

    func selectTimeFrame(_ timeFrame: TrendTimeFramesView.TimeFrame) {
        self.timeFrame = timeFrame
        loadData()
    }

    func updateWeightUnit(_ unit: WeightUnit) {
        guard weightUnit != unit else { return }
        weightUnit = unit
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
        let blood = dailyCounts(bloodCounts)
        let mucus = dailyCounts(mucusCounts)
        let startDate = calendar.date(byAdding: .day, value: -(timeFrame.rawValue - 1), to: today) ?? today
        let weights = WeightChartData(
            measurements: mockWeightMeasurements(calendar: calendar, today: today),
            unit: weightUnit,
            displaySettings: settings,
            dateRange: startDate...today
        )
        let summary = TrendsSummary(poops: poops, blood: blood, mucus: mucus, weightData: weights)
        model = Model(
            chartData: ChartData(
                dataSet: [
                    ChartGroup(legendTitle: Strings.Chart.poops, data: poops, color: .green),
                    ChartGroup(legendTitle: Strings.Chart.blood, data: blood, color: .red),
                    ChartGroup(legendTitle: Strings.Chart.mucus, data: mucus, color: .purple)
                ],
                displaySettings: settings
            ),
            weightChartData: weights,
            summary: summary
        )
    }

    private func mockWeightMeasurements(calendar: Calendar, today: Date) -> [WeightMeasurement] {
        stride(from: 0, to: timeFrame.rawValue, by: 3).compactMap { daysAgo in
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: today) else { return nil }
            let fluctuations = [0, 2, -1, 1]
            let tenthsOfPound = 446 + daysAgo / 6 + fluctuations[(daysAgo / 3) % fluctuations.count]
            return WeightMeasurement(date: date, weight: Decimal(tenthsOfPound) / 10)
        }
    }
}
