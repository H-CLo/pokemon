//
//  PokemonListCoordinator.swift
//  Pokemon
//
//  Created by Lo on 2024/6/19.
//

import Foundation
import UIKit

class PokemonListCoordinator: Coordinator {
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = PokemonListViewModel()
        let pokemonListViewController = PokemonListViewController(viewModel: viewModel)
        pokemonListViewController.delegate = self
        navigationController.setViewControllers([pokemonListViewController], animated: false)
    }
}

extension PokemonListCoordinator: PokemonListViewControllerProtocol {
    func pushToDetailView(id: String) {
        let pokemonDetailCoordinator = PokemonDetailCoordinator(navigationController: navigationController, id: id)
        add(child: pokemonDetailCoordinator)
        pokemonDetailCoordinator.start()
    }
}
