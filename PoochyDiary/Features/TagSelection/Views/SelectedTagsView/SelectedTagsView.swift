//
//  SelectedTagsView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

class SelectedTagsView: BaseView {
    var onRemoveTag: ((Tag) -> Void)?
    var onChipTap: (() -> Void)?
    var onConfigureTagsButtonTap: (() -> Void)?

    // MARK: - typealias

    private typealias DataSource = UICollectionViewDiffableDataSource<Int, Tag>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Tag>
    
    struct Model {
        let selectedTags: [Tag]
    }

    var model: Model? {
        didSet {
            applyModel()
        }
    }
    private let shouldShowRemoveButton: Bool
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    private let label = PDLabel()
    private let collectionView: UICollectionView
    private let configureTagsButton: PDButton = {
        let button = PDButton()
        button.setTitle("Configure Tags", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .accent
        button.isHidden = true
        return button
    }()

    private var dataSource: DataSource?

    init(frame: CGRect = .zero,
         labelTitle: String = "Selected Tags",
         isOptional: Bool = false,
         shouldShowRemoveButton: Bool = true,
         shouldShowConfigureTagsButton: Bool = false
    ) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: Self.makeLayout())
        label.model = PDLabel.Model(title: labelTitle, isOptional: isOptional)
        configureTagsButton.isHidden = !shouldShowConfigureTagsButton
        self.shouldShowRemoveButton = shouldShowRemoveButton
        super.init(frame: frame)
        dataSource = makeDataSource()
    }
    
    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
        super.constructSubviews()
        collectionView.register(SelectedTagCollectionViewCell.self,
                                forCellWithReuseIdentifier: SelectedTagCollectionViewCell.reuseIdentifier)
        addAutolayoutSubviews([
            label,
            collectionView,
            configureTagsButton
        ])
        collectionView.isScrollEnabled = false
        collectionView.clipsToBounds = false
        collectionView.delegate = self
        configureTagsButton.addTarget(self, action: #selector(handleConfigureButtonTap), for: .touchUpInside)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            configureTagsButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            configureTagsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            configureTagsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            configureTagsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            configureTagsButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        collectionViewHeightConstraint?.activate()
    }

    private func applyModel() {
        guard let selectedTags = model?.selectedTags else { return }
        
        applySnapshot(tags: selectedTags)

        collectionView.isHidden = selectedTags.isEmpty
    }

    func setConfigureButtonVisibility(isHidden: Bool) {
        configureTagsButton.isHidden = isHidden
    }
}

// MARK: - Event handlers

extension SelectedTagsView {
    @objc private func handleConfigureButtonTap() {
        onConfigureTagsButtonTap?()
    }
}

// MARK: - CollectionView

extension SelectedTagsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        onChipTap?()
    }
    
    private func makeDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            guard let self else { return nil }
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedTagCollectionViewCell.reuseIdentifier,
                for: indexPath) as? SelectedTagCollectionViewCell else {
                return nil
            }

            cell.model = SelectedTagCollectionViewCell.Model(
                tag: item,
                shouldShowRemoveButton: shouldShowRemoveButton
            )
            cell.onRemoveButtonTap = { [weak self] in
                self?.onRemoveTag?(item)
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
    
    private func applySnapshot(tags: [Tag]) {
        guard let dataSource else { return }

        dataSource.apply(makeSnapshot(tags: tags), animatingDifferences: false) { [weak self] in
            self?.updateCollectionViewHeight()
        }
    }

    private func updateCollectionViewHeight() {
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.layoutIfNeeded()

        var height = collectionView.collectionViewLayout.collectionViewContentSize.height
        height = model?.selectedTags.isEmpty ?? true ? 0 : max(80, ceil(height))

        collectionViewHeightConstraint?.constant = height
        invalidateIntrinsicContentSize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionViewHeight()
    }
}
