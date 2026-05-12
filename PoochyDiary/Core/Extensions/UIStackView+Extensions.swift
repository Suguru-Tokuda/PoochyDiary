//
//  UIStackView+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

extension UIStackView {
    convenience init(
        _ frame: CGRect = .zero,
        axis: NSLayoutConstraint.Axis,
        alignment: Alignment = .fill,
        distribution: Distribution = .equalCentering,
        spacing: CGFloat = 0
    ) {
        self.init(frame: frame)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }

    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
