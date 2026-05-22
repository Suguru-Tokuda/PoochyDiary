//
//  Photo.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/21/26.
//

import UIKit

nonisolated struct Photo: Identifiable, Equatable, Hashable {
    let id: UUID
    let fileName: String
    var image: UIImage?
    let createdAt: Date
    let sortOrder: Int

    init(id: UUID,
         fileName: String,
         image: UIImage? = nil,
         createdAt: Date,
         sortOrder: Int
    ) {
        self.id = id
        self.fileName = fileName
        self.image = image
        self.createdAt = createdAt
        self.sortOrder = sortOrder
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
