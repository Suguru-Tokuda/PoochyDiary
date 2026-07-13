//
//  MucusLevel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import Foundation

enum MucusLevel: String, CaseIterable, Codable {
    case none
    case trace
    case mild
    case moderate
    case heavy

    var id: String {
        switch self {
        case .none:
            return "0"
        case .trace:
            return "1"
        case .mild:
            return "2"
        case .moderate:
            return "3"
        case .heavy:
            return "4"
        }
    }

    var name: String {
        switch self {
        case .none:
            return Strings.HealthValue.none
        case .trace:
            return Strings.HealthValue.trace
        case .mild:
            return Strings.HealthValue.mild
        case .moderate:
            return Strings.HealthValue.moderate
        case .heavy:
            return Strings.HealthValue.heavy
        }
    }

    var imageName: PDIcons {
        switch self {
        case .none:
            return .stoolNormal
        case .trace:
            return .mucusTrace
        case .mild:
            return .mucusMild
        case .moderate:
            return .mucusModerate
        case .heavy:
            return .mucusHeavy
        }
    }
}
