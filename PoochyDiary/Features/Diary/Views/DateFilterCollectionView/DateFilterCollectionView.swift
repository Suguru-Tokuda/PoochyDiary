//
//  DateFilterCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/11/26.
//

import UIKit

class DateFilterCollectionView: BaseView {
    var onDataSelect: ((Date) -> Void)?
    var onWeekChange: ((Int) -> Void)?

    struct Model {
        let headerModel: DateFilterHeaderView.Model?
        let items: [DateFilterCollectionViewCell.Model]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }

    private let middleWeekStartIndex = 7

    private typealias DataSource = UICollectionViewDiffableDataSource<
        Int, DateFilterCollectionViewCell.Model
    >
    private typealias Snapshot = NSDiffableDataSourceSnapshot<
        Int, DateFilterCollectionViewCell.Model
    >

    // MARK: - UI Components
    private let vStack = UIStackView(axis: .vertical, alignment: .fill, distribution: .fill)
    private let headerView = DateFilterHeaderView()
    private let horizontalDivider: UIView = {
        let view = UIView()
        view.backgroundColor = PoochyTheme.outline
        return view
    }()
    private let collectionContainerView = UIView()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: DateFilterCollectionView.makeLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.alwaysBounceVertical = false
        collectionView.isDirectionalLockEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.register(
            DateFilterCollectionViewCell.self,
            forCellWithReuseIdentifier: DateFilterCollectionViewCell.reuseIdentifier
        )
        return collectionView
    }()

    private lazy var dataSource = makeDataSource()

    override func constructView() {
        super.constructView()

        layer.cornerRadius = Spacing.space12
        layer.borderWidth = 1
        layer.borderColor = PoochyTheme.outline.cgColor
    }

    override func constructSubviews() {
        super.constructSubviews()
        collectionView.delegate = self
        _ = dataSource
        addEventHandlers()

        vStack.addArrangedSubviews([
            headerView,
            horizontalDivider,
            collectionContainerView
        ])
        collectionContainerView.addAutolayoutSubview(collectionView)
        addAutolayoutSubview(vStack)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.space16),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),

            horizontalDivider.heightAnchor.constraint(equalToConstant: 1),
            horizontalDivider.widthAnchor.constraint(equalTo: widthAnchor),

            headerView.heightAnchor.constraint(equalToConstant: 108),
            collectionView.topAnchor.constraint(equalTo: collectionContainerView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: collectionContainerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(
                equalTo: collectionContainerView.leadingAnchor,
                constant: Spacing.space8
            ),
            collectionView.trailingAnchor.constraint(
                equalTo: collectionContainerView.trailingAnchor,
                constant: -Spacing.space8
            ),
            collectionView.heightAnchor.constraint(equalToConstant: 80)
        ])

        vStack.setCustomSpacing(Spacing.space16, after: horizontalDivider)
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal

        return UICollectionViewCompositionalLayout(
            sectionProvider: { _, _ in
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0 / 7.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    repeatingSubitem: item,
                    count: 7
                )

                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0

                return section
            },
            configuration: configuration
        )
    }

    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard
                let cell =
                    collectionView
                    .dequeueReusableCell(
                        withReuseIdentifier: DateFilterCollectionViewCell.reuseIdentifier,
                        for: indexPath) as? DateFilterCollectionViewCell
            else {
                return nil
            }

            cell.model = itemIdentifier

            return cell
        }
    }

    private func applyModel() {
        guard let model else { return }

        headerView.model = model.headerModel
        applySnapshot(items: model.items)
    }

    private func applySnapshot(items: [DateFilterCollectionViewCell.Model]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items, toSection: 0)

        dataSource.apply(snapshot, animatingDifferences: false) { [weak self] in
            guard let self, items.indices.contains(middleWeekStartIndex) else { return }
            self.collectionView.scrollToItem(
                at: IndexPath(item: middleWeekStartIndex, section: 0),
                at: .left,
                animated: false
            )
        }
    }

    private func addEventHandlers() {
        headerView.onWeekChange = { [weak self] offset in
            self?.onWeekChange?(offset)
        }
    }
}

extension DateFilterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        guard let selectedItem = snapshot.itemIdentifiers[safe: indexPath.item]
        else { return }

        onDataSelect?(selectedItem.date)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.width
        guard width > 0 else { return }

        let page = Int(round(scrollView.contentOffset.x / width))

        switch page {
        case 0:
            onWeekChange?(-1)
        case 2:
            onWeekChange?(1)
        default:
            break
        }
    }
}
