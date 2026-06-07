//
//  PoopHistoryCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 6/1/26.
//

import UIKit

struct DateGroup: Hashable {
    let date: Date
}

class PoopHistoryCollectionView: BaseView {
    struct Model {
        let items: [PoopLog]
    }

    nonisolated enum Item: Hashable {
        case entry(PoopLog)
    }

    nonisolated enum Section: Hashable {
        case group(DateGroup)
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private let collectionView: UICollectionView

    private var diffableDataSource: DataSource?

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
        collectionView.collectionViewLayout = makeLayout()
        diffableDataSource = makeDataSource()
    }

    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()
        collectionView.register(
            PoopHistorySectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PoopHistorySectionHeaderView.reuseIdentifier
        )
        collectionView.register(PoopHistoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: PoopHistoryCollectionViewCell.reuseIdentifier)
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
}

// MARK: - private functions

extension PoopHistoryCollectionView {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .entry(let log):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PoopHistoryCollectionViewCell.reuseIdentifier,
                    for: indexPath) as? PoopHistoryCollectionViewCell
                cell?.model = PoopHistoryCollectionViewCell.Model(log: log)
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: PoopHistorySectionHeaderView.reuseIdentifier,
                    for: indexPath) as? PoopHistorySectionHeaderView,
                  let section = dataSource.sectionIdentifier(for: indexPath.section) else {
                return nil
            }

            if case .group(let dateGroup) = section {
                header.model = PoopHistorySectionHeaderView.Model(date: dateGroup.date)
            }

            return header
        }

        return dataSource
    }

    private func makeLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, layoutEnvironment in
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

            header.edgeSpacing = .init(leading: .fixed(0), top: .fixed(8), trailing: .fixed(0), bottom: .fixed(0))

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 4
            section.boundarySupplementaryItems = [header]
            section.contentInsets = .init(top: 4, leading: 0, bottom: 4, trailing: 0)

            return section
        }
    }

    private func applyModel() {
        guard let diffableDataSource else { return }

        var items = model?.items ?? []
        items = items.sorted(by: { $0.date > $1.date })

        var itemsDict: [Date: [PoopLog]] = [:]

        items.forEach {
            let beginningOfDay = Calendar.current.startOfDay(for: $0.date)

            var subItems = itemsDict[beginningOfDay] ?? []

            subItems.append($0)
            subItems.sort(by: { $0.date > $1.date })

            itemsDict[beginningOfDay] = subItems
        }
        
        var snapshot = Snapshot()

        let dates = itemsDict.keys.sorted(by: { $0 > $1 })

        dates.enumerated().forEach { (index, date) in
            let section = Section.group(DateGroup(date: date))
            snapshot.appendSections([section])
            let entries = (itemsDict[date] ?? []).map { Item.entry($0) }
            snapshot.appendItems(entries, toSection: section)
        }

        diffableDataSource.apply(snapshot)
    }
}
