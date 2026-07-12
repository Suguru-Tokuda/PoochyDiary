//
//  DiaryView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/11/26.
//

import UIKit

class DiaryView: BaseView {
  var onDateSelect: ((Date) -> Void)?
  var onDiarySelect: ((Diary) -> Void)?
  var onWeekChange: ((Int) -> Void)?

  struct Model {
    let dateFilterModel: DateFilterCollectionView.Model
    let items: [Diary]
  }

  var model: Model? {
    didSet {
      applyModel()
    }
  }

  // MARK: UI Components

  private let dateFilterView = DateFilterCollectionView()
  private let diaryCollectionView = DiaryCollectionView()

  override func constructSubviews() {
    super.constructSubviews()

    addAutolayoutSubviews([
      dateFilterView,
      diaryCollectionView
    ])

    addEventHandlers()
  }

  override func constructSubviewLayoutConstraints() {
    super.constructSubviewLayoutConstraints()

    NSLayoutConstraint.activate([
      dateFilterView.topAnchor.constraint(equalTo: topAnchor),
      dateFilterView.leadingAnchor.constraint(equalTo: leadingAnchor),
      dateFilterView.trailingAnchor.constraint(equalTo: trailingAnchor),

      diaryCollectionView.topAnchor.constraint(
        equalTo: dateFilterView.bottomAnchor, constant: Spacing.space16),
      diaryCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      diaryCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      diaryCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func applyModel() {
    guard let model else { return }

    dateFilterView.model = model.dateFilterModel
    diaryCollectionView.model = DiaryCollectionView.Model(items: model.items)
  }

  private func addEventHandlers() {
    diaryCollectionView.onDiarySelect = { [weak self] diary in
      self?.onDiarySelect?(diary)
    }

    dateFilterView.onWeekChange = { [weak self] offset in
      self?.onWeekChange?(offset)
    }

    dateFilterView.onDataSelect = { [weak self] date in
      self?.onDateSelect?(date)
    }
  }
}
