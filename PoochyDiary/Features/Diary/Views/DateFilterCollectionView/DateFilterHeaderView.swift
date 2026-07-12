//
//  DateFilterHeaderView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/11/26.
//

import UIKit

class DateFilterHeaderView: BaseView {
    var onWeekChange: ((Int) -> Void)?
    struct Model {
        let date: Date
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let hStack = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )

    private let leftArrowButton = CircleButton(image: UIImage(systemName: "chevron.left"))
    private let rightArrowButton = CircleButton(image: UIImage(systemName: "chevron.right"))

    private let vStack = UIStackView(
        axis: .vertical,
        alignment: .leading,
        distribution: .fill
    )
    private let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.accent
        return label
    }()
    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.cardTitle)
        label.textColor = PoochyTheme.primaryText
        return label
    }()

    override func constructSubviews() {
        super.constructSubviews()

        vStack.addArrangedSubviews([
            selectedDateLabel,
            dateTitleLabel
        ])
        hStack.addArrangedSubviews([
            leftArrowButton,
            vStack,
            UIView(),
            rightArrowButton
        ])
        addAutolayoutSubview(hStack)
        leftArrowButton.addTarget(self, action: #selector(handleLeftButtonTap), for: .touchUpInside)
        rightArrowButton.addTarget(
            self, action: #selector(handleRightButtonTap), for: .touchUpInside)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space16),

            leftArrowButton.widthAnchor.constraint(equalToConstant: Spacing.space48),
            leftArrowButton.heightAnchor.constraint(equalToConstant: Spacing.space48),

            rightArrowButton.widthAnchor.constraint(equalToConstant: Spacing.space48),
            rightArrowButton.heightAnchor.constraint(equalToConstant: Spacing.space48)
        ])
    }

    private func applyModel() {
        guard let model else { return }
        dateTitleLabel.text = model.date.formatted(with: "MMM d yyyy")
    }

    @objc private func handleLeftButtonTap() {
        onWeekChange?(-1)
    }

    @objc private func handleRightButtonTap() {
        onWeekChange?(1)
    }
}
