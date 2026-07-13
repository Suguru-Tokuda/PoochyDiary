//
//  Diary.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import Foundation

nonisolated struct PoopDiaryData: Equatable, Hashable {
    let stoolType: StoolType
    let mucusLevel: MucusLevel
    let bloodAmount: BloodAmount
}

nonisolated enum WeightUnit: String, Codable, Hashable {
    case kilograms
    case pounds
}

nonisolated struct WeightDiaryData: Equatable, Hashable {
    let weight: Decimal
    let unit: WeightUnit
}

nonisolated enum DiaryType: Equatable, Hashable {
    case poop(PoopDiaryData)
    case weight(WeightDiaryData)

    var persistenceValue: String {
        switch self {
        case .poop:
            return "poop"
        case .weight:
            return "weight"
        }
    }
}

nonisolated struct Diary: Identifiable, Equatable, Hashable {
    let id: UUID
    let petId: UUID
    var date: Date
    var type: DiaryType
    var notes: String?
    var photos: [Photo]
    var tags: [Tag]

    init(
        id: UUID,
        petId: UUID,
        date: Date,
        type: DiaryType,
        note: String? = nil,
        photos: [Photo],
        tags: [Tag]
    ) {
        self.id = id
        self.petId = petId
        self.date = date
        self.type = type
        self.notes = note
        self.photos = photos
        self.tags = tags
    }

    init(
        id: UUID,
        petId: UUID,
        date: Date,
        stoolType: StoolType,
        mucusLevel: MucusLevel,
        bloodAmount: BloodAmount,
        note: String? = nil,
        photos: [Photo],
        tags: [Tag]
    ) {
        self.init(
            id: id,
            petId: petId,
            date: date,
            type: .poop(
                PoopDiaryData(
                    stoolType: stoolType,
                    mucusLevel: mucusLevel,
                    bloodAmount: bloodAmount
                )
            ),
            note: note,
            photos: photos,
            tags: tags
        )
    }

    var poopData: PoopDiaryData? {
        guard case .poop(let data) = type else { return nil }
        return data
    }

    var weightData: WeightDiaryData? {
        guard case .weight(let data) = type else { return nil }
        return data
    }
}
