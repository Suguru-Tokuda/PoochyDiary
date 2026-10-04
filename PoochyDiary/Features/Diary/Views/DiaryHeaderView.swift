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
    var onPetSelectorTap: (() -> Void)? {
        get { headerView.onPetSelectorTap }
        set { headerView.onPetSelectorTap = newValue }
    }
    var onCalendarButtonTap: (() -> Void)?
    var onTrackingOptionSelect: ((DiaryTrackingOption) -> Void)?

    var petName: String? {
        get { headerView.petName }
        set { headerView.petName = newValue }
    }

    private let headerView = HeaderView(title: Strings.Diary.title)

    private let calendarButton: CircleButton = {
        let button = CircleButton(image: UIImage(systemName: "calendar"))
        button.accessibilityLabel = Strings.Diary.selectDateAccessibilityLabel
        return button
    }()

    private lazy var addButton: CircleButton = {
        let button = CircleButton(image: UIImage(systemName: "plus"))
        button.accessibilityLabel = Strings.Diary.addEntryAccessibilityLabel
        button.menu = makeTrackingMenu()
        button.showsMenuAsPrimaryAction = true
        return button
    }()

    override func constructSubviews() {
        super.constructSubviews()

        headerView.trailingButtons = [calendarButton, addButton]
        addAutolayoutSubview(headerView)

        calendarButton.addTarget(
            self,
            action: #selector(handleCalendarButtonTap),
            for: .touchUpInside
        )
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
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
