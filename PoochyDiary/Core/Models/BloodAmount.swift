//
//  BloodAmount.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/1/26.
//

import Foundation

enum BloodAmount: String, CaseIterable, Codable {
    case none
    case trace
    case small
    case moderate
    case large
}
