//
//  LogPoopSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/12/26.
//

import UIKit

class LogPoopSelectionView: BaseView {
    struct Model {
        let title: String
        let isOptional: Bool
        let selectionItems: [PDSelectionItem]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }
    // MARK: - UI Components

    private let label = PDLabel()
    private let selectionView = PDSelectionCollectionView()

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            label,
            selectionView
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            selectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            selectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            selectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        label.model = PDLabel.Model(title: model.title, isOptional: model.isOptional)
        selectionView.model = PDSelectionCollectionView.Model(items: model.selectionItems)
    }
}
