//
//  LogDetailsViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import Combine
import Foundation

class LogDetailsViewModel {
    struct State {
        let pet: Pet
        let log: PoopLog
    }

    @Published var state: State

    init(pet: Pet, log: PoopLog) {
        state = State(pet: pet, log: log)
    }
}
