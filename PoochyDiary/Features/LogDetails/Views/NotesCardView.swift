//
//  NotesCardView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/10/26.
//

import UIKit

final class NotesCardView: BaseView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = PoochyTheme.secondaryText
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = PoochyTheme.primaryText
        label.numberOfLines = 0
        return label
    }()

    override func constructView() {
        super.constructView()
        applyPoochyCardStyle(cornerRadius: 20)
    }

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([
            titleLabel,
            bodyLabel
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space12),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space20)
        ])
    }

    func configure(title: String, body: String) {
        titleLabel.text = title
        bodyLabel.text = body
    }
}
