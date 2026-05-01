//
//  Pet.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import Foundation

struct Pet: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
    let dateOfBirth: Date?
    let gender: Gender
    let type: AnimalType
}
