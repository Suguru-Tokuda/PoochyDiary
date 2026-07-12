//
//  BloodAmountTests.swift
//  PoochyDiaryTests
//

import Testing

@testable import PoochyDiary

struct BloodAmountTests {

  @Test func allCases_hasExpectedCount() {
    #expect(BloodAmount.allCases.count == 5)
  }

  @Test func id_isUniquePerCase() {
    let ids = BloodAmount.allCases.map { $0.id }
    #expect(Set(ids).count == BloodAmount.allCases.count)
  }

  @Test func name_isCapitalized() {
    BloodAmount.allCases.forEach { amount in
      #expect(amount.name.first?.isUppercase == true)
    }
  }

  @Test func rawValue_canRoundTrip() {
    BloodAmount.allCases.forEach { amount in
      #expect(BloodAmount(rawValue: amount.rawValue) == amount)
    }
  }
}
