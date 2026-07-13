//
//  PetSelectionCollectionView.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class PetSelectionCollectionView: BaseView {
    var onPetSelect: ((Pet) -> Void)?

    private var pets: [Pet] = []
    private var selectedPetId: UUID?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Spacing.space12

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            PetSelectionCollectionViewCell.self,
            forCellWithReuseIdentifier: PetSelectionCollectionViewCell.reuseIdentifier
        )
        return collectionView
    }()

    override func constructSubviews() {
        super.constructSubviews()
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
        self.pets = pets
        selectedPetId = selectedPet?.id
        collectionView.reloadData()
    }
}

extension PetSelectionCollectionView: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        pets.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PetSelectionCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? PetSelectionCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        if let pet = pets[safe: indexPath.item] {
            cell.model = PetSelectionCollectionViewCell.Model(
                pet: pet,
                isSelected: pet.id == selectedPetId
            )
        }
        return cell
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
        onPetSelect?(pets[indexPath.item])
    }
}
