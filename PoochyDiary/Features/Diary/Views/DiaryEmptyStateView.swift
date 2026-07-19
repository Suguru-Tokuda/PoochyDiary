//
//  DiaryEmptyStateView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class DiaryEmptyStateView: BaseView {
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
        label.text = Strings.Diary.emptyTitle
        label.font = .themedFont(.bodyEmphasized)
        label.textColor = PoochyTheme.primaryText
        label.textAlignment = .center
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.Diary.emptyMessage
        label.font = .themedFont(.caption)
        label.textColor = PoochyTheme.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let stackView = UIStackView(axis: .vertical, alignment: .center, spacing: Spacing.space8)

    override func constructSubviews() {
        super.constructSubviews()
        stackView.addArrangedSubviews([
            imageView,
            titleLabel,
            messageLabel
        ])
        addAutolayoutSubview(stackView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
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
}
