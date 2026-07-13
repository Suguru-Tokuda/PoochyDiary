//
//  PetSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class PetSelectionView: BaseView {
    var onCloseButtonTap: (() -> Void)?
    var onAddPetButtonTap: (() -> Void)?
    var onPetSelect: ((Pet) -> Void)? {
        didSet {
            collectionView.onPetSelect = onPetSelect
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.sectionTitle)
        label.textColor = PoochyTheme.primaryText
        label.text = Strings.PetSelection.title
        label.accessibilityTraits = .header
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.body)
        label.textColor = PoochyTheme.secondaryText
        label.text = Strings.PetSelection.subtitle
        label.numberOfLines = 0
        return label
    }()

    private let closeButton = CircleButton(image: UIImage(systemName: "xmark"))
    private let collectionView = PetSelectionCollectionView()

    private let addPetButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "plus.circle")
        configuration.imagePadding = Spacing.space8
        configuration.title = Strings.PetSelection.addPet
        configuration.baseForegroundColor = PoochyTheme.accent
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Spacing.space12,
            leading: Spacing.space16,
            bottom: Spacing.space12,
            trailing: Spacing.space16
        )

        let button = UIButton(configuration: configuration)
        button.contentHorizontalAlignment = .leading
        button.layer.borderColor = PoochyTheme.outline.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = Spacing.space16
        return button
    }()

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubview(titleLabel)
        addAutolayoutSubview(subtitleLabel)
        addAutolayoutSubview(closeButton)
        addAutolayoutSubview(collectionView)
        addAutolayoutSubview(addPetButton)

        closeButton.accessibilityLabel = Strings.PetSelection.closeAccessibilityLabel
        closeButton.addTarget(
            self,
            action: #selector(handleCloseButtonTap),
            for: .touchUpInside
        )
        addPetButton.addTarget(
            self,
            action: #selector(handleAddPetButtonTap),
            for: .touchUpInside
        )
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: closeButton.leadingAnchor,
                constant: -Spacing.space16
            ),
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            closeButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Spacing.space16
            ),
            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Spacing.space8
            ),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Spacing.space16
            ),
            collectionView.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: Spacing.space24
            ),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            collectionView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -Spacing.space16
            ),
            addPetButton.topAnchor.constraint(
                equalTo: collectionView.bottomAnchor,
                constant: Spacing.space12
            ),
            addPetButton.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            addPetButton.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            addPetButton.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -Spacing.space16
            )
        ])
    }

    func configure(pets: [Pet], selectedPet: Pet?) {
        collectionView.configure(pets: pets, selectedPet: selectedPet)
    }

    @objc private func handleCloseButtonTap() {
        onCloseButtonTap?()
    }

    @objc private func handleAddPetButtonTap() {
        onAddPetButtonTap?()
    }
}
