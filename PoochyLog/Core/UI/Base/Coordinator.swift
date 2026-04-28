//
//  Coordinator.swift
//  PoochyLog
//
//  Created by Suguru Tokuda on 4/27/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var children: [Coordinator] { get }
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

    init(_ navigationController: UINavigationController = BaseNavigationController()) {
        self.navigationController = navigationController
    }

    func start() {}

    func addChild(_ coordinator: Coordinator) {
        children.append(coordinator)
    }

    func finish() {
        onFinish?()
    }
}
