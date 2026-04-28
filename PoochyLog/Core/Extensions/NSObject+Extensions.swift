//
//  NSObject+Extensions.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Foundation

extension NSObject {
    var className: String {
        get {
            NSStringFromClass(type(of: self))
        }
    }
}
