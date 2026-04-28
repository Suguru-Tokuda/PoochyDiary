//
//  Collection+Extensions.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
