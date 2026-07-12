//
//  DateExtensionsTests.swift
//  PoochyDiaryTests
//

import Foundation
import Testing

@testable import PoochyDiary

struct DateExtensionsTests {

  @Test func formatted_withTimeFormat_returnsCorrectString() {
    var components = DateComponents()
    components.year = 2026
    components.month = 6
    components.day = 5
    components.hour = 8
    components.minute = 45
    components.second = 0

    let date = Calendar.current.date(from: components)!
    let result = date.formatted(with: "hh:mm a")

    #expect(result == "08:45 AM")
  }

  @Test func formatted_withDateFormat_returnsCorrectString() {
    var components = DateComponents()
    components.year = 2026
    components.month = 6
    components.day = 5

    let date = Calendar.current.date(from: components)!
    let result = date.formatted(with: "yyyy-MM-dd")

    #expect(result == "2026-06-05")
  }

  @Test func formatted_withEmptyFormat_returnsEmptyString() {
    let date = Date()
    #expect(date.formatted(with: "").isEmpty)
  }
}
