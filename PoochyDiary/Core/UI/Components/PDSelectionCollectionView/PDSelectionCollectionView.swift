//
//  PDSelectionCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/8/26.
//

import UIKit

class PDSelectionCollectionView: BaseView {
    struct Style {
        var numberOfColumns: Int
        var cellStyle: CellStyle
        var cellSpacing: CGFloat
        var selectedColor: UIColor

        init(numberOfColumns: Int = 0,
             cellStyle: CellStyle = .customHeight(80),
             cellSpacing: CGFloat = 0,
             selectedColor: UIColor = .accent
        ) {
            self.numberOfColumns = numberOfColumns
            self.cellStyle = cellStyle
            self.cellSpacing = cellSpacing
            self.selectedColor = selectedColor
        }
    }

    enum CellStyle {
        case square(Int)
        case customHeight(CGFloat)
    }

    // MARK: - Closures

    var onSelectItem: ((PDSelectionItem) -> Void)?

    private enum Constants {
        static let rowSpacing: CGFloat = 0
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
    private var style: Style
    private var collectionHeightConstraint: NSLayoutConstraint?

    init(
        frame: CGRect = .zero,
        style: Style = Style()
    ) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: Self.makeLayout())
        collectionView.isScrollEnabled = false
        self.style = style
        super.init(frame: frame)
        diffableDataSource = makeDataSource()
        collectionView.delegate = self
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

        collectionHeightConstraint?.activate()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.layoutIfNeeded()
        updateCollectionViewHeight()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func configure(selectedId: String) {
        guard let model,
              let visibleCells = collectionView.visibleCells as? [PDSelectionCollectionViewCell] else {
            return
        }

        visibleCells.forEach {
            if let indexPath = collectionView.indexPath(for: $0),
               let item = model.items[safe: indexPath.row],
               item.id == selectedId {
                $0.isSelected = true
            } else {
                $0.isSelected = false
            }
        }
    }
}

// MARK: - UICollectionViewDelegate

extension PDSelectionCollectionView: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        guard let model,
           let selectedItem = model.items[safe: indexPath.item] else {
            return
        }

        onSelectItem?(selectedItem)
    }
}

// MARK: - private functions

extension PDSelectionCollectionView {
    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return nil }

            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PDSelectionCollectionViewCell.reuseIdentifier,
                for: indexPath) as? PDSelectionCollectionViewCell else {
                return nil
            }

            let cellPosition: CellPosition

            if model?.items.count == 1 {
                cellPosition = .only
            } else if indexPath.item == 0 {
                cellPosition = .first
            } else if indexPath.item == (model?.items.count ?? -1) - 1 {
                cellPosition = .last
            } else {
                cellPosition = .middle
            }

            cell.configure(with: item, selectedColor: style.selectedColor, position: cellPosition)

            return cell
        }
    }

    private static func makeLayout(
        itemCount: Int = 0,
        cellStyle: CellStyle = .square(3),
        spacing: CGFloat = 0
    ) -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let columns: Int

            switch cellStyle {
            case .customHeight(_):
                columns = itemCount
            case .square(let numberOfColumns):
                columns = numberOfColumns
            }

            let availableWidth = layoutEnvironment.container.effectiveContentSize.width
            let cellWidth = (availableWidth - CGFloat(columns - 1) * spacing) / CGFloat(columns)
            let cellHeight: CGFloat

            switch cellStyle {
            case .customHeight(let height):
                cellHeight = height
            case .square(_):
                cellHeight = cellWidth
            }

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
//                subitems: Array(repeating: item, count: columns)
                subitems: [item]
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

        collectionView.collectionViewLayout = Self.makeLayout(
            itemCount: model.items.count,
            cellStyle: style.cellStyle,
            spacing: style.cellSpacing
        )

        diffableDataSource?.apply(snapshot) { [weak self] in
            guard let self else { return }

            collectionView.collectionViewLayout.invalidateLayout()
            invalidateIntrinsicContentSize()
        }
    }

    private func updateCollectionViewHeight() {
        let cellStyle = style.cellStyle

        switch cellStyle {
        case .square(let numberOfColumns):
            guard let model else { return }

            let itemCount = model.items.count
            let columns = CGFloat(numberOfColumns)
            let rows = ceil(CGFloat(itemCount) / columns)

            let availableWidth = bounds.width
            guard availableWidth > 0 else { return }

            let totalColumnSpacing = (columns - 1) * Constants.rowSpacing
            let cellWidth = (availableWidth - totalColumnSpacing) / columns

            let cellHeight = cellWidth
            let totalRowSpacing = max(0, rows - 1) * Constants.rowSpacing

            let height = rows * cellHeight + totalRowSpacing

            collectionHeightConstraint?.constant = height
        case .customHeight(let height):
            collectionHeightConstraint?.constant = height
        }
    }
}
