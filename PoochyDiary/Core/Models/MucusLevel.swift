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


    var imageName: String {
        switch self {
        case .none:
            return ""
        case .trace:
            return ""
        case .mild:
            return ""
        case .moderate:
            return ""
        case .heavy:
            return ""
        }
    }
}
