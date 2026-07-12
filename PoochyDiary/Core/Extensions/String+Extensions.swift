//
//  String+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/12/26.
//

import Foundation

extension String {
    func firstLetterUppercased() -> Self {
        guard !self.isEmpty else {
            return self
        }

        return self.prefix(1).uppercased() + self.dropFirst().lowercased()
    }
}
