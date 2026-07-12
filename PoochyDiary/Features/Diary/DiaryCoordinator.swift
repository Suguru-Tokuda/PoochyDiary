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
        let viewController = DiaryViewController(
            viewModel: viewModel,
            onDiarySelect: { [weak self] selectedDiary in
                self?.openDiaryDetails(for: selectedDiary)
            })

        viewController.delegate = self

        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension DiaryCoordinator {
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
        datePickerViewController.onDateSelect = {
            [weak viewController, weak sheetNavigationController] date in
            viewController?.selectDate(date)
            sheetNavigationController?.dismiss(animated: true)
        }

        navigationController.present(sheetNavigationController, animated: true)
    }
}
