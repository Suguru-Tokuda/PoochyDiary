//
//  Date+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/3/26.
//

import Foundation

extension Date {
    func formatted(with format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
