//
//  DiaryDetailsView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import UIKit

class DiaryDetailsView: BaseView {
    struct Model {
        let pet: Pet
        let diary: Diary
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    var onPhotoSelect: ((Int, UIView) -> Void)? {
        didSet {
            photoViews.onPhotoSelect = onPhotoSelect
        }
    }

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: Spacing.space16
    )

    private let headerView = DiaryDetailsHeaderView()
    private let detailsListView = DiaryDetailsListView()
    private let photoViews = DiaryDetailsPhotosView()

    override func constructView() {
        super.constructView()
        scrollView.alwaysBounceVertical = true
        backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        scrollView.addAutolayoutSubview(stackView)
        stackView.addArrangedSubviews([
            headerView,
            detailsListView,
            photoViews
        ])
        addAutolayoutSubview(scrollView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Spacing.space24),
            stackView.leadingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(
                equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func applyModel() {
        guard let model, let poopData = model.diary.poopData else { return }

        headerView.model = DiaryDetailsHeaderView.Model(pet: model.pet, diary: model.diary)

        detailsListView.model = DiaryDetailsListView.Model(
            stoolType: poopData.stoolType,
            mucusLevel: poopData.mucusLevel,
            bloodAmount: poopData.bloodAmount,
            note: model.diary.notes,
            tags: model.diary.tags
        )

        photoViews.model = DiaryDetailsPhotosView.Model(photos: model.diary.photos)
    }
}
