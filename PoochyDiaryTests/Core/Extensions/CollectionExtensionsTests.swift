//
//  CollectionExtensionsTests.swift
//  PoochyDiaryTests
//

import Testing

@testable import PoochyDiary

struct CollectionExtensionsTests {

    // MARK: - Array

    @Test func safeSubscript_validIndex_returnsElement() {
        let array = [1, 2, 3]
        #expect(array[safe: 0] == 1)
        #expect(array[safe: 2] == 3)
    }

    @Test func safeSubscript_outOfBoundsIndex_returnsNil() {
        let array = [1, 2, 3]
        #expect(array[safe: 3] == nil)
        #expect(array[safe: -1] == nil)
    }

    @Test func safeSubscript_emptyArray_returnsNil() {
        let array: [Int] = []
        #expect(array[safe: 0] == nil)
    }
}
