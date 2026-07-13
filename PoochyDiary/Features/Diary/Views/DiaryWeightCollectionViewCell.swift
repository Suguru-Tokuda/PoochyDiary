//
//  DiaryWeightCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/13/26.
//

import UIKit

final class DiaryWeightCollectionViewCell: BaseCollectionViewCell {
    static let reuseIdentifier = "DiaryWeightCollectionViewCell"

    struct Model {
        let diary: Diary
        let weightData: WeightDiaryData
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let iconContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.accentSoft
        view.layer.cornerRadius = Spacing.space24
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "scalemass.fill"))
        imageView.tintColor = PoochyTheme.accent
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.bodyEmphasized)
        label.textColor = PoochyTheme.primaryText
        label.text = Strings.Diary.weight
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.captionEmphasized)
        label.textColor = PoochyTheme.secondaryText
        return label
    }()

    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.metric)
        label.textColor = PoochyTheme.primaryText
        label.textAlignment = .right
        return label
    }()

    private let textStackView = UIStackView(
        axis: .vertical,
        alignment: .leading,
        distribution: .fill,
        spacing: Spacing.space4
    )

    override func constructView() {
        super.constructView()
        contentView.backgroundColor = PoochyTheme.surface
        contentView.layer.cornerRadius = Spacing.space8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = PoochyTheme.outline.cgColor
    }

    override func constructSubviews() {
        super.constructSubviews()
        iconContainerView.addAutolayoutSubview(iconImageView)
        textStackView.addArrangedSubviews([titleLabel, timeLabel])
        contentView.addAutolayoutSubview(iconContainerView)
        contentView.addAutolayoutSubview(textStackView)
        contentView.addAutolayoutSubview(weightLabel)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            iconContainerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: Spacing.space16
            ),
            iconContainerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: Spacing.space48),
            iconContainerView.heightAnchor.constraint(equalTo: iconContainerView.widthAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: Spacing.space24),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),

            textStackView.leadingAnchor.constraint(
                equalTo: iconContainerView.trailingAnchor,
                constant: Spacing.space12
            ),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: weightLabel.leadingAnchor,
                constant: -Spacing.space12
            ),
            weightLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -Spacing.space16
            ),
            weightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        timeLabel.text = model.diary.date.formatted(with: "hh:mm a")
        weightLabel.text = "\(formatted(model.weightData.weight)) \(abbreviation(model.weightData.unit))"
    }

    private func formatted(_ weight: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSDecimalNumber(decimal: weight)) ?? "\(weight)"
    }

    private func abbreviation(_ unit: WeightUnit) -> String {
        switch unit {
        case .kilograms:
            return Strings.Diary.kilogramsAbbreviation
        case .pounds:
            return Strings.Diary.poundsAbbreviation
        }
    }
}
