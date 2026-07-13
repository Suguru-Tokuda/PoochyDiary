//
//  PetSelectionCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class PetSelectionCollectionViewCell: BaseCollectionViewCell {
    static let reuseIdentifier = "PetSelectionCollectionViewCell"

    private enum Constants {
        static let avatarSize: CGFloat = 56
        static let avatarImageSize: CGFloat = 28
    }

    struct Model {
        let pet: Pet
        let isSelected: Bool
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let avatarContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.accent.withAlphaComponent(0.18)
        view.layer.cornerRadius = Constants.avatarSize / 2
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "pawprint.fill"))
        imageView.tintColor = PoochyTheme.accent
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.cardTitle)
        label.textColor = PoochyTheme.primaryText
        return label
    }()

    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.body)
        label.textColor = PoochyTheme.secondaryText
        return label
    }()

    private let checkmarkContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.accent
        view.layer.cornerRadius = Spacing.space20
        return view
    }()

    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "checkmark"))
        imageView.tintColor = PoochyTheme.background
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let unselectedIndicatorView: UIView = {
        let view = UIView()
        view.layer.borderColor = PoochyTheme.secondaryText.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = Spacing.space20
        return view
    }()

    private let textStackView = UIStackView(
        axis: .vertical,
        alignment: .leading,
        distribution: .fill,
        spacing: Spacing.space4
    )

    override func constructView() {
        super.constructView()
        contentView.backgroundColor = PoochyTheme.surface
        contentView.layer.borderColor = PoochyTheme.outline.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = Spacing.space16
        contentView.clipsToBounds = true
    }

    override func constructSubviews() {
        super.constructSubviews()
        avatarContainerView.addAutolayoutSubview(avatarImageView)
        checkmarkContainerView.addAutolayoutSubview(checkmarkImageView)
        textStackView.addArrangedSubviews([nameLabel, typeLabel])

        contentView.addAutolayoutSubview(avatarContainerView)
        contentView.addAutolayoutSubview(textStackView)
        contentView.addAutolayoutSubview(checkmarkContainerView)
        contentView.addAutolayoutSubview(unselectedIndicatorView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            avatarContainerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Spacing.space16
            ),
            avatarContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarContainerView.widthAnchor.constraint(equalToConstant: Constants.avatarSize),
            avatarContainerView.heightAnchor.constraint(equalTo: avatarContainerView.widthAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: avatarContainerView.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: avatarContainerView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: Constants.avatarImageSize),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor),

            textStackView.leadingAnchor.constraint(
                equalTo: avatarContainerView.trailingAnchor,
                constant: Spacing.space16
            ),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: checkmarkContainerView.leadingAnchor,
                constant: -Spacing.space16
            ),

            checkmarkContainerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Spacing.space16
            ),
            checkmarkContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkContainerView.widthAnchor.constraint(equalToConstant: Spacing.space40),
            checkmarkContainerView.heightAnchor.constraint(equalTo: checkmarkContainerView.widthAnchor),
            checkmarkImageView.centerXAnchor.constraint(equalTo: checkmarkContainerView.centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: checkmarkContainerView.centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Spacing.space20),
            checkmarkImageView.heightAnchor.constraint(equalTo: checkmarkImageView.widthAnchor),

            unselectedIndicatorView.centerXAnchor.constraint(equalTo: checkmarkContainerView.centerXAnchor),
            unselectedIndicatorView.centerYAnchor.constraint(equalTo: checkmarkContainerView.centerYAnchor),
            unselectedIndicatorView.widthAnchor.constraint(equalTo: checkmarkContainerView.widthAnchor),
            unselectedIndicatorView.heightAnchor.constraint(equalTo: checkmarkContainerView.heightAnchor)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }

    private func applyModel() {
        guard let model else { return }

        nameLabel.text = model.pet.name
        typeLabel.text = Strings.PetSelection.animalType(model.pet.type)
        checkmarkContainerView.isHidden = !model.isSelected
        unselectedIndicatorView.isHidden = model.isSelected
        contentView.backgroundColor = model.isSelected
            ? PoochyTheme.accent.withAlphaComponent(0.12)
            : PoochyTheme.surface
        contentView.layer.borderColor = model.isSelected
            ? PoochyTheme.accent.withAlphaComponent(0.45).cgColor
            : PoochyTheme.outline.cgColor
        accessibilityLabel = "\(model.pet.name), \(Strings.PetSelection.animalType(model.pet.type))"
        accessibilityTraits = model.isSelected ? [.button, .selected] : .button
    }
}
