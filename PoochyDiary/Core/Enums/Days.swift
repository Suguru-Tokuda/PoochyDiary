//
//  Days.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/11/26.
//

import Foundation

enum Days {
  case sunday
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday

  init(date: Date, calendar: Calendar = .current) {
    switch calendar.component(.weekday, from: date) {
    case 1: self = .sunday
    case 2: self = .monday
    case 3: self = .tuesday
    case 4: self = .wednesday
    case 5: self = .thursday
    case 6: self = .friday
    case 7: self = .saturday
    default: self = .sunday
    }
  }

  var short: String {
    switch self {
    case .sunday:
      return "SUN"
    case .monday:
      return "MON"
    case .tuesday:
      return "TUE"
    case .wednesday:
      return "WED"
    case .thursday:
      return "THU"
    case .friday:
      return "FRI"
    case .saturday:
      return "SAT"
    }
  }
}
