//
//  SelectedTagCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

class SelectedTagCollectionViewCell: BaseCollectionViewCell {
    var onRemoveButtonTap: (() -> Void)?

    struct Model {
        let tag: Tag
        let shouldShowRemoveButton: Bool

        init(tag: Tag, shouldShowRemoveButton: Bool = true) {
            self.tag = tag
            self.shouldShowRemoveButton = shouldShowRemoveButton
        }
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    class var reuseIdentifier: String {
        "SelectedTagCollectionViewCell"
    }

    private let stackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fill,
        spacing: 8
    )

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .accent
        return label
    }()

    private let removeButton: UIButton = {
        let removeButton = UIButton()
        let image = UIImage(
            systemName: "multiply",
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
            label,
            removeButton
        ])
        contentView.addAutolayoutSubview(stackView)

        removeButton.addTarget(
            self,
            action: #selector(handleRemoveButtonTap),
            for: .touchUpInside
        )
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        label.text = model.tag.name
        removeButton.isHidden = !model.shouldShowRemoveButton
    }

    override func prepareForReuse() {
        label.text = nil
    }
}

extension SelectedTagCollectionViewCell {
    @objc private func handleRemoveButtonTap() {
        onRemoveButtonTap?()
    }
}
