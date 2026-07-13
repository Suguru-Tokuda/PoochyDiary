//
//  DiaryCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class DiaryCoordinator: BaseCoordinator {
    private let dependencies: AppDependency

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewModel = DiaryViewModel()
        let petName = dependencies.petStore?.currentPet?.name ?? ""
        let viewController = DiaryViewController(
            viewModel: viewModel,
            petName: petName,
            onDiarySelect: { [weak self] selectedDiary in
                self?.openDiaryDetails(for: selectedDiary)
            })

        viewController.onPetSelectorTap = { [weak self, weak viewController] in
            guard let self, let viewController else { return }
            openPetSelection(from: viewController)
        }

        viewController.delegate = self

        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension DiaryCoordinator {
    private func openPetSelection(from viewController: DiaryViewController) {
        let coordinator = PetSelectionCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        coordinator.onPetSelected = { [weak viewController] pet in
            viewController?.updatePet(pet)
        }

        addChild(coordinator)
        coordinator.start()
    }

    private func openDiaryDetails(for diary: Diary) {
        guard let petStore = dependencies.petStore,
            let currentPet = petStore.currentPet
        else { return }

        let diaryDetailsCoordinator = DiaryDetailsCoordinator(
            pet: currentPet,
            diary: diary,
            navigationController: navigationController,
            dependencies: dependencies
        )

        addChild(diaryDetailsCoordinator)
        diaryDetailsCoordinator.start()
    }
}

extension DiaryCoordinator: DiaryViewControllerDelegate {
    func onAddButtonTap() {
        guard let petStore = dependencies.petStore,
            let currentPet = petStore.currentPet
        else { return }

        let diaryEntryCoordinator = DiaryEntryCoordinator(
            navigationController,
            pet: currentPet,
            dependencies: dependencies
        )

        addChild(diaryEntryCoordinator)
        diaryEntryCoordinator.start()
    }

    func diaryViewController(
        _ viewController: DiaryViewController,
        didRequestDateSelectionFrom selectedDate: Date
    ) {
        let datePickerViewController = DiaryDatePickerViewController(
            selectedDate: selectedDate
        )
        let sheetNavigationController = UINavigationController(
            rootViewController: datePickerViewController
        )
        sheetNavigationController.modalPresentationStyle = .pageSheet
        sheetNavigationController.sheetPresentationController?.detents = [.medium()]
        sheetNavigationController.sheetPresentationController?.prefersGrabberVisible = true

        datePickerViewController.onCancel = { [weak sheetNavigationController] in
            sheetNavigationController?.dismiss(animated: true)
        }
        datePickerViewController.onDateSelect = { [weak viewController, weak sheetNavigationController] date in
            viewController?.selectDate(date)
            sheetNavigationController?.dismiss(animated: true)
        }

        navigationController.present(sheetNavigationController, animated: true)
    }
}
