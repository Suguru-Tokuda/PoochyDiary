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
        spacing: 2
    )

    let titleLabel: UILabel = {
       let label = UILabel()
       label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .semibold)
       return label
    }()

    let optionalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.text = "(optional)"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
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
