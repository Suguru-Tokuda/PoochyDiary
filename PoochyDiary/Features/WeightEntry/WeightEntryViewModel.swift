//
//  WeightEntryViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/13/26.
//

import Foundation

@MainActor
final class WeightEntryViewModel {
    private(set) var weightText = ""
    private(set) var unit: WeightUnit = .pounds
    private(set) var date = Date()

    private let pet: Pet
    private let dataManager: PoochyDiaryCoreDataManaging

    init(pet: Pet, dataManager: PoochyDiaryCoreDataManaging) {
        self.pet = pet
        self.dataManager = dataManager
    }

    func updateWeight(_ text: String) {
        weightText = text
    }

    func updateUnit(_ unit: WeightUnit) {
        self.unit = unit
    }

    func updateDate(_ date: Date) {
        self.date = date
    }

    func save() async throws -> Diary {
        guard let weight = parsedWeight(), weight > 0 else {
            throw WeightEntryError.invalidWeight
        }

        let diary = Diary(
            id: UUID(),
            petId: pet.id,
            date: date,
            type: .weight(WeightDiaryData(weight: weight, unit: unit)),
            photos: [],
            tags: []
        )
        try await dataManager.saveDiary(diary: diary)
        return diary
    }

    private func parsedWeight() -> Decimal? {
        let normalized = weightText.replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized)
    }
}

enum WeightEntryError: Error {
    case invalidWeight
}
