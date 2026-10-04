//
//  TrendsCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import Combine
import UIKit

final class TrendsCoordinator: BaseCoordinator {
    private let dependencies: AppDependency
    private let viewModel: TrendsViewModel
    private lazy var viewController = TrendsViewController(viewModel: viewModel)
    private var subscriptions = Set<AnyCancellable>()

    init(
        _ navigationController: UINavigationController,
        dependencies: AppDependency
    ) {
        self.dependencies = dependencies
        viewModel = TrendsViewModel(
            pet: dependencies.petStore?.currentPet,
            weightUnit: dependencies.appPreferences?.weightUnit ?? .pounds
        )
        super.init(navigationController)
    }

    override func start() {
        viewModel.updatePet(dependencies.petStore?.currentPet)
        viewModel.updateWeightUnit(dependencies.appPreferences?.weightUnit ?? .pounds)
        viewController.onPetSelectorTap = { [weak self] in
            self?.openPetSelection()
        }
        addSubscriptions()
        navigationController.setViewControllers([viewController], animated: false)
    }

    override func finish() {
        removeSubscriptions()
        super.finish()
    }

    private func addSubscriptions() {
        subscriptions.removeAll()
        dependencies.petStore?.petPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] pet in
                self?.viewModel.updatePet(pet)
            }
            .store(in: &subscriptions)
        dependencies.appPreferences?.weightUnitPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] unit in
                self?.viewModel.updateWeightUnit(unit)
            }
            .store(in: &subscriptions)
    }

    private func removeSubscriptions() {
        subscriptions.removeAll()
    }

    private func openPetSelection() {
        let coordinator = PetSelectionCoordinator(
            navigationController: navigationController,
            dependencies: dependencies
        )
        addChild(coordinator)
        coordinator.start()
    }
}
