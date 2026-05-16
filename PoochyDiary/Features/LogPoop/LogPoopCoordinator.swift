//
//  LogPoopCoordinator.swift
//  PoochyDiary
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
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension LogPoopCoordinator: LogPoopViewControllerDelegate {
    func onCancelButtonTap() {
        navigationController.popViewController(animated: true)
        finish()
    }

    func onDateTimeLabelTap() {
        let viewModel = DateTimePickerViewModel()
        let viewController = DateTimePickerViewController(viewModel: viewModel)
        viewController.onCancelButtonTap = { [weak self] in
            self?.navigationController.dismiss(animated: true)
        }

        viewController.onDoneButtonTap = { [weak self] selectedDate in
            self?.navigationController.dismiss(animated: true)
        }

        if let sheet = viewController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        navigationController.present(viewController, animated: true)
    }
}
