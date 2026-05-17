//
//  PhotoSelectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PhotoSelectionView: BaseView {
    // MARK: - typealias
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, String>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, String>

    struct Model {
        let selectedImages: [String]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private var dataSource: DataSource?
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    private var addPhotoViewHeightConstraint: NSLayoutConstraint?

    private let stackView = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 12)

    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Photos", isOptional: true)
        return label
    }()

    private let collectionView: UICollectionView
    private let addPhotoView = AddPhotoView()
    private let buttonStackView = UIStackView(
        axis: .horizontal,
        alignment: .fill,
        distribution: .fillEqually,
        spacing: 8
    )
    private let cameraButton: PDButton = {
        let button = PDButton()
        button.setTitle("Camera", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemPurple
        return button
    }()
    private let imageGalleryButton: PDButton = {
        let button = PDButton()
        button.setTitle("Gallery", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(systemName: "photo"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemPurple
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
        collectionView.isHidden = true
        collectionView.register(PhotoSelectionCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoSelectionCollectionViewCell.reuseIdentifier)
        stackView.addArrangedSubviews([
            collectionView,
            addPhotoView,
            buttonStackView
        ])
        buttonStackView.addArrangedSubviews([
            cameraButton,
            imageGalleryButton
        ])
        
        addAutolayoutSubviews([
            label,
            stackView
        ])
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        addPhotoViewHeightConstraint = addPhotoView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            buttonStackView.heightAnchor.constraint(equalToConstant: 48)
        ])
        collectionViewHeightConstraint?.isActive = true
        addPhotoViewHeightConstraint?.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func applyModel() {
        let selectedImages = model?.selectedImages ?? []

        collectionView.isHidden = selectedImages.isEmpty
        addPhotoView.isHidden = !selectedImages.isEmpty

        guard let dataSource else { return }
        
        dataSource.apply(makeSnapshot(imageURLs: selectedImages))
    }
}

// MARK: - CollectionView

extension PhotoSelectionView {
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let spacing: CGFloat = 8
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
            section.orthogonalScrollingBehavior = .continuous
            return section
        }
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoSelectionCollectionViewCell.reuseIdentifier, for: indexPath)
                    as? PhotoSelectionCollectionViewCell else {
                return nil
            }

            cell.model = PhotoSelectionCollectionViewCell.Model(imageURL: URL(string: item))

            return cell
        }
    }

    private func makeSnapshot(imageURLs: [String]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])

        snapshot.appendItems(imageURLs, toSection: 0)

        return snapshot
    }

    private func updateCollectionViewHeight() {
        let availableWidth = bounds.width
        guard availableWidth > 0 else { return }

        let height = availableWidth * 0.9
        collectionViewHeightConstraint?.constant = height
        addPhotoViewHeightConstraint?.constant = availableWidth * 0.7
    }
}
