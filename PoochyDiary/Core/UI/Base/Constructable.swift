//
//  Constructable.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/12/26.
//

import Foundation

protocol Constructable {
    func constructView()
    func constructSubviews()
    func constructSubviewLayoutConstraints()
}
