//
//  PDSelectionCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

struct PDSelectionCellStyle {
  let selectedColor: UIColor
}

nonisolated struct PDSelectionItem: Hashable {
  let id: String
  let title: String
  let imageName: String
}

enum CellPosition {
  case first, last, middle, only
}

class PDSelectionCollectionViewCell: BaseCollectionViewCell {

  static var reuseIdentifier: String {
    "PDSelectionCollectionViewCell"
  }

  private enum Constants {
    static let borderRadius: CGFloat = 8
    static let padding: CGFloat = 2
    static let borderWidth: CGFloat = 1
    static let selectedBorderWidth: CGFloat = 2
  }

  override var isSelected: Bool {
    didSet {
      updateSelectionStyle()
    }
  }

  private var selectedColor: UIColor?

  // MARK: - UI Elements

  private let stackView = UIStackView(
    axis: .vertical, alignment: .center, distribution: .fill, spacing: 0)
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let label: UILabel = {
    let label = UILabel()
    label.font = .themedFont(.pill)
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()

  override func constructView() {
    super.constructView()
    contentView.layer.cornerRadius = Constants.borderRadius
    contentView.layer.borderColor = PoochyTheme.outline.cgColor
    contentView.layer.borderWidth = Constants.borderWidth
    contentView.backgroundColor = PoochyTheme.surface
    contentView.layer.masksToBounds = true
  }

  override func constructSubviews() {
    stackView.addArrangedSubviews([
      imageView,
      label
    ])
    contentView.addAutolayoutSubview(stackView)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding),
      stackView.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor, constant: -Constants.padding),
      stackView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor, constant: Constants.padding),
      stackView.trailingAnchor.constraint(
        equalTo: contentView.trailingAnchor, constant: -Constants.padding),

      imageView.widthAnchor.constraint(equalToConstant: 50),
      imageView.heightAnchor.constraint(equalToConstant: 50)
    ])
  }

  func configure(
    with item: PDSelectionItem,
    selectedColor: UIColor = .accent,
    position: CellPosition
  ) {
    self.selectedColor = selectedColor
    applyCornerRadiusMask(cellPosition: position)
    label.text = item.title
    imageView.image = UIImage(named: item.imageName)

    updateSelectionStyle()
  }

  private func applyCornerRadiusMask(cellPosition: CellPosition) {
    switch cellPosition {
    case .first:
      contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    case .last:
      contentView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    case .middle:
      contentView.layer.maskedCorners = []
    case .only:
      contentView.layer.maskedCorners = [
        .layerMinXMinYCorner,
        .layerMaxXMinYCorner,
        .layerMinXMaxYCorner,
        .layerMaxXMaxYCorner
      ]
    }
  }

  private func updateSelectionStyle() {
    let selectedColor = selectedColor ?? PoochyTheme.accent

    contentView.layer.borderColor =
      isSelected
      ? selectedColor.cgColor
      : PoochyTheme.outline.cgColor

    contentView.layer.borderWidth =
      isSelected
      ? Constants.selectedBorderWidth
      : Constants.borderWidth

    label.textColor =
      isSelected
      ? selectedColor
      : .label
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    label.text = nil
    imageView.image = nil
    selectedColor = nil
    contentView.layer.maskedCorners = []
    updateSelectionStyle()
  }
}
