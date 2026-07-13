//
//  PetSelectionCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/12/26.
//

import UIKit

final class PetSelectionCoordinator: BaseCoordinator {
    var onPetSelected: ((Pet) -> Void)?
    var onAddPetRequest: (() -> Void)?

    private let dependencies: AppDependency
    private weak var presentedViewController: UIViewController?

    init(
        navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewModel = PetSelectionViewModel(
            selectedPet: dependencies.petStore?.currentPet,
            dataManager: dependencies.poochyDiaryCoreDataManager
        )
        let viewController = PetSelectionViewController(viewModel: viewModel)

        viewController.onPetSelect = { [weak self] pet in
            self?.select(pet)
        }
        viewController.onClose = { [weak self] in
            self?.dismiss()
        }
        viewController.onAddPet = { [weak self] in
            self?.onAddPetRequest?()
        }

        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
        }
        viewController.presentationController?.delegate = self
        presentedViewController = viewController
        navigationController.present(viewController, animated: true)
    }

    private func select(_ pet: Pet) {
        dependencies.petStore?.select(pet: pet)
        onPetSelected?(pet)
        dismiss()
    }

    private func dismiss() {
        guard let presentedViewController else {
            finish()
            return
        }

        presentedViewController.dismiss(animated: true) { [weak self] in
            self?.finish()
        }
    }
}

extension PetSelectionCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finish()
    }
}
