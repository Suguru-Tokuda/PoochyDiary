//
//  LogPoopView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/10/26.
//

import UIKit

protocol LogPoopViewDelegate: AnyObject {
    func onDateTimeTap()
    func onStoolTypeChanged(item: PDSelectionItem)
    func onMucusLevelChanged(item: PDSelectionItem)
    func onBloodAmountChanged(item: PDSelectionItem)
    func onPhotoSelectionChanged(photos: [Photo])
    func onNotesChanged(notes: String)
    func onTagsTap()
    func onCameraButtonTap()
    func onImageGalleryButtonTap()
    func onRemovePhoto(photo: Photo)
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
        spacing: Spacing.space12
    )

    private let dateTimeView = DateTimeView()
    private let stoolTypeView = LogPoopSelectionView(
        title: Strings.LogPoop.stoolType,
        isOptional: false,
        selectionItems: StoolType.allCases.map {
            PDSelectionItem(
                id: $0.id,
                title: $0.name,
                imageName: $0.imageName.rawValue)
        },
        style: PDSelectionCollectionView.Style(selectedColor: .systemBrown)
    )
    private let mucusLevelView = LogPoopSelectionView(
        title: Strings.LogPoop.mucusLevel,
        isOptional: false,
        selectionItems: MucusLevel.allCases.map {
            PDSelectionItem(
                id: $0.id,
                title: $0.name,
                imageName: $0.imageName.rawValue
            )
        },
        style: PDSelectionCollectionView.Style(selectedColor: .systemGreen))
    private let bloodAmountView = LogPoopSelectionView(
        title: Strings.LogPoop.bloodAmount,
        isOptional: false,
        selectionItems: BloodAmount.allCases.map {
            PDSelectionItem(
                id: $0.id,
                title: $0.name,
                imageName: $0.imageName.rawValue
            )
        },
        style: PDSelectionCollectionView.Style(selectedColor: .systemRed))
    private let photoSelectionView = PhotoSelectionView()
    private let notesView = NotesView()
    private let tagsView = SelectedTagsView(
        labelTitle: Strings.LogPoop.tags,
        isOptional: true,
        shouldShowRemoveButton: false,
        shouldShowConfigureTagsButton: true
    )

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.background
    }

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
            tagsView
        ])

        addAutolayoutSubview(scrollView)

        stackView.setCustomSpacing(12, after: photoSelectionView)
        setupEventHandlers()
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -Spacing.space24),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Spacing.space24),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -Spacing.space24),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -Spacing.space48)
        ])
    }

    func configure(
        dateTime: Date?,
        stoolType: StoolType?,
        mucusLevel: MucusLevel?,
        bloodAmount: BloodAmount?,
        photos: [Photo],
        notes: String?,
        tags: [Tag]
    ) {
        dateTimeView.model = DateTimeView.Model(dateTime: dateTime)
        stoolTypeView.model = LogPoopSelectionView.Model(selectedId: stoolType?.id)
        mucusLevelView.model = LogPoopSelectionView.Model(selectedId: mucusLevel?.id)
        bloodAmountView.model = LogPoopSelectionView.Model(selectedId: bloodAmount?.id)
        photoSelectionView.model = PhotoSelectionView.Model(selectedPhotos: photos)
        notesView.model = NotesView.Model(notes: notes)
        tagsView.model = SelectedTagsView.Model(tags: tags)
        tagsView.setConfigureButtonVisibility(isHidden: !tags.isEmpty)
    }

    func configure(errors: [LogPoopValidationError]) {
        // Reset error message first
        let formBaseViews: [LogPoopFormBaseView] = [
            dateTimeView,
            stoolTypeView,
            mucusLevelView,
            bloodAmountView
        ]

        formBaseViews.forEach {
            $0.setErrorMessage(nil)
        }

        for error in errors {
            switch error {
            case .dateTimeRequired:
                dateTimeView.setErrorMessage(error.message)
            case .stoolTypeRequired:
                stoolTypeView.setErrorMessage(error.message)
            case .mucusLevelRequired:
                mucusLevelView.setErrorMessage(error.message)
            case .bloodAmountRequired:
                bloodAmountView.setErrorMessage(error.message)
            }
        }
    }

    private func setupEventHandlers() {
        dateTimeView.onDateSelectionLabelTapped = { [weak self] in
            self?.delegate?.onDateTimeTap()
        }

        tagsView.onConfigureTagsButtonTap = { [weak self] in
            self?.delegate?.onTagsTap()
        }

        tagsView.onChipTap = { [weak self] in
            self?.delegate?.onTagsTap()
        }

        photoSelectionView.onCameraButtonTap = { [weak self] in
            self?.delegate?.onCameraButtonTap()
        }

        photoSelectionView.onImageGalleryButtonTap = { [weak self] in
            self?.delegate?.onImageGalleryButtonTap()
        }

        photoSelectionView.onRemoveImage = { [weak self] photo in
            self?.delegate?.onRemovePhoto(photo: photo)
        }

        stoolTypeView.onItemSelect = { [weak self] item in
            self?.delegate?.onStoolTypeChanged(item: item)
        }

        mucusLevelView.onItemSelect = { [weak self] item in
            self?.delegate?.onMucusLevelChanged(item: item)
        }

        bloodAmountView.onItemSelect = { [weak self] item in
            self?.delegate?.onBloodAmountChanged(item: item)
        }
    }

    func setBottomInset(_ inset: CGFloat) {
        scrollView.contentInset.bottom = inset
        scrollView.verticalScrollIndicatorInsets.bottom = inset
    }

    func textViewDidBeginEditing() {
        scrollView
            .scrollRectToVisible(
                notesView.convert(notesView.bounds, to: scrollView),
                animated: true
        )
    }
}
