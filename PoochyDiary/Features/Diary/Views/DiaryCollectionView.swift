//
//  DiaryCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/1/26.
//

import UIKit

nonisolated struct DateGroup: Hashable {
    let date: Date
}

class DiaryCollectionView: BaseView {
    var onDiarySelect: ((Diary) -> Void)?

    struct Model {
        let items: [Diary]
        let weightUnit: WeightUnit
    }

    nonisolated enum Item: Hashable {
        case entry(Diary)
    }

    nonisolated enum Section: Hashable {
        case group(DateGroup)
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: DiaryCollectionView.makeLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.register(
            DiarySectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DiarySectionHeaderView.reuseIdentifier
        )
        collectionView.register(
            DiaryCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            DiaryWeightCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryWeightCollectionViewCell.reuseIdentifier
        )
        return collectionView
    }()
    private let emptyStateView = DiaryEmptyStateView()
    private lazy var diffableDataSource = makeDataSource()

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        _ = diffableDataSource
        addAutolayoutSubview(collectionView)
        collectionView.backgroundView = emptyStateView
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
}

// MARK: - private functions

extension DiaryCollectionView {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return nil }

            switch item {
            case .entry(let diary):
                switch diary.type {
                case .poop:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier,
                        for: indexPath) as? DiaryCollectionViewCell
                    cell?.model = DiaryCollectionViewCell.Model(diary: diary)
                    cell?.onCellTap = { [weak self] in
                        self?.onDiarySelect?(diary)
                    }
                    return cell
                case .weight(let weightData):
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: DiaryWeightCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as? DiaryWeightCollectionViewCell
                    cell?.model = DiaryWeightCollectionViewCell.Model(
                        diary: diary,
                        weightData: weightData,
                        weightUnit: model?.weightUnit ?? .pounds
                    )
                    cell?.onCellTap = { [weak self] in
                        self?.onDiarySelect?(diary)
                    }
                    return cell
                }
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: DiarySectionHeaderView.reuseIdentifier,
                    for: indexPath) as? DiarySectionHeaderView,
                let section = dataSource.sectionIdentifier(for: indexPath.section)
            else {
                return nil
            }

            if case .group(let dateGroup) = section {
                header.model = DiarySectionHeaderView.Model(date: dateGroup.date)
            }

            return header
        }

        return dataSource
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(80)
            )

            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(80)
            )

            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(20)
            )

            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            header.edgeSpacing = .init(
                leading: .fixed(0), top: .fixed(Spacing.space8), trailing: .fixed(0),
                bottom: .fixed(0))

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = Spacing.space4
            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(
                top: Spacing.space4, leading: 0, bottom: Spacing.space4, trailing: 0)

            return section
        }
    }

    private func applyModel() {
        var items = model?.items ?? []
        emptyStateView.isHidden = !items.isEmpty
        items = items.sorted(by: { $0.date > $1.date })

        var itemsDict: [Date: [Diary]] = [:]

        items.forEach {
            let beginningOfDay = Calendar.current.startOfDay(for: $0.date)

            var subItems = itemsDict[beginningOfDay] ?? []

            subItems.append($0)
            subItems.sort(by: { $0.date > $1.date })

            itemsDict[beginningOfDay] = subItems
        }

        var snapshot = Snapshot()

        let dates = itemsDict.keys.sorted(by: { $0 > $1 })

        dates.enumerated().forEach { (_, date) in
            let section = Section.group(DateGroup(date: date))
            snapshot.appendSections([section])
            let entries = (itemsDict[date] ?? []).map { Item.entry($0) }
            snapshot.appendItems(entries, toSection: section)
        }

        let currentItems = Set(diffableDataSource.snapshot().itemIdentifiers)
        let weightItemsToReconfigure = snapshot.itemIdentifiers.filter { item in
            guard currentItems.contains(item),
                  case .entry(let diary) = item,
                  case .weight = diary.type else {
                return false
            }

            return true
        }
        snapshot.reconfigureItems(weightItemsToReconfigure)

        diffableDataSource.apply(snapshot)
    }
}
