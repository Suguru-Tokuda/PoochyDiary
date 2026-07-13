//
//  PetSelectionViewController.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import Combine
import UIKit

final class PetSelectionViewController: BaseViewController {
    var onPetSelect: ((Pet) -> Void)?
    var onClose: (() -> Void)?
    var onAddPet: (() -> Void)?

    private let viewModel: PetSelectionViewModel
    private let petSelectionView = PetSelectionView()
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: PetSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addBindings()

        Task { [weak self] in
            await self?.viewModel.loadPets()
        }
    }

    override func constructView() {
        super.constructView()
        view.backgroundColor = PoochyTheme.background
    }

    override func constructSubviews() {
        super.constructSubviews()
        view.addAutolayoutSubview(petSelectionView)
    }

    override func constructSubviewLayoutConstraints() {
        super.constructSubviewLayoutConstraints()
        NSLayoutConstraint.activate([
            petSelectionView.topAnchor.constraint(equalTo: view.topAnchor),
            petSelectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            petSelectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            petSelectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func addBindings() {
        petSelectionView.onCloseButtonTap = { [weak self] in
            self?.onClose?()
        }
        petSelectionView.onAddPetButtonTap = { [weak self] in
            self?.onAddPet?()
        }
        petSelectionView.onPetSelect = { [weak self] pet in
            self?.viewModel.select(pet)
            self?.onPetSelect?(pet)
        }

        viewModel.$pets
            .combineLatest(viewModel.$selectedPet)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pets, selectedPet in
                self?.petSelectionView.configure(pets: pets, selectedPet: selectedPet)
            }
            .store(in: &subscriptions)
    }
}
