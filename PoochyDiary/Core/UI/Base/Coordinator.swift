//
//  Coordinator.swift
//  PoochyDiary
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var onFinish: (() -> Void)? { get set }
    func start()
    func finish()
}

class BaseCoordinator: NSObject, Coordinator {
    var rootViewController: UIViewController?
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    var onFinish: (() -> Void)?
    private var onLifeCycleFinish: (() -> Void)?

    init(_ navigationController: UINavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }

    func start() {}

    func addChild(_ coordinator: Coordinator) {
        if let baseCoordinator = coordinator as? BaseCoordinator {
            baseCoordinator.onLifeCycleFinish = { [weak self, weak baseCoordinator] in
                guard let self, let baseCoordinator else { return }
                removeChild(baseCoordinator)
            }
        }
        children.append(coordinator)
    }

    private func removeChild(_ coordinator: Coordinator) {
        children.removeAll { $0 === coordinator }
    }

    func finish() {
        onFinish?()
        onLifeCycleFinish?()
    }
}
