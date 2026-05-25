//
//  TagOptionsView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

class TagOptionsView: BaseTagOptionsView {

    var onSelectTag: ((Tag) -> Void)?

    private let label: PDLabel = {
        let label = PDLabel()
        label.model = PDLabel.Model(title: "Tag Options", isOptional: false)
        return label
    }()

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

    override func applyModel() {
        guard let model else { return }

        applySnapshot(tags: model.tags, animatingDifferences: false)
    }

    override func makeDataSource() -> DataSource {
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
}
