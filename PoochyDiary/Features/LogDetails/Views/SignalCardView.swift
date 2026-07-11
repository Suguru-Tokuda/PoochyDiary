//
//  SignalCardView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/10/26.
//

import UIKit

final class SignalCardView: BaseView {
    private let iconContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 14
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.pill)
        label.textColor = PoochyTheme.secondaryText
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.85
        return label
    }()

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.bodyEmphasized)
        label.textColor = PoochyTheme.primaryText
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.82
        return label
    }()

    override func constructView() {
        super.constructView()
        applyPoochyCardStyle(cornerRadius: 20)
    }

    override func constructSubviews() {
        super.constructSubviews()
        iconContainerView.addAutolayoutSubview(iconView)
        addAutolayoutSubviews([
            iconContainerView,
            titleLabel,
            valueLabel
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            iconContainerView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space12),
            iconContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space12),
            iconContainerView.widthAnchor.constraint(equalToConstant: 34),
            iconContainerView.heightAnchor.constraint(equalTo: iconContainerView.widthAnchor),

            iconView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space12),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space12),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: iconContainerView.bottomAnchor, constant: Spacing.space16),

            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space4),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space12)
        ])
    }

    func configure(
        title: String,
        value: String,
        systemImageName: String,
        iconTintColor: UIColor,
        iconBackgroundColor: UIColor
    ) {
        titleLabel.text = title
        valueLabel.text = value
        iconView.image = UIImage(systemName: systemImageName)
        iconView.tintColor = iconTintColor
        iconContainerView.backgroundColor = iconBackgroundColor
    }
}
