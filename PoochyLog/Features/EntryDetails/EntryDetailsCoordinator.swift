//
//  EntryDetailsCoordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

final class EntryDetailsCoordinator: BaseCoordinator {
    override func start() {
        let viewModel = EntryDetailsViewModel()
        let viewController = EntryDetailsViewController(viewModel: viewModel)
        navigationController.setViewControllers([viewController], animated: false)
    }
}
