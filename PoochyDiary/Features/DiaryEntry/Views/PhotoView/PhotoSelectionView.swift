//
//  PhotoSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PhotoSelectionView: BaseView {

    // MARK: - Closures

    var onCameraButtonTap: (() -> Void)?
    var onImageGalleryButtonTap: (() -> Void)?
    var onRemoveImage: ((Photo) -> Void)?

    // MARK: - typealias
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Photo>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Photo>

    struct Model {
        let selectedPhotos: [Photo]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private var dataSource: DataSource?
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var addPhotoViewHeightConstraint: NSLayoutConstraint?

    private let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: Spacing.space12)

    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: Strings.DiaryEntry.photos, isOptional: true)
        return label
    }()

    private let collectionView: UICollectionView
    private let addPhotoView = AddPhotoView()
    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .center,
        distribution: .fill,
        spacing: Spacing.space8
    )
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.title = Strings.DiaryEntry.camera
        configuration.image = UIImage(systemName: "camera")
        configuration.imagePadding = Spacing.space4
        configuration.baseForegroundColor = PoochyTheme.accent
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Spacing.space8,
            leading: Spacing.space12,
            bottom: Spacing.space8,
            trailing: Spacing.space12
        )
        button.configuration = configuration
        return button
    }()
    private let imageGalleryButton: UIButton = {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.plain()
        configuration.title = Strings.DiaryEntry.gallery
        configuration.image = UIImage(systemName: "photo.on.rectangle")
        configuration.imagePadding = Spacing.space4
        configuration.baseForegroundColor = PoochyTheme.accent
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: Spacing.space8,
            leading: Spacing.space12,
            bottom: Spacing.space8,
            trailing: Spacing.space12
        )
        button.configuration = configuration
        return button
    }()

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
        collectionView.collectionViewLayout = Self.makeLayout()
        dataSource = makeDataSource()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()
        collectionView.alwaysBounceHorizontal = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isHidden = true
        collectionView.register(PhotoSelectionCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoSelectionCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = PoochyTheme.background
        stackView.addArrangedSubviews([
            collectionView,
            addPhotoView,
            buttonStackView
        ])
        buttonStackView.addArrangedSubviews([
            cameraButton,
            imageGalleryButton,
            UIView()
        ])

        addAutolayoutSubviews([
            label,
            stackView
        ])

        cameraButton.addTarget(self, action: #selector(handleCameraButtonTap), for: .touchUpInside)
        imageGalleryButton.addTarget(self, action: #selector(handleImageGalleryButtonTap), for: .touchUpInside)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        addPhotoViewHeightConstraint = addPhotoView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Spacing.space8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
        collectionViewHeightConstraint?.activate()
        addPhotoViewHeightConstraint?.activate()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func applyModel() {
        let selectedPhotos = model?.selectedPhotos ?? []

        collectionView.isHidden = selectedPhotos.isEmpty
        addPhotoView.isHidden = !selectedPhotos.isEmpty

        guard let dataSource else { return }

        dataSource.apply(makeSnapshot(photos: selectedPhotos))
    }
}

// MARK: - CollectionView

extension PhotoSelectionView {
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let spacing: CGFloat = Spacing.space8
            let availableWidth = layoutEnvironment.container.effectiveContentSize.width
            let cellWidth = availableWidth * 0.9

            let cellHeight = cellWidth

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(cellWidth),
                heightDimension: .absolute(cellHeight)
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )

            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = .zero
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSelectionCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? PhotoSelectionCollectionViewCell else {
                return nil
            }

            cell.onRemoveButtonTap = { [weak self] in
                self?.onRemoveImage?(item)
            }

            if let image = item.image {
                cell.model = PhotoSelectionCollectionViewCell.Model(image: image)
            }

            return cell
        }
    }

    private func makeSnapshot(photos: [Photo]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])

        snapshot.appendItems(photos, toSection: 0)

        return snapshot
    }

    private func updateCollectionViewHeight() {
        let availableWidth = bounds.width
        guard availableWidth > 0 else { return }

        let height = availableWidth * 0.9
        collectionViewHeightConstraint?.constant = height
        addPhotoViewHeightConstraint?.constant = availableWidth * 0.3
    }
}

// MARK: Button handlers

extension PhotoSelectionView {
    @objc private func handleCameraButtonTap() {
        onCameraButtonTap?()
    }

    @objc private func handleImageGalleryButtonTap() {
        onImageGalleryButtonTap?()
    }
}
