//
//  HistoryCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class HistoryCoordinator: BaseCoordinator {
    private let dependencies: AppDependency

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewModel = HistoryViewModel()
        let viewController = HistoryViewController(viewModel: viewModel,
                                                   onLogSelect: { [weak self] selectedLog in
            self?.openHistoryDetails(for: selectedLog)
        })

        navigationController.setViewControllers([viewController], animated: false)
    }
}

extension HistoryCoordinator {
    private func openHistoryDetails(for log: PoopLog) {
        guard let petStore = dependencies.petStore,
              let currentPet = petStore.currentPet else { return }

        let logDetailsCoordinator = LogDetailsCoordinator(
            pet: currentPet,
            log: log,
            navigationController: navigationController,
            dependencies: dependencies
        )

        addChild(logDetailsCoordinator)
        logDetailsCoordinator.start()
    }
}
