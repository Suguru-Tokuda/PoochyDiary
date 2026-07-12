//
//  NSObject+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Foundation

extension NSObject {
    var className: String {
        NSStringFromClass(type(of: self))
    }
}
