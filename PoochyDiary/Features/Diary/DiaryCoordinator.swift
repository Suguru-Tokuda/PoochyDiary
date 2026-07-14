//
//  DiaryCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class DiaryCoordinator: BaseCoordinator {
    private let dependencies: AppDependency
    private weak var diaryViewController: DiaryViewController?

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        guard let appPreferences = dependencies.appPreferences else {
            finish()
            return
        }

        let viewModel = DiaryViewModel(appPreferences: appPreferences)
        let petName = dependencies.petStore?.currentPet?.name ?? ""
        let viewController = DiaryViewController(
            viewModel: viewModel,
            petName: petName,
            onDiarySelect: { [weak self] selectedDiary in
                self?.openDiaryDetails(for: selectedDiary)
            })
        diaryViewController = viewController

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

        switch diary.type {
        case .poop:
            let diaryDetailsCoordinator = DiaryDetailsCoordinator(
                pet: currentPet,
                diary: diary,
                navigationController: navigationController,
                dependencies: dependencies
            )

            addChild(diaryDetailsCoordinator)
            diaryDetailsCoordinator.start()
        case .weight:
            guard let diaryViewController else { return }
            openWeightEntry(
                for: currentPet,
                diary: diary,
                from: diaryViewController
            )
        }
    }
}

extension DiaryCoordinator: DiaryViewControllerDelegate {
    func diaryViewController(
        _ viewController: DiaryViewController,
        didSelectTrackingOption option: DiaryTrackingOption
    ) {
        guard let petStore = dependencies.petStore,
            let currentPet = petStore.currentPet
        else { return }

        switch option {
        case .poop:
            openPoopEntry(for: currentPet)
        case .weight:
            openWeightEntry(for: currentPet, from: viewController)
        }
    }

    private func openPoopEntry(for pet: Pet) {
        let diaryEntryCoordinator = DiaryEntryCoordinator(
            navigationController,
            pet: pet,
            dependencies: dependencies
        )

        addChild(diaryEntryCoordinator)
        diaryEntryCoordinator.start()
    }

    private func openWeightEntry(
        for pet: Pet,
        diary: Diary? = nil,
        from viewController: DiaryViewController
    ) {
        let coordinator = WeightEntryCoordinator(
            navigationController: navigationController,
            pet: pet,
            diary: diary,
            dependencies: dependencies
        )
        coordinator.onWeightSaved = { [weak viewController] diary in
            viewController?.addDiary(diary)
        }

        addChild(coordinator)
        coordinator.start()
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
