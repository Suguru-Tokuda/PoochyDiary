//
//  PDSelectionCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDSelectionCollectionView: BaseView {
    private enum Constants {
        static let rowSpacing: CGFloat = 12
        static let sectionTopInset: CGFloat = 8
        static let sectionBottomInset: CGFloat = 8
        static let columnCount: CGFloat = 3
    }

    struct Model {
        let items: [PDSelectionItem]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Int, PDSelectionItem>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, PDSelectionItem>

    let collectionView: UICollectionView

    private var diffableDataSource: DataSource?
    private var cellStyle: PDSelectionCellStyle
    private var collectionHeightConstraint: NSLayoutConstraint?

    init(
        frame: CGRect = .zero,
        cellStyle: PDSelectionCellStyle = PDSelectionCellStyle(selectedColor: .systemPurple)
    ) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: Self.makeLayout())
        collectionView.isScrollEnabled = false
        self.cellStyle = cellStyle
        super.init(frame: frame)
        diffableDataSource = makeDataSource()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()
        collectionView.register(PDSelectionCollectionViewCell.self,
                                forCellWithReuseIdentifier: PDSelectionCollectionViewCell.reuseIdentifier)
        addAutolayoutSubview(collectionView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        collectionHeightConstraint?.isActive = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateCollectionViewHeight()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return nil }

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PDSelectionCollectionViewCell.reuseIdentifier,
                for: indexPath) as? PDSelectionCollectionViewCell else {
                return nil
            }

            cell.configure(with: item, style: cellStyle)
                    
            return cell
        }
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let spacing: CGFloat = Constants.rowSpacing
            let columns = Int(Constants.columnCount)

            let availableWidth = layoutEnvironment.container.effectiveContentSize.width
            let cellWidth = (availableWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)

            let cellHeight = cellWidth

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(cellWidth),
                heightDimension: .absolute(cellHeight)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(cellHeight)
            )

            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: Array(repeating: item, count: columns)
            )

            group.interItemSpacing = .fixed(spacing)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = .zero

            return section
        }
    }

    private func applyModel() {
        guard let model else { return }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(model.items, toSection: 0)

        diffableDataSource?.apply(snapshot) { [weak self] in
            guard let self else { return }

            collectionView.collectionViewLayout.invalidateLayout()
            invalidateIntrinsicContentSize()
        }
    }

    private func updateCollectionViewHeight() {
        guard let model else { return }

        let itemCount = model.items.count
        let columns = Constants.columnCount
        let rows = ceil(CGFloat(itemCount) / columns)

        let availableWidth = bounds.width
        guard availableWidth > 0 else { return }

        let totalColumnSpacing = (columns - 1) * Constants.rowSpacing
        let cellWidth = (availableWidth - totalColumnSpacing) / columns

        let cellHeight = cellWidth
        let totalRowSpacing = max(0, rows - 1) * Constants.rowSpacing

        let height = rows * cellHeight + totalRowSpacing

        collectionHeightConstraint?.constant = height
    }
}
