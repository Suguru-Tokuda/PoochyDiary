//
//  WeightEntryCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 7/13/26.
//

import UIKit

final class WeightEntryCoordinator: BaseCoordinator {
    var onWeightSaved: ((Diary) -> Void)?

    private let pet: Pet
    private let dependencies: AppDependency
    private weak var presentedViewController: UIViewController?

    init(
        navigationController: UINavigationController,
        pet: Pet,
        dependencies: AppDependency
    ) {
        self.pet = pet
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        guard let dataManager = dependencies.poochyDiaryCoreDataManager else {
            finish()
            return
        }

        let viewModel = WeightEntryViewModel(pet: pet, dataManager: dataManager)
        let viewController = WeightEntryViewController(viewModel: viewModel)
        viewController.onSave = { [weak self] diary in
            self?.onWeightSaved?(diary)
            self?.dismiss()
        }
        viewController.onCancel = { [weak self] in
            self?.dismiss()
        }

        viewController.modalPresentationStyle = .pageSheet
        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [
                .custom(identifier: .weightEntry) { context in
                    min(360, context.maximumDetentValue)
                }
            ]
            sheet.prefersGrabberVisible = true
        }
        viewController.presentationController?.delegate = self
        presentedViewController = viewController
        navigationController.present(viewController, animated: true)
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

extension WeightEntryCoordinator: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        finish()
    }
}

private extension UISheetPresentationController.Detent.Identifier {
    static let weightEntry = UISheetPresentationController.Detent.Identifier("weightEntry")
}
