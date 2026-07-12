//
//  PetStore.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/4/26.
//

import Combine
import Foundation

protocol PetStoring {
    var petPublisher: AnyPublisher<Pet?, Never> { get }
    var currentPet: Pet? { get }
    func select(pet: Pet)
}

final class PetStore: PetStoring {
    private var selectedPet = CurrentValueSubject<Pet?, Never>(nil)

    var currentPet: Pet? {
        selectedPet.value
    }
    var petPublisher: AnyPublisher<Pet?, Never> {
        selectedPet.eraseToAnyPublisher()
    }

    func select(pet: Pet) {
        selectedPet.value = pet
    }
}
