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
}
