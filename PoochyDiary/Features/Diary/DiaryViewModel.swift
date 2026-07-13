//
//  DiaryViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import Foundation

class DiaryViewModel {
    @Published var visibleWeekDate = Date()
    @Published var displayedDates: [DisplayedDate] = []
    @Published var diaries: [Diary] = []

    init() {
        if AppConfiguration.useMockData {
            diaries = Diary.mockData()
            displayedDates = DisplayedDate.mock(diaries: diaries)
        }
        updateDisplayedDates()
    }

    func moveVisibleWeek(by offset: Int) {
        guard
            let date = Calendar.current.date(
                byAdding: .weekOfYear,
                value: offset,
                to: visibleWeekDate
            )
        else {
            return
        }

        visibleWeekDate = date
        updateDisplayedDates()
    }

    func selectDate(_ date: Date) {
        visibleWeekDate = date
        updateDisplayedDates()
    }

    func addDiary(_ diary: Diary) {
        diaries.removeAll { $0.id == diary.id }
        diaries.append(diary)
        diaries.sort { $0.date > $1.date }
        updateDisplayedDates()
    }

    private func updateDisplayedDates() {
        let calendar = Calendar.current

        guard
            let visibleWeekStart = calendar.dateInterval(
                of: .weekOfYear,
                for: visibleWeekDate
            )?.start
        else {
            return
        }

        displayedDates = (-7...13).compactMap { offset in
            guard
                let date = calendar.date(
                    byAdding: .day,
                    value: offset,
                    to: visibleWeekStart
                )
            else {
                return nil
            }

            return DisplayedDate(
                date: date,
                hasDiary: diaries.contains {
                    calendar.isDate($0.date, inSameDayAs: date)
                },
                isSelected: calendar.isDate(date, inSameDayAs: visibleWeekDate)
            )
        }
    }
}
