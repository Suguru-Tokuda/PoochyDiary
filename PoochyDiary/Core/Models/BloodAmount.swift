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
  case moderate
  case large

  var id: String {
    switch self {
    case .none:
      return "0"
    case .speck:
      return "1"
    case .streak:
      return "2"
    case .moderate:
      return "3"
    case .large:
      return "4"
    }
  }

  var name: String {
    rawValue.firstLetterUppercased()
  }

  var imageName: PDIcons {
    switch self {
    case .none:
      return .bloodNone
    case .speck:
      return .bloodSpeck
    case .streak:
      return .bloodStreak
    case .moderate:
      return .bloodModerate
    case .large:
      return .bloodLarge
    }
  }
}
