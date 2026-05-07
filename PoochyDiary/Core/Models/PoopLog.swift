//
//  PoopLog.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import Foundation

struct PoopLog: Identifiable, Equatable, Codable {
    let id: UUID
    let petId: UUID
    var date: Date
    var stoolType: StoolType
    var mucusLevel: MucusLevel
    var bloodAmount: BloodAmount
    var note: String?
    var imageFileNames: [String]
    var tags: [Tag]

    init(id: UUID,
         petId: UUID,
         date: Date,
         stoolType: StoolType,
         mucusLevel: MucusLevel,
         bloodAmount: BloodAmount,
         note: String? = nil,
         imageFileNames: [String],
         tags: [Tag]
    ) {
        self.id = id
        self.petId = petId
        self.date = date
        self.stoolType = stoolType
        self.mucusLevel = mucusLevel
        self.bloodAmount = bloodAmount
        self.note = note
        self.imageFileNames = imageFileNames
        self.tags = tags
    }

    init?(
        _ entity: PoopLogEntity,
        imageFileNames: [String],
        tags: [Tag]
    ) {
        guard let id = entity.id,
              let petId = entity.petId,
              let date = entity.date,
              let stoolTypeStr = entity.stoolType,
              let stoolType = StoolType(rawValue: stoolTypeStr),
              let mucusLevelStr = entity.mucusLevel,
              let mucusLevel = MucusLevel(rawValue: mucusLevelStr),
              let bloodAmountStr = entity.bloodAmount,
              let bloodAmount = BloodAmount(rawValue: bloodAmountStr)
        else { return nil }
        self.id = id
        self.petId = petId
        self.date = date
        self.stoolType = stoolType
        self.bloodAmount = bloodAmount
        self.mucusLevel = mucusLevel
        self.imageFileNames = imageFileNames
        self.tags = tags
    }
}
