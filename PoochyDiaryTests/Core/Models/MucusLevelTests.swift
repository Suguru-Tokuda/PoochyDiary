//
//  MucusLevelTests.swift
//  PoochyDiaryTests
//

import Testing

@testable import PoochyDiary

struct MucusLevelTests {

  @Test func allCases_hasExpectedCount() {
    #expect(MucusLevel.allCases.count == 5)
  }

  @Test func id_isUniquePerCase() {
    let ids = MucusLevel.allCases.map { $0.id }
    #expect(Set(ids).count == MucusLevel.allCases.count)
  }

  @Test func name_isCapitalized() {
    MucusLevel.allCases.forEach { level in
      #expect(level.name.first?.isUppercase == true)
    }
  }

  @Test func rawValue_canRoundTrip() {
    MucusLevel.allCases.forEach { level in
      #expect(MucusLevel(rawValue: level.rawValue) == level)
    }
  }
}
