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

    init(id: UUID, name: String, dateOfBirth: Date?, gender: Gender, type: AnimalType) {
        self.id = id
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.type = type
    }

    init?(_ entity: PetEntity) {
        guard let id = entity.id,
              let name = entity.name,
              let dateOfBirth = entity.dateOfBirth,
              let genderStr = entity.gender,
              let gender = Gender(rawValue: genderStr),
              let type = entity.type,
              let animalType = AnimalType(rawValue: type) else {
            return nil
        }
        self.id = id
        self.name = name
        self.dateOfBirth = dateOfBirth
        self.gender = gender
        self.type = animalType
    }
}
