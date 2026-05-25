//
//  BaseTagOptionsView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/24/26.
//

import UIKit

class BaseTagOptionsView: BaseView {

    // MARK: - typealias

    typealias DataSource = UICollectionViewDiffableDataSource<Int, Tag>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Tag>

    private(set) var collectionView: UICollectionView
    private(set) var dataSource: DataSource?

    var collectionViewHeightConstraint: NSLayoutConstraint?

    struct Model {
        let tags: [Tag]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        super.init(frame: frame)
        dataSource = makeDataSource()
    }
    
    @MainActor required init?(coder: NSCoder) {
        nil
    }
    
    func applyModel() {
        guard let model else { return }

        applySnapshot(tags: model.tags, animatingDifferences: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }

    // MARK: - CollectionView

    func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            return UICollectionViewCell()
        }
    }

    func applySnapshot(tags: [Tag], animatingDifferences: Bool) {
        guard let dataSource else { return }

        dataSource.apply(makeSnapshot(tags: tags),
                         animatingDifferences: animatingDifferences) { [weak self] in
            self?.updateCollectionViewHeight()
        }
    }


    // MARK: - private functions

    private func updateCollectionViewHeight() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()

        let height = collectionView.collectionViewLayout.collectionViewContentSize.height

        collectionViewHeightConstraint?.constant = max(80, ceil(height))
        invalidateIntrinsicContentSize()
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 8
        let cellHeight: CGFloat = 36
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(cellHeight)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(cellHeight)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )

        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    private func makeSnapshot(tags: [Tag]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(tags, toSection: 0)
        
        return snapshot
    }
}
