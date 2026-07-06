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

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .systemGray6
        return imageView
    }()

    private let vStack = UIStackView(axis: .vertical,
                                     alignment: .leading,
                                     distribution: .fill,
                                     spacing: Spacing.space2
    )

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()

    private let dateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()

    private let petNameLabel = PDIconLabel()

    override func constructSubviews() {
        super.constructSubviews()

        vStack.addArrangedSubviews([
            titleLabel,
            dateTimeLabel,
            petNameLabel
        ])

        addAutolayoutSubviews([
            imageView,
            vStack
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()

        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            imageView.widthAnchor.constraint(equalToConstant: Spacing.space48 * 2),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),

            vStack.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space16),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space16),
            vStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Spacing.space16),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16)
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
    }
}
