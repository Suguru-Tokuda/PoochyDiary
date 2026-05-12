//
//  PDSelectionCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDSelectionCollectionView: BaseView {
    private enum Constants {
        static let cellHeight: CGFloat = 112
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

    override var intrinsicContentSize: CGSize {
        guard let model else {
            return CGSize(width: UIView.noIntrinsicMetric, height: 0)
        }

        let itemCount = model.items.count
        let columns = Constants.columnCount
        let rows = Int(ceil(Double(itemCount) / Double(columns)))

        let cellHeight: CGFloat = Constants.cellHeight
        let rowSpacing: CGFloat = Constants.rowSpacing
        let sectionTopInset: CGFloat = Constants.sectionTopInset
        let sectionBottomInset: CGFloat = Constants.sectionBottomInset

        let height =
            sectionTopInset +
            CGFloat(rows) * cellHeight +
            CGFloat(max(0, rows - 1)) * rowSpacing +
            sectionBottomInset

        return CGSize(
            width: UIView.noIntrinsicMetric,
            height: height
        )
    }

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
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()
        invalidateIntrinsicContentSize()
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
        let spacing: CGFloat = 12
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / Constants.columnCount),
            heightDimension: .absolute(Constants.cellHeight)
        )
        let item = NSCollectionLayoutItem(layoutSize: cellSize)
        item.contentInsets = .zero
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(Constants.cellHeight)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item, item, item]
        )
        group.interItemSpacing = .fixed(spacing)
        let layoutSection = NSCollectionLayoutSection(group: group)
        layoutSection.interGroupSpacing = spacing
        layoutSection.contentInsets = .zero
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .vertical
        
        return UICollectionViewCompositionalLayout(
                section: layoutSection,
                configuration: config
        )
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
}
