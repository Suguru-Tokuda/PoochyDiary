//
//  DiaryEntrySelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/12/26.
//

import UIKit

class DiaryEntrySelectionView: DiaryEntryFormBaseView {
  // MARK: - Closures

  var onItemSelect: ((PDSelectionItem) -> Void)? {
    didSet {
      selectionView.onSelectItem = onItemSelect
    }
  }

  struct Model {
    let selectedId: String?
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }
  // MARK: - UI Components

  private let stackView = UIStackView(
    axis: .vertical,
    alignment: .fill,
    distribution: .fill,
    spacing: 12
  )

  private let label = PDLabel()
  private let selectionView: PDSelectionCollectionView

  init(
    frame: CGRect = .zero,
    title: String,
    isOptional: Bool,
    selectionItems: [PDSelectionItem] = [],
    style: PDSelectionCollectionView.Style = PDSelectionCollectionView.Style(selectedColor: .accent)
  ) {
    label.model = PDLabel.Model(title: title, isOptional: isOptional)
    selectionView = PDSelectionCollectionView(style: style)
    selectionView.model = PDSelectionCollectionView.Model(items: selectionItems)
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    nil
  }

  override func constructSubviews() {
    super.constructSubviews()
    stackView.addArrangedSubviews([
      label,
      errorMessageView,
      selectionView,
    ])
    addAutolayoutSubview(stackView)
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: topAnchor),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  private func applyModel() {
    guard let model,
      let id = model.selectedId
    else { return }

    selectionView.configure(selectedId: id)
  }
}
