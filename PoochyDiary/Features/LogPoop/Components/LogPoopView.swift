//
//  LogPoopView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/10/26.
//

import UIKit

protocol LogPoopViewDelegate: AnyObject {
    func onDateTimeChanged(dateTime: Date)
    func onStoolTypeChanged(stoolType: StoolType)
    func onMucusLevelChanged(mucusLevel: MucusLevel)
    func onBloodAmountChanged(bloodAmount: BloodAmount)
    func onPhotoSelectionChanged(photos: [UIImage])
    func onNotesChanged(notes: String)
    func onTagsChanged(tags: [Tag])
}

final class LogPoopView: BaseView {

    weak var delegate: LogPoopViewDelegate?

    // UI Components

    private let scrollView = UIScrollView()
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 8
    )

    private let dateTimeView = DateTimeView()
    private let stoolTypeView = StoolTypeView()
    private let mucusLevelView = MucusLevelView()
    private let bloodAmountView = BloodAmountView()
    private let photoSelectionView = PhotoSelectionView()
    private let notesView = NotesView()
    private let tagView = TagView()

    override func constructSubviews() {
        super.constructSubviews()
        scrollView.addAutolayoutSubview(stackView)
        stackView.addArrangedSubviews([
            dateTimeView,
            stoolTypeView,
            mucusLevelView,
            bloodAmountView,
            photoSelectionView,
            notesView,
            tagView
        ])

        addAutolayoutSubview(scrollView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -24),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -48)
        ])
    }
}
