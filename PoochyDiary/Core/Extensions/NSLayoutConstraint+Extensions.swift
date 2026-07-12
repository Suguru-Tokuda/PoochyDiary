//
//  NSLayoutConstraint+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

extension NSLayoutConstraint {
  func activate() {
    self.isActive = true
  }

  func deactivate() {
    self.isActive = false
  }
}
