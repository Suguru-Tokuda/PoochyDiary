//
//  BloodAmountView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/10/26.
//

import UIKit

class BloodAmountView: BaseView {
    
    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Blood Amount", isOptional: false)
        return label
    }()
    
    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            label
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
