//
//  PetSelectorView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class PetSelectorView: BaseView {
    struct Model {
        let name: String
        let image: UIImage?
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    var onTap: (() -> Void)?

    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = PoochyTheme.primaryText
        button.backgroundColor = PoochyTheme.surface
        button.layer.borderColor = PoochyTheme.outline.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = Spacing.space20
        button.clipsToBounds = true
        return button
    }()

    private let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = PoochyTheme.accent
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.bodyEmphasized)
        label.textColor = PoochyTheme.primaryText
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down"))
        imageView.tintColor = PoochyTheme.secondaryText
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let contentStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )

    override var intrinsicContentSize: CGSize {
        let contentSize = contentStackView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize
        )
        return CGSize(
            width: contentSize.width + (Spacing.space12 * 2),
            height: max(Spacing.space40, contentSize.height + (Spacing.space8 * 2))
        )
    }

    override func constructView() {
        super.constructView()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubview(button)
        contentStackView.addArrangedSubviews([
            petImageView,
            nameLabel,
            chevronImageView
        ])
        button.addAutolayoutSubview(contentStackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(greaterThanOrEqualToConstant: Spacing.space40),
            contentStackView.topAnchor.constraint(
                equalTo: button.topAnchor,
                constant: Spacing.space8
            ),
            contentStackView.bottomAnchor.constraint(
                equalTo: button.bottomAnchor,
                constant: -Spacing.space8
            ),
            contentStackView.leadingAnchor.constraint(
                equalTo: button.leadingAnchor,
                constant: Spacing.space12
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: button.trailingAnchor,
                constant: -Spacing.space12
            ),
            petImageView.widthAnchor.constraint(equalToConstant: Spacing.space24),
            petImageView.heightAnchor.constraint(equalTo: petImageView.widthAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: Spacing.space12)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        petImageView.image = model.image ?? UIImage(systemName: "pawprint.fill")
        nameLabel.text = model.name
        invalidateIntrinsicContentSize()
        button.accessibilityLabel = Strings.PetSelector.accessibilityLabel(petName: model.name)
        button.accessibilityHint = Strings.PetSelector.accessibilityHint
    }

    @objc private func handleTap() {
        onTap?()
    }
}
