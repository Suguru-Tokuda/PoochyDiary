//
//  DateTimeView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/10/26.
//

import UIKit

class DateTimeView: DiaryEntryFormBaseView {
  struct Model {
    let dateTime: Date?
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  var onDateSelectionLabelTapped: (() -> Void)?

  // MARK: - UI Components

  private let stackView = UIStackView(
    axis: .vertical,
    alignment: .fill,
    distribution: .fill,
    spacing: 12
  )

  private let label: PDLabel = {
    let label = PDLabel()
    label.model = PDLabel.Model(title: Strings.DiaryEntry.dateAndTime, isOptional: false)
    return label
  }()

  private let dateSelectionLabel: PDSelectionView = {
    let selectionLabel = PDSelectionView()
    return selectionLabel
  }()

  override func constructSubviews() {
    super.constructSubviews()
    stackView.addArrangedSubviews([
      label,
      dateSelectionLabel,
      errorMessageView,
    ])
    addAutolayoutSubview(stackView)
    dateSelectionLabel
      .addGestureRecognizer(
        UITapGestureRecognizer(
          target: self,
          action: #selector(handleDateSelectionLabelTap)))
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  private func applyModel() {
    guard let model else { return }

    dateSelectionLabel.model = PDSelectionView.Model(
      text: model.dateTime?.formatted(date: .complete, time: .shortened)
        ?? Strings.DiaryEntry.selectDate,
      image: UIImage(systemName: "calendar.badge.clock"))
  }
}

extension DateTimeView {
  @objc private func handleDateSelectionLabelTap() {
    onDateSelectionLabelTapped?()
  }
}
