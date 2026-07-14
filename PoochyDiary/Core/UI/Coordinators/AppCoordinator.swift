//
//  AppCoordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/28/26.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    private let window: UIWindow
    private let dependencies = AppDependency()

    init(window: UIWindow) {
        self.window = window
        super.init()
        setupDependencies()
    }

    override func start() {
        let mainCoordinator = MainCoordinator(
            navigationController,
            dependencies: dependencies
        )
        mainCoordinator.start()

        window.backgroundColor = PoochyTheme.background
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        addChild(mainCoordinator)
    }

    private func setupDependencies() {
        dependencies.appPreferences = AppPreferences()
        dependencies.imageFileManager = ImageFileManager()
        dependencies.poochyDiaryCoreDataManager = PoochyDiaryCoreDataManager()
        dependencies.petStore = PetStore()

        if let petStore = dependencies.petStore {
            petStore.select(pet: .mock())
        }
    }
}
