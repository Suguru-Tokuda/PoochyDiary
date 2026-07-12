//
//  Diary.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import Foundation

nonisolated struct Diary: Identifiable, Equatable, Hashable {
    let id: UUID
    let petId: UUID
    var date: Date
    var stoolType: StoolType
    var mucusLevel: MucusLevel
    var bloodAmount: BloodAmount
    var notes: String?
    var photos: [Photo]
    var tags: [Tag]

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
        self.id = id
        self.petId = petId
        self.date = date
        self.stoolType = stoolType
        self.mucusLevel = mucusLevel
        self.bloodAmount = bloodAmount
        self.notes = note
        self.photos = photos
        self.tags = tags
    }
}
