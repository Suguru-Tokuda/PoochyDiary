//
//  Date+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/3/26.
//

import Foundation

extension Date {
    init?(_ string: String, format: String = "yyyy-MM-dd") {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        guard let date = formatter.date(from: string) else { return nil }
        self = date
    }

    func formatted(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
