//
//  StoolType.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import UIKit

enum StoolType: String, CaseIterable, Codable {
    case extraFirm
    case firm
    case normal
    case soft
    case mushy
    case watery

    var name: String {
        switch self {
        case .extraFirm:
            return "Extra Firm"
        default:
            return rawValue.firstLetterUppercased()
        }
    }

    var imageName: PDIcons {
        switch self {
        case .extraFirm:
            return .stoolExtraFirm
        case .firm:
            return .stoolFirm
        case .normal:
            return .stoolNormal
        case .soft:
            return .stoolSoft
        case .mushy:
            return .stoolMushy
        case .watery:
            return .stoolWatery
        }
    }
}
