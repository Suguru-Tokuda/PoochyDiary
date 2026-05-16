//
//  DateTimeView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/10/26.
//

import UIKit

class DateTimeView: BaseView {
    var onDateSelectionLabelTapped: (() -> Void)?
    private let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill)
    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Date & Time", isOptional: false)
        return label
    }()

    private let dateSelectionLabel: PDSelectionView = {
        let selectionLabel = PDSelectionView()
        selectionLabel.model = PDSelectionView.Model(text: "May 16, 2026", image: UIImage(systemName: "calendar.badge.clock"))
        return selectionLabel
    }()



    override func constructSubviews() {
        super.constructSubviews()
        stackView.addArrangedSubviews([
            label,
            dateSelectionLabel
        ])
        addAutolayoutSubview(stackView)
        dateSelectionLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDateSelectionLabelTap)))
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

extension DateTimeView {
    @objc private func handleDateSelectionLabelTap() {
        onDateSelectionLabelTapped?()
    }
}
