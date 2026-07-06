//
//  LogDetailsPhotosView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import UIKit

class LogDetailsPhotosView: BaseView {
    struct Model {
        let photos: [Photo]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    var onPhotoSelect: ((Int, UIView) -> Void)? {
        didSet {
            carouselView.onPhotoSelect = onPhotoSelect
        }
    }

    private enum Constants {
        static let thumbnailSize: CGFloat = 96
    }

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Strings.LogPoop.photos
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let carouselView = PDImageCarouselView(configuration: .thumbnails)

    // MARK: - Constructable

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubviews([titleLabel, carouselView])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),

            carouselView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.space8),
            carouselView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselView.bottomAnchor.constraint(equalTo: bottomAnchor),
            carouselView.heightAnchor.constraint(equalToConstant: Constants.thumbnailSize)
        ])
    }

    // MARK: - Model

    private func applyModel() {
        guard let model else { return }
        let photos = model.photos
        isHidden = photos.isEmpty
        carouselView.model = PDImageCarouselView.Model(photos: photos)
    }
}
