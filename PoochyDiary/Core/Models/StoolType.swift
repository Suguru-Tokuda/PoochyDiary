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

    var id: String {
        switch self {
        case .extraFirm:
            return "0"
        case .firm:
            return "1"
        case .normal:
            return "2"
        case .soft:
            return "3"
        case .mushy:
            return "4"
        case .watery:
            return "5"
        }
    }

    var name: String {
        switch self {
        case .extraFirm:
            return Strings.HealthValue.extraFirm
        case .firm:
            return Strings.HealthValue.firm
        case .normal:
            return Strings.HealthValue.normal
        case .soft:
            return Strings.HealthValue.soft
        case .mushy:
            return Strings.HealthValue.mushy
        case .watery:
            return Strings.HealthValue.watery
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
