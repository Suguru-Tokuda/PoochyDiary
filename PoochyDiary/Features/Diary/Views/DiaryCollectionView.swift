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
    }

    nonisolated enum Item: Hashable {
        case entry(Diary)
    }

    nonisolated enum Section: Hashable {
        case group(DateGroup)
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private let collectionView: UICollectionView
    private let emptyStateView = DiaryEmptyStateView()
    private var diffableDataSource: DataSource?

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    override init(frame: CGRect) {
        collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: frame)
        collectionView.collectionViewLayout = makeLayout()
        diffableDataSource = makeDataSource()
    }

    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructView() {
        super.constructView()
        backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        collectionView.register(
            DiarySectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DiarySectionHeaderView.reuseIdentifier
        )
        collectionView.register(
            DiaryCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier)
        addAutolayoutSubview(collectionView)
        collectionView.backgroundColor = .clear
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
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            switch item {
            case .entry(let diary):
                let cell =
                    collectionView.dequeueReusableCell(
                        withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier,
                        for: indexPath) as? DiaryCollectionViewCell
                cell?.model = DiaryCollectionViewCell.Model(diary: diary)
                cell?.onCellTap = { [weak self] in
                    self?.onDiarySelect?(diary)
                }
                return cell
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

    private func makeLayout() -> UICollectionViewCompositionalLayout {
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
        guard let diffableDataSource else { return }

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

        diffableDataSource.apply(snapshot)
    }
}
