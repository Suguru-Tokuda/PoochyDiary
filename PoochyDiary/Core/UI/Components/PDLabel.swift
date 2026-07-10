//
//  PDLabel.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDLabel: BaseView {

    struct Model {
        let title: String
        let isOptional: Bool
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    // MARK: - UI Components

    let stackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space2
    )

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = PoochyTheme.primaryText
       return label
    }()

    let optionalLabel: UILabel = {
        let label = UILabel()
        label.textColor = PoochyTheme.secondaryText
        label.text = "(optional)"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.isHidden = true
        return label
    }()

    override func constructSubviews() {
        super.constructSubviews()
        stackView.addArrangedSubviews([
            titleLabel,
            optionalLabel
        ])

        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        titleLabel.text = model.title
        optionalLabel.isHidden = !model.isOptional
    }
}
