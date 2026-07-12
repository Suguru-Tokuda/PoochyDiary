//
//  DateFilterCollectionViewCell.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/11/26.
//

import UIKit

class DateFilterCollectionViewCell: BaseCollectionViewCell {
  static var reuseIdentifier: String {
    "DateFilterCollectionViewCell"
  }

  nonisolated struct Model: Hashable {
    let date: Date
    let day: Days
    let hasDiary: Bool
    let isSelected: Bool
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  private let vStack = UIStackView(
    axis: .vertical,
    alignment: .center,
    distribution: .fill,
    spacing: Spacing.space4
  )
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .themedFont(.caption)
    label.textColor = PoochyTheme.secondaryText
    return label
  }()
  private let dateNumberLabel: UILabel = {
    let label = UILabel()
    label.font = .themedFont(.caption)
    label.textColor = PoochyTheme.secondaryText
    return label
  }()
  private let circleView: UIView = {
    let view = UIView()
    view.backgroundColor = PoochyTheme.accent
    view.layer.cornerRadius = Spacing.space4 / 2
    view.layer.cornerCurve = .circular
    view.layer.masksToBounds = true
    return view
  }()

  override func constructView() {
    super.constructView()
    layer.cornerRadius = Spacing.space20
  }

  override func constructSubviews() {
    super.constructSubviews()
    vStack.addArrangedSubviews([
      dateLabel,
      dateNumberLabel,
      circleView
    ])
    contentView.addAutolayoutSubview(vStack)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      vStack.topAnchor.constraint(equalTo: contentView.topAnchor),
      vStack.bottomAnchor.constraint(
        equalTo: contentView.bottomAnchor,
        constant: -Spacing.space8
      ),
      vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

      circleView.widthAnchor.constraint(equalToConstant: Spacing.space4),
      circleView.heightAnchor.constraint(equalToConstant: Spacing.space4)
    ])
  }

  private func applyModel() {
    guard let model else { return }

    dateLabel.text = model.day.short
    dateNumberLabel.text = model.date.formatted(with: "d")
    circleView.alpha = model.hasDiary ? 100 : 0
    toggleSelection(isSelected: model.isSelected)
  }

  func toggleSelection(isSelected: Bool) {
    backgroundColor = isSelected ? PoochyTheme.accent.withAlphaComponent(0.7) : nil
  }
}
