//
//  SelectedTagsView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 5/17/26.
//

import UIKit

class SelectedTagsView: BaseTagOptionsView {

    var onRemoveTag: ((Tag) -> Void)?
    var onChipTap: (() -> Void)?
    var onConfigureTagsButtonTap: (() -> Void)?

    private let shouldShowRemoveButton: Bool

    private let label = PDLabel()
    private let configureTagsButton: PDButton = {
        let button = PDButton()
        button.setTitle("Configure Tags", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .accent
        button.isHidden = true
        return button
    }()

    init(frame: CGRect = .zero,
         labelTitle: String = "Selected Tags",
         isOptional: Bool = false,
         shouldShowRemoveButton: Bool = true,
         shouldShowConfigureTagsButton: Bool = false
    ) {
        label.model = PDLabel.Model(title: labelTitle, isOptional: isOptional)
        configureTagsButton.isHidden = !shouldShowConfigureTagsButton
        self.shouldShowRemoveButton = shouldShowRemoveButton
        super.init(frame: frame)
    }

    @MainActor required init?(coder: NSCoder) {
        nil
    }

    override func constructSubviews() {
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

            collectionView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Spacing.space8),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            configureTagsButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            configureTagsButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            configureTagsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            configureTagsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            configureTagsButton.heightAnchor.constraint(equalToConstant: Spacing.space48)
        ])
        collectionViewHeightConstraint?.activate()
    }

    override func applyModel() {
        guard let tags = model?.tags else { return }

        applySnapshot(tags: tags, animatingDifferences: false)

        collectionView.isHidden = tags.isEmpty
    }

    func setConfigureButtonVisibility(isHidden: Bool) {
        configureTagsButton.isHidden = isHidden
    }

    override func makeDataSource() -> DataSource {
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
}
