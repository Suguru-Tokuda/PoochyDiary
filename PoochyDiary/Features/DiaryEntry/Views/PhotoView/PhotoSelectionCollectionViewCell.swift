//
//  PhotoSelectionCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/11/26.
//

import UIKit

class PhotoSelectionCollectionViewCell: BaseCollectionViewCell {
  class var reuseIdentifier: String {
    "PhotoSelectionCollectionViewCell"
  }

  struct Model {
    let image: UIImage
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  var onRemoveButtonTap: (() -> Void)?

  // MARK: - UI Components

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8

    return imageView
  }()

  private let removeButton: UIButton = {
    let button = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 11, weight: .semibold)
    button.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
    button.tintColor = .white
    button.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    button.layer.cornerRadius = 11
    return button
  }()

  override func constructSubviews() {
    super.constructSubviews()
    contentView.addAutolayoutSubviews([
      imageView,
      removeButton,
    ])

    removeButton.addTarget(self, action: #selector(handleRemoveButtonTap), for: .touchUpInside)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      removeButton.topAnchor.constraint(equalTo: topAnchor, constant: 6),
      removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
      removeButton.widthAnchor.constraint(equalToConstant: 22),
      removeButton.heightAnchor.constraint(equalTo: removeButton.widthAnchor),
    ])
  }

  private func applyModel() {
    guard let model else { return }

    imageView.image = model.image
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
}

extension PhotoSelectionCollectionViewCell {
  @objc private func handleRemoveButtonTap() {
    onRemoveButtonTap?()
  }
}
