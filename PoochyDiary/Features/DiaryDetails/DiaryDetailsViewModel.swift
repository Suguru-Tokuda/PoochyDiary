//
//  DiaryDetailsViewModel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import Combine
import Foundation

class DiaryDetailsViewModel {
  struct State {
    let pet: Pet
    let diary: Diary
  }

  @Published var state: State

  init(pet: Pet, diary: Diary) {
    state = State(pet: pet, diary: diary)
  }
}
