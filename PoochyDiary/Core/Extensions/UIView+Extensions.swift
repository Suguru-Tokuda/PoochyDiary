//
//  UIView+Extensions.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

extension UIView {
    func addAutolayoutSubview(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

    func addAutolayoutSubviews(_ views: [UIView]) {
        views.forEach { addAutolayoutSubview($0) }
    }
}
