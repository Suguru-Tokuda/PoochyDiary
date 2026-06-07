//
//  PDImageCarouselView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/5/26.
//

import UIKit

class PDImageCarouselView: BaseView {
    nonisolated private struct PhotoWrapper: Hashable {
        let copyIndex: Int
        let photo: Photo
    }

    struct Model {
        let photos: [Photo]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Int, PhotoWrapper>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, PhotoWrapper>

    private let collectionView: UICollectionView
    private var dataSource: DataSource?

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        super.init(frame: frame)
    }

    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructView() {
        super.constructView()
        dataSource = makeDataSource()
        collectionView.register(PDImageCarouselViewCell.self,
                                forCellWithReuseIdentifier: PDImageCarouselViewCell.reuseIdentifer)
        collectionView.delegate = self
    }

    override func constructSubviews() {
        super.constructSubviews()
        addAutolayoutSubview(collectionView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PDImageCarouselViewCell.reuseIdentifer, for: indexPath) as?
                    PDImageCarouselViewCell else {
                return nil
            }

            cell.model = PDImageCarouselViewCell.Model(imageURL: itemIdentifier.photo.imageURL)

            return cell
        }
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .zero
            section.orthogonalScrollingBehavior = .groupPaging

            return section
        }
    }

    private func applyModel() {
        let photos = model?.photos ?? []
        applySnapshot(photos: photos)
    }

    private func applySnapshot(photos: [Photo]) {
        guard let dataSource, !photos.isEmpty else { return }

        let repeatCount = photos.count == 1 ? 1 : 100
        let repeated = (0..<repeatCount).flatMap { copyIndex in
            photos.map { PhotoWrapper(copyIndex: copyIndex, photo: $0) }
        }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(repeated, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self else { return }
            let startIndex = photos.count * (repeatCount / 2)
            collectionView.scrollToItem(
                at: IndexPath(item: startIndex, section: 0),
                at: .centeredHorizontally,
                animated: false
            )
        }
    }
}

extension PDImageCarouselView: UICollectionViewDelegate {
    
}
