//
//  DiaryDetailsPhotosView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import UIKit

class DiaryDetailsPhotosView: BaseView {
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
    static let thumbnailSize: CGFloat = 124
  }

  // MARK: - UI Components

  private let cardView = UIView()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = Strings.DiaryEntry.photos
    label.font = .themedFont(.sectionTitle)
    label.textColor = PoochyTheme.primaryText
    return label
  }()

  private let countLabel: UILabel = {
    let label = UILabel()
    label.font = .themedFont(.captionEmphasized)
    label.textColor = PoochyTheme.secondaryText
    label.textAlignment = .right
    return label
  }()

  private let carouselView = PDImageCarouselView(
    configuration: .init(
      style: .thumbnails(
        size: Constants.thumbnailSize,
        spacing: Spacing.space16,
        sectionInset: Spacing.space16
      ))
  )

  // MARK: - Constructable

  override func constructView() {
    super.constructView()
    cardView.applyPoochyCardStyle(cornerRadius: 22)
  }

  override func constructSubviews() {
    super.constructSubviews()
    cardView.addAutolayoutSubviews([
      titleLabel,
      countLabel,
      carouselView,
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

      titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: Spacing.space20),
      titleLabel.leadingAnchor.constraint(
        equalTo: cardView.leadingAnchor, constant: Spacing.space16),

      countLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
      countLabel.leadingAnchor.constraint(
        greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Spacing.space8),
      countLabel.trailingAnchor.constraint(
        equalTo: cardView.trailingAnchor, constant: -Spacing.space16),

      carouselView.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor, constant: Spacing.space16),
      carouselView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
      carouselView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
      carouselView.bottomAnchor.constraint(
        equalTo: cardView.bottomAnchor, constant: -Spacing.space16),
      carouselView.heightAnchor.constraint(equalToConstant: Constants.thumbnailSize),
    ])
  }

  // MARK: - Model

  private func applyModel() {
    guard let model else { return }
    let photos = model.photos
    isHidden = photos.isEmpty
    countLabel.text = "\(photos.count) photo\(photos.count == 1 ? "" : "s")"
    carouselView.model = PDImageCarouselView.Model(photos: photos)
  }
}
