//
//  StoolTypeTests.swift
//  PoochyDiaryTests
//

import Testing

@testable import PoochyDiary

struct StoolTypeTests {

    @Test func allCases_hasExpectedCount() {
        #expect(StoolType.allCases.count == 6)
    }

    @Test func id_isUniquePerCase() {
        let ids = StoolType.allCases.map { $0.id }
        #expect(Set(ids).count == StoolType.allCases.count)
    }

    @Test func name_extraFirm_returnsCorrectName() {
        #expect(StoolType.extraFirm.name == "Extra Firm")
    }

    @Test func name_otherCases_areCapitalized() {
        let cases: [StoolType] = [.firm, .normal, .soft, .mushy, .watery]
        cases.forEach { stoolType in
            let name = stoolType.name
            #expect(name.first?.isUppercase == true)
        }
    }

    @Test func rawValue_canRoundTrip() {
        StoolType.allCases.forEach { stoolType in
            #expect(StoolType(rawValue: stoolType.rawValue) == stoolType)
        }
    }
}
