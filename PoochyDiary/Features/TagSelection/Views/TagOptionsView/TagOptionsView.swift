//
//  TagOptionsView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

class TagOptionsView: BaseView {

    var onSelectTag: ((Tag) -> Void)?

    // MARK: - typealias

    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Tag>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Tag>

    struct Model {
        let tags: [Tag]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private var collectionViewHeightConstraint: NSLayoutConstraint?

    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Tag Options", isOptional: false)
        return label
    }()
    private let collectionView: UICollectionView
    private var dataSource: DataSource?

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        super.init(frame: frame)
        dataSource = makeDataSource()
    }
    
    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()
        collectionView.register(TagOptionsCollectionViewCell.self,
                                forCellWithReuseIdentifier: TagOptionsCollectionViewCell.reuseIdentifier)
        addAutolayoutSubviews([
            label,
            collectionView
        ])
        collectionView.isScrollEnabled = false
        collectionView.clipsToBounds = false
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        collectionViewHeightConstraint?.activate()
    }

    private func applyModel() {
        guard let model else { return }

        applySnapshot(tags: model.tags, animatingDifferences: false)
    }

}

// MARK: - CollectionView

extension TagOptionsView {
    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TagOptionsCollectionViewCell.reuseIdentifier,
                for: indexPath) as? TagOptionsCollectionViewCell else {
                return nil
            }

            cell.model = TagOptionsCollectionViewCell.Model(tag: item)
            cell.onAddButtonTap = { [weak self] in
                self?.onSelectTag?(item)
            }

            return cell
        }
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
    
    private func applySnapshot(tags: [Tag], animatingDifferences: Bool) {
        guard let dataSource else { return }

        dataSource.apply(makeSnapshot(tags: tags),
                         animatingDifferences: animatingDifferences) { [weak self] in
            self?.updateCollectionViewHeight()
        }
    }

    private func updateCollectionViewHeight() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()

        let height = collectionView.collectionViewLayout.collectionViewContentSize.height

        collectionViewHeightConstraint?.constant = max(80, ceil(height))
        invalidateIntrinsicContentSize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
}
