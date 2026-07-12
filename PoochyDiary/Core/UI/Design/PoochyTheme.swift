//
//  PoochyTheme.swift
//  PoochyDiary
//
//  Created by Codex on 7/10/26.
//

import UIKit

enum PoochyTheme {
  static let background = UIColor { traitCollection in
    traitCollection.userInterfaceStyle == .dark
      ? UIColor(hex: 0x141815)
      : UIColor(hex: 0xF7F4EF)
  }

  static let surface = UIColor { traitCollection in
    traitCollection.userInterfaceStyle == .dark
      ? UIColor(hex: 0x1D231F)
      : UIColor(hex: 0xFFFFFF)
  }

  static let elevatedSurface = UIColor { traitCollection in
    traitCollection.userInterfaceStyle == .dark
      ? UIColor(hex: 0x263027)
      : UIColor(hex: 0xEEF4EF)
  }

  static let primaryText = UIColor { traitCollection in
    traitCollection.userInterfaceStyle == .dark
      ? UIColor(hex: 0xF4F2EC)
      : UIColor(hex: 0x202822)
  }

  static let secondaryText = UIColor { traitCollection in
    traitCollection.userInterfaceStyle == .dark
      ? UIColor(hex: 0xB4BCB1)
      : UIColor(hex: 0x687369)
  }

  static let accent = UIColor.accent
  static let accentSoft = UIColor.accent.withAlphaComponent(0.14)
  static let attention = UIColor(hex: 0xB7782D)
  static let danger = UIColor(hex: 0xB95B56)
  static let outline = UIColor.separator.withAlphaComponent(0.35)
  static let shadow = UIColor.black.withAlphaComponent(0.08)
}

extension UIView {
  func applyPoochyCardStyle(cornerRadius: CGFloat = 18) {
    backgroundColor = PoochyTheme.surface
    layer.cornerRadius = cornerRadius
    layer.cornerCurve = .continuous
    layer.borderWidth = 1
    layer.borderColor = PoochyTheme.outline.cgColor
    layer.shadowColor = PoochyTheme.shadow.cgColor
    layer.shadowOpacity = 1
    layer.shadowRadius = 18
    layer.shadowOffset = CGSize(width: 0, height: 8)
  }
}

extension UIColor {
  fileprivate convenience init(hex: Int, alpha: CGFloat = 1) {
    self.init(
      red: CGFloat((hex >> 16) & 0xFF) / 255,
      green: CGFloat((hex >> 8) & 0xFF) / 255,
      blue: CGFloat(hex & 0xFF) / 255,
      alpha: alpha
    )
  }
}
