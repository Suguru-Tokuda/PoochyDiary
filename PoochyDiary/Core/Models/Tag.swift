//
//  Tag.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/7/26.
//

import Foundation

struct Tag: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String

    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }

    init?(_ entity: TagEntity) {
        guard let id = entity.id,
              let name = entity.name else { return nil }

        self.id = id
        self.name = name
    }
}
