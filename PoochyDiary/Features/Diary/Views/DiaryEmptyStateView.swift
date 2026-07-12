//
//  DiaryEmptyStateView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class DiaryEmptyStateView: UIView {
    private let imageView: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(pointSize: 32, weight: .regular)
        let imageView = UIImageView(
            image: UIImage(systemName: "calendar.badge.plus", withConfiguration: configuration)
        )
        imageView.tintColor = PoochyTheme.accent
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No diary entries for this day"
        label.font = .themedFont(.bodyEmphasized)
        label.textColor = PoochyTheme.primaryText
        label.textAlignment = .center
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap the + button in the top-right corner to add an entry."
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var stackView = UIStackView(
        arrangedSubviews: [imageView, titleLabel, messageLabel]
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = Spacing.space8
        addAutolayoutSubview(stackView)

        let leadingConstraint = stackView.leadingAnchor.constraint(
            greaterThanOrEqualTo: leadingAnchor,
            constant: Spacing.space24
        )
        let trailingConstraint = stackView.trailingAnchor.constraint(
            lessThanOrEqualTo: trailingAnchor,
            constant: -Spacing.space24
        )
        leadingConstraint.priority = .defaultHigh
        trailingConstraint.priority = .defaultHigh

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            leadingConstraint,
            trailingConstraint,
            imageView.widthAnchor.constraint(equalToConstant: Spacing.space48),
            imageView.heightAnchor.constraint(equalToConstant: Spacing.space48)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
