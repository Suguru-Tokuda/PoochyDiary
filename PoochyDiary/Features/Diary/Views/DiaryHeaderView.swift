//
//  DiaryHeaderView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

nonisolated enum DiaryTrackingOption {
    case poop
    case weight
}

final class DiaryHeaderView: BaseView {
    var onPetSelectorTap: (() -> Void)?
    var onCalendarButtonTap: (() -> Void)?
    var onTrackingOptionSelect: ((DiaryTrackingOption) -> Void)?

    var petName: String? {
        didSet {
            updateTitle()
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.sectionTitle)
        label.textColor = PoochyTheme.primaryText
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byTruncatingTail
        label.accessibilityTraits = .header
        label.text = Strings.Diary.title
        return label
    }()

    private let petSelectorView = PetSelectorView()
    private let calendarButton = CircleButton(image: UIImage(systemName: "calendar"))
    private let addButton = CircleButton(image: UIImage(systemName: "plus"))

    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )

    override func constructSubviews() {
        super.constructSubviews()

        buttonStackView.addArrangedSubviews([
            calendarButton,
            addButton
        ])
        addAutolayoutSubview(titleLabel)
        addAutolayoutSubview(buttonStackView)
        addAutolayoutSubview(petSelectorView)

        petSelectorView.onTap = { [weak self] in
            self?.onPetSelectorTap?()
        }

        calendarButton.accessibilityLabel = Strings.Diary.selectDateAccessibilityLabel
        addButton.accessibilityLabel = Strings.Diary.addEntryAccessibilityLabel
        addButton.menu = makeTrackingMenu()
        addButton.showsMenuAsPrimaryAction = true

        calendarButton.addTarget(
            self,
            action: #selector(handleCalendarButtonTap),
            for: .touchUpInside
        )
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        petSelectorView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
            petSelectorView.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: Spacing.space8
            ),
            petSelectorView.centerYAnchor.constraint(equalTo: buttonStackView.centerYAnchor),
            petSelectorView.widthAnchor.constraint(greaterThanOrEqualToConstant: 96),
            petSelectorView.trailingAnchor.constraint(
                lessThanOrEqualTo: buttonStackView.leadingAnchor,
                constant: -Spacing.space8
            ),
            buttonStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func updateTitle() {
        guard let petName, !petName.isEmpty else {
            petSelectorView.isHidden = true
            return
        }
        petSelectorView.isHidden = false
        petSelectorView.model = PetSelectorView.Model(name: petName, image: nil)
    }

    private func makeTrackingMenu() -> UIMenu {
        let poopAction = UIAction(
            title: Strings.Diary.trackPoop,
            image: UIImage(systemName: "toilet.fill")
        ) { [weak self] _ in
            self?.onTrackingOptionSelect?(.poop)
        }
        let weightAction = UIAction(
            title: Strings.Diary.trackWeight,
            image: UIImage(systemName: "scalemass.fill")
        ) { [weak self] _ in
            self?.onTrackingOptionSelect?(.weight)
        }
        return UIMenu(children: [poopAction, weightAction])
    }

    @objc private func handleCalendarButtonTap() {
        onCalendarButtonTap?()
    }
}
