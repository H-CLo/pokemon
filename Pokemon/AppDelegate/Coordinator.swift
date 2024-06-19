//
//  Coordinator.swift
//  Pokemon
//
//  Created by Lo on 2024/6/19.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func add(child coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
        debugPrint("childCoordinators = \(childCoordinators)")
    }
}

class AppCoordinator: Coordinator {
    private(set) var window: UIWindow?
    var childCoordinators: [Coordinator] = []

    init(scene: UIWindowScene) {
        let window = UIWindow(windowScene: scene)
        window.backgroundColor = .white
        self.window = window
        window.makeKeyAndVisible()
    }

    func start() {
        // Setup RootViewController
        let rootCoodinator = makeCoordinator()
        window?.rootViewController = rootCoodinator.0
        add(child: rootCoodinator.1)
        rootCoodinator.1.start()
    }
}

private extension AppCoordinator {
    func makeCoordinator() -> (UINavigationController, coordinator: Coordinator) {
        let navigationController = UINavigationController()
        let coordinator = PokemonListCoordinator(navigationController: navigationController)
        navigationController.title = "PokemonList"
        return (navigationController, coordinator)
    }
}
