//
//  LogDetailsHeaderView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import UIKit

class LogDetailsHeaderView: BaseView {
    struct Model {
        let pet: Pet
        let log: PoopLog
    }
    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let cardView = UIView()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 18
        imageView.layer.cornerCurve = .continuous
        imageView.backgroundColor = PoochyTheme.elevatedSurface
        return imageView
    }()

    private let statusPillView: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.elevatedSurface
        view.layer.cornerRadius = 14
        view.layer.cornerCurve = .continuous
        return view
    }()

    private let statusDotView: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.accent
        view.layer.cornerRadius = 3
        return view
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "No concerns"
        label.font = .themedFont(.pill)
        label.textColor = PoochyTheme.accent
        return label
    }()

    private let vStack = UIStackView(axis: .vertical,
                                     alignment: .leading,
                                     distribution: .fill,
                                     spacing: Spacing.space2
    )

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.heroTitle)
        label.textColor = PoochyTheme.primaryText
        return label
    }()

    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.captionEmphasized)
        label.textColor = PoochyTheme.secondaryText
        return label
    }()

    private let petNameLabel = PDIconLabel()

    override func constructView() {
        super.constructView()
        cardView.applyPoochyCardStyle(cornerRadius: 24)
    }

    override func constructSubviews() {
        super.constructSubviews()

        statusPillView.addAutolayoutSubviews([
            statusDotView,
            statusLabel
        ])

        vStack.addArrangedSubviews([
            statusPillView,
            titleLabel,
            dateTimeLabel,
            petNameLabel
        ])

        cardView.addAutolayoutSubviews([
            imageView,
            vStack
        ])

        addAutolayoutSubview(cardView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),

            imageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: Spacing.space16),
            imageView.widthAnchor.constraint(equalToConstant: 112),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            statusPillView.heightAnchor.constraint(equalToConstant: 30),
            statusPillView.widthAnchor.constraint(equalToConstant: 106),
            statusDotView.widthAnchor.constraint(equalToConstant: 6),
            statusDotView.heightAnchor.constraint(equalTo: statusDotView.widthAnchor),
            statusDotView.centerYAnchor.constraint(equalTo: statusPillView.centerYAnchor),
            statusDotView.leadingAnchor.constraint(equalTo: statusPillView.leadingAnchor, constant: Spacing.space12),
            statusLabel.centerYAnchor.constraint(equalTo: statusPillView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: statusDotView.trailingAnchor, constant: Spacing.space4),
            statusLabel.trailingAnchor.constraint(equalTo: statusPillView.trailingAnchor, constant: -Spacing.space12),

            vStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Spacing.space20),
            vStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -Spacing.space16),
            vStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Spacing.space16),
            vStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -Spacing.space16)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        imageView.image = UIImage(named: model.log.stoolType.imageName.rawValue)
        titleLabel.text = model.log.stoolType.name
        dateTimeLabel.text = model.log.date.formatted(with: "MMM dd, yyyy | hh:mm a")
        petNameLabel.model = PDIconLabel.Model(
            labelText: model.pet.name,
            systemImageName: "pawprint.fill"
        )
        petNameLabel.tintColor = PoochyTheme.accent
    }
}
