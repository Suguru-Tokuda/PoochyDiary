//
//  HomeCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27PoochyDiary/26.
//

import UIKit

class HomeCoordinator: BaseCoordinator {
    private let dependencies: AppDependency
    private let viewModel = HomeViewModel()

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewController = HomeViewController(viewModel: viewModel)

        viewController.onAddDiaryButtonTap = { [weak self] in
            guard let self else { return }

            navigateToAddDiaryEntry()
        }

        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension HomeCoordinator {
    private func navigateToAddDiaryEntry() {
        let diaryEntryCoordinator = DiaryEntryCoordinator(
            navigationController,
            pet: viewModel.activePet,
            dependencies: dependencies
        )
        diaryEntryCoordinator.start()
        addChild(diaryEntryCoordinator)
    }
}
