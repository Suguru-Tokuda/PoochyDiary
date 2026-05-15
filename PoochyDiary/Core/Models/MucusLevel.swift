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

    var name: String {
        rawValue.firstLetterUppercased()
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
