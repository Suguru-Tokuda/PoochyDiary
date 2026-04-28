//
//  EntryDetailsCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class EntryDetailsCoordinator: BaseCoordinator {
    private let dependencies: AppDependency

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewModel = EntryDetailsViewModel()
        let viewController = EntryDetailsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
