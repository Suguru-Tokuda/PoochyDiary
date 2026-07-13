//
//  PetSelectionViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import Combine
import Foundation

final class PetSelectionViewModel {
    @Published private(set) var pets: [Pet] = []
    @Published private(set) var selectedPet: Pet?
    @Published private(set) var error: Error?

    private let dataManager: PoochyDiaryCoreDataManaging?

    init(
        selectedPet: Pet?,
        dataManager: PoochyDiaryCoreDataManaging?
    ) {
        self.selectedPet = selectedPet
        self.dataManager = dataManager
    }

    func loadPets() async {
        if AppConfiguration.useMockData {
            pets = Pet.mockPets()
            alignMockSelection()
            return
        }

        guard let dataManager else { return }

        do {
            pets = try await dataManager.getPets()
        } catch {
            self.error = error
        }
    }

    func select(_ pet: Pet) {
        selectedPet = pet
    }

    func isSelected(_ pet: Pet) -> Bool {
        selectedPet?.id == pet.id
    }

    private func alignMockSelection() {
        guard let selectedPet else {
            selectedPet = pets.first
            return
        }

        self.selectedPet = pets.first { $0.name == selectedPet.name } ?? pets.first
    }
}
