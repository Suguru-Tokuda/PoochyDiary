//
//  TagOptionsCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

class TagOptionsCollectionViewCell: BaseCollectionViewCell {
    var onAddButtonTap: (() -> Void)?

    struct Model {
        let tag: Tag
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    class var reuseIdentifier: String {
        "TagOptionsCollectionViewCell"
    }

    private let stackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let label: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = .accent
        return label
    }()

    private let addButton: UIButton = {
        let removeButton = UIButton()
        let image = UIImage(
            systemName: "plus",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 12,
                weight: .bold
            )
        )
        removeButton.setImage(image, for: .normal)
        removeButton.tintColor = .accent
        return removeButton
    }()

    override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        let size = contentView.systemLayoutSizeFitting(
            UIView.layoutFittingExpandedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .required
        )

        attributes.size = CGSize(
            width: ceil(size.width),
            height: 36
        )
        return attributes
    }

    override func constructView() {
        super.constructView()
        layer.cornerRadius = 18
        backgroundColor = .accent.withAlphaComponent(0.18)
    }

    override func constructSubviews() {
        super.constructSubviews()
        stackView.addArrangedSubviews([
            addButton,
            label
        ])
        contentView.addAutolayoutSubview(stackView)

        addButton.addTarget(
            self,
            action: #selector(handleAddButtonTap),
            for: .touchUpInside
        )
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            stackView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Spacing.space4),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Spacing.space4)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        label.text = model.tag.name
    }
}

extension TagOptionsCollectionViewCell {
    @objc private func handleAddButtonTap() {
        onAddButtonTap?()
    }
}
