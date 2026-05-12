//
//  BloodAmount.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import Foundation

enum BloodAmount: String, CaseIterable, Codable {
    case none
    case speck
    case streak
    case small
    case moderate
    case large
    case urgent

    var name: String {
        rawValue.firstLetterUppercased()
    }

    var imageName: String {
        switch self {
        case .none:
            return ""
        case .speck:
            return ""
        case .streak:
            return ""
        case .small:
            return ""
        case .moderate:
            return ""
        case .large:
            return ""
        case .urgent:
            return ""
        }
    }
}
