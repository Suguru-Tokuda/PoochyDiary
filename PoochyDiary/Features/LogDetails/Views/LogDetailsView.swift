//
//  LogDetailsView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/7/26.
//

import UIKit

class LogDetailsView: BaseView {
    struct Model {
        let pet: Pet
        let log: PoopLog
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

    private let headerView = LogDetailsHeaderView()
    private let detailsListView = LogDetailsListView()
    private let photoViews = LogDetailsPhotosView()

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
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Spacing.space24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    private func applyModel() {
        guard let model else { return }

        headerView.model = LogDetailsHeaderView.Model(pet: model.pet, log: model.log)

        detailsListView.model = LogDetailsListView.Model(
            stoolType: model.log.stoolType,
            mucusLevel: model.log.mucusLevel,
            bloodAmount: model.log.bloodAmount,
            note: model.log.notes,
            tags: model.log.tags
        )

        photoViews.model = LogDetailsPhotosView.Model(photos: model.log.photos)
    }
}
