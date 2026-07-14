//
//  WeightEntryViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/13/26.
//

import Combine
import Foundation

@MainActor
final class WeightEntryViewModel {
    @Published private(set) var weightText = ""
    private var weight: Decimal? // in lb
    private(set) var unit: WeightUnit {
        didSet {
            convertWeightText()
        }
    }
    private(set) var date: Date

    private let existingDiary: Diary?
    private let pet: Pet
    private let dataManager: PoochyDiaryCoreDataManaging
    private let appPreferences: AppPreferencing

    init(
        diary: Diary? = nil,
        pet: Pet,
        dataManager: PoochyDiaryCoreDataManaging,
        appPreferences: AppPreferencing
    ) {
        existingDiary = diary
        weight = diary?.weightData?.weight
        date = diary?.date ?? Date()
        self.pet = pet
        self.dataManager = dataManager
        self.appPreferences = appPreferences
        unit = appPreferences.weightUnit

        if let weight {
            weightText = Self.formatted(unit.displayValue(fromPounds: weight))
        }
    }

    func updateWeight(_ text: String) {
        weightText = text

        let normalizedText = text.replacingOccurrences(of: ",", with: ".")
        guard !normalizedText.isEmpty,
              let displayWeight = Decimal(string: normalizedText) else {
            weight = nil
            return
        }

        weight = unit.poundsValue(fromDisplayValue: displayWeight)
    }

    func updateUnit(_ unit: WeightUnit) {
        self.unit = unit
        appPreferences.weightUnit = unit
    }

    func updateDate(_ date: Date) {
        self.date = date
    }

    func save() async throws -> Diary {
        guard let weight, weight > 0 else {
            throw WeightEntryError.invalidWeight
        }

        let diary = Diary(
            id: existingDiary?.id ?? UUID(),
            petId: existingDiary?.petId ?? pet.id,
            date: date,
            type: .weight(WeightDiaryData(weight: weight)),
            note: existingDiary?.notes,
            photos: existingDiary?.photos ?? [],
            tags: existingDiary?.tags ?? []
        )
        try await dataManager.saveDiary(diary: diary)
        return diary
    }

    private func convertWeightText() {
        guard !weightText.isEmpty, let weight else { return }
        weightText = Self.formatted(unit.displayValue(fromPounds: weight))
    }

    private static func formatted(_ weight: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: weight as NSDecimalNumber) ?? "\(weight)"
    }
}

enum WeightEntryError: Error {
    case invalidWeight
}
