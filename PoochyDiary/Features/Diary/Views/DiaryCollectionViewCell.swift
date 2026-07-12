//
//  DiaryCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/1/26.
//

import UIKit

class DiaryCollectionViewCell: BaseCollectionViewCell {
    var onCellTap: (() -> Void)?

    struct Model {
        let diary: Diary
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    class var reuseIdentifier: String {
        "DiaryCollectionViewCell"
    }

    private let outerStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )
    private let verticalStackView = UIStackView(
        axis: .vertical, alignment: .fill, distribution: .fill, spacing: Spacing.space4)
    private let imageCarouselView: PDImageCarouselView = {
        let imageCarouselView = PDImageCarouselView()
        imageCarouselView.layer.cornerRadius = 8
        imageCarouselView.clipsToBounds = true
        return imageCarouselView
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .themedFont(.captionEmphasized)
        return label
    }()
    private let stoolStatusView = StoolStatusView()
    private let spacer = UIView()

    private let chevron: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        return imageView
    }()

    override func constructSubviews() {
        super.constructSubviews()

        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = PoochyTheme.outline.cgColor

        verticalStackView.addArrangedSubviews([
            timeLabel,
            stoolStatusView
        ])

        outerStackView.addArrangedSubviews([
            imageCarouselView,
            verticalStackView,
            spacer,
            chevron
        ])

        contentView.addAutolayoutSubview(outerStackView)
        contentView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleCellTap)))
        imageCarouselView.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(handleCellTap)))
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        let carouselHeight = imageCarouselView.heightAnchor.constraint(equalToConstant: 80)
        carouselHeight.priority = .defaultHigh
        let carouselWidth = imageCarouselView.widthAnchor.constraint(
            equalTo: imageCarouselView.heightAnchor)
        carouselWidth.priority = .defaultHigh

        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Spacing.space8),
            outerStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Spacing.space8),
            outerStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Spacing.space8),
            outerStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Spacing.space8),
            carouselHeight,
            carouselWidth
        ])
    }

    private func applyModel() {
        guard let model else { return }
        let diary = model.diary

        timeLabel.text = diary.date.formatted(with: "hh:mm a")

        imageCarouselView.model = PDImageCarouselView.Model(
            photos: model.diary.photos
        )

        stoolStatusView.model = StoolStatusView.Model(
            stoolType: diary.stoolType,
            mucusLevel: diary.mucusLevel,
            bloodAmount: diary.bloodAmount
        )
    }

    @objc private func handleCellTap() {
        onCellTap?()
    }
}
