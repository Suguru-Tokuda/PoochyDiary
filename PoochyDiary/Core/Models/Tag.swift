//
//  Tag.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/7/26.
//

import Foundation

nonisolated struct Tag: Identifiable, Equatable, Codable, Hashable {
  let id: UUID
  let name: String

  init(id: UUID, name: String) {
    self.id = id
    self.name = name
  }
}
