//
//  StoolType.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import UIKit

enum StoolType: String, CaseIterable, Codable {
    case veryHard
    case firm
    case normal
    case soft
    case mushy
    case watery
    case mixed

    var name: String {
        rawValue.firstLetterUppercased()
    }

    var imageName: String {
        switch self {
        case .veryHard:
            return ""
        case .firm:
            return ""
        case .normal:
            return ""
        case .soft:
            return ""
        case .mushy:
            return ""
        case .watery:
            return ""
        case .mixed:
            return ""
        }
    }
}
