//
//  HomeViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Foundation

class HomeViewModel {
    var activePet: Pet = Pet(
        id: UUID(), name: Strings.Mock.leo, dateOfBirth: Date(), gender: .male, type: .dog)
}
