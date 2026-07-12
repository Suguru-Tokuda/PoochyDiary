//
//  CircleButton.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/11/26.
//

import UIKit

final class CircleButton: UIButton {
  init(image: UIImage?) {
    super.init(frame: .zero)
    setImage(image, for: .normal)
    tintColor = PoochyTheme.primaryText
    backgroundColor = PoochyTheme.surface
    layer.borderColor = PoochyTheme.outline.cgColor
    layer.borderWidth = 1
    clipsToBounds = true
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override var intrinsicContentSize: CGSize {
    CGSize(width: Spacing.space48, height: Spacing.space48)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = min(bounds.width, bounds.height) / 2
  }
}
