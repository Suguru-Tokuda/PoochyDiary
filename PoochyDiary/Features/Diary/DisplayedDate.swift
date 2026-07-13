//
//  DisplayedDate.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import Foundation

struct DisplayedDate {
    let date: Date
    let hasDiary: Bool
    let isSelected: Bool
}

extension DisplayedDate {
    static func mock(diaries: [Diary] = Diary.mockData()) -> [DisplayedDate] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return (-6...0).compactMap { offset in
            guard let date = calendar.date(byAdding: .day, value: offset, to: today) else {
                return nil
            }

            return DisplayedDate(
                date: date,
                hasDiary: diaries.contains { calendar.isDate($0.date, inSameDayAs: date) },
                isSelected: calendar.isDate(date, inSameDayAs: today)
            )
        }
    }
}
