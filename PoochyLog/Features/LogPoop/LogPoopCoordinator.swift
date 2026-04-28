//
//  LogPoopCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class LogPoopCoordinator: BaseCoordinator {
    private let dependencies: AppDependency

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        super.init(navigationController)
    }

    override func start() {
        let viewModel = LogPoopViewModel()
        let viewController = LogPoopViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
