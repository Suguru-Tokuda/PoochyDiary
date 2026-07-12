//
//  StringExtensionsTests.swift
//  PoochyDiaryTests
//

import Testing

@testable import PoochyDiary

struct StringExtensionsTests {

    @Test func firstLetterUppercased_emptyString_returnsEmpty() {
        #expect("".firstLetterUppercased().isEmpty)
    }

    @Test func firstLetterUppercased_singleLowercase_returnsUppercase() {
        #expect("a".firstLetterUppercased() == "A")
    }

    @Test func firstLetterUppercased_allLowercase_uppercasesOnlyFirst() {
        #expect("hello".firstLetterUppercased() == "Hello")
    }

    @Test func firstLetterUppercased_allUppercase_lowercasesRest() {
        #expect("HELLO".firstLetterUppercased() == "Hello")
    }

    @Test func firstLetterUppercased_mixedCase_normalizesCorrectly() {
        #expect("hELLO".firstLetterUppercased() == "Hello")
    }

    @Test func firstLetterUppercased_alreadyCapitalized_unchanged() {
        #expect("Hello".firstLetterUppercased() == "Hello")
    }
}
