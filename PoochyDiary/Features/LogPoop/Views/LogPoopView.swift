//
//  LogPoopView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/10/26.
//

import UIKit

protocol LogPoopViewDelegate: AnyObject {
    func onDateTimeTap()
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

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()
    private let stackView = UIStackView(
        axis: .vertical,
        alignment: .fill,
        distribution: .fill,
        spacing: 8
    )

    private let dateTimeView = DateTimeView()
    private let stoolTypeView = LogPoopSelectionView(style: PDSelectionCellStyle(selectedColor: .systemBrown))
    private let mucusLevelView = LogPoopSelectionView(style: PDSelectionCellStyle(selectedColor: .systemGreen))
    private let bloodAmountView = LogPoopSelectionView(style: PDSelectionCellStyle(selectedColor: .systemRed))
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

        stoolTypeView.model = LogPoopSelectionView.Model(
            title: "Stool Type",
            isOptional: false,
            selectionItems: StoolType.allCases.map {
                PDSelectionItem(id: UUID(), title: $0.name, imageName: $0.imageName.rawValue)
        })
        mucusLevelView.model = LogPoopSelectionView.Model(
            title: "Mucus Level",
            isOptional: false,
            selectionItems: MucusLevel.allCases.map {
            PDSelectionItem(id: UUID(), title: $0.name, imageName: $0.imageName.rawValue)
        })
        bloodAmountView.model = LogPoopSelectionView.Model(
            title: "Blood Amount",
            isOptional: false,
            selectionItems: BloodAmount.allCases.map {
            PDSelectionItem(id: UUID(), title: $0.name, imageName: $0.imageName.rawValue)
        })

        dateTimeView.onDateSelectionLabelTapped = { [weak self] in
            self?.delegate?.onDateTimeTap()
        }
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
