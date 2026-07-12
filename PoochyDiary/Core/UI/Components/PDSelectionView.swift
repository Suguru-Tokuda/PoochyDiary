//
//  PDSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

final class PDSelectionView: BaseView {
  struct Model {
    let text: String
    let image: UIImage?
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  // MARK: - UI Components

  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    return stackView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .themedFont(.caption)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.tintColor = .label
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  override func constructView() {
    super.constructView()
    layer.cornerRadius = 8
    layer.borderColor = PoochyTheme.outline.cgColor
    layer.borderWidth = 1
    backgroundColor = PoochyTheme.surface
  }

  override func constructSubviews() {
    super.constructSubviews()
    stackView.addArrangedSubviews([
      titleLabel,
      imageView
    ])
    titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    imageView.setContentHuggingPriority(.required, for: .horizontal)
    addAutolayoutSubview(stackView)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalToConstant: Spacing.space48),

      stackView.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.space8),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space8),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.space16),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.space16),

      imageView.widthAnchor.constraint(equalToConstant: Spacing.space24),
      imageView.heightAnchor.constraint(equalToConstant: Spacing.space24)
    ])
  }

  private func applyModel() {
    guard let model else { return }

    titleLabel.text = model.text
    imageView.image = model.image
  }
}
