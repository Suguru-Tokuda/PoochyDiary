//
//  PetSelectionCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class PetSelectionCollectionView: BaseView {
    nonisolated private enum Section: Hashable {
        case main
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Section, UUID>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, UUID>

    var onPetSelect: ((Pet) -> Void)?

    private var petsById: [UUID: Pet] = [:]
    private var selectedPetId: UUID?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Spacing.space12

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.register(
            PetSelectionCollectionViewCell.self,
            forCellWithReuseIdentifier: PetSelectionCollectionViewCell.reuseIdentifier
        )
        return collectionView
    }()

    private lazy var dataSource = DataSource(
        collectionView: collectionView
    ) { [weak self] collectionView, indexPath, petId in
        guard
            let self,
            let pet = petsById[petId],
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetSelectionCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? PetSelectionCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        cell.model = PetSelectionCollectionViewCell.Model(
            pet: pet,
            isSelected: pet.id == selectedPetId
        )
        return cell
    }

    override func constructSubviews() {
        super.constructSubviews()
        _ = dataSource
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

    func configure(pets: [Pet], selectedPet: Pet?) {
        petsById = Dictionary(uniqueKeysWithValues: pets.map { ($0.id, $0) })
        selectedPetId = selectedPet?.id

        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(pets.map(\.id), toSection: .main)
        snapshot.reconfigureItems(pets.map(\.id))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension PetSelectionCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 88)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let petId = dataSource.itemIdentifier(for: indexPath),
            let pet = petsById[petId]
        else {
            return
        }

        onPetSelect?(pet)
    }
}
