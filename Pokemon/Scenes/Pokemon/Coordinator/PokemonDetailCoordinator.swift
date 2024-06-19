//
//  PokemonDetailCoordinator.swift
//  Pokemon
//
//  Created by Lo on 2024/6/19.
//

import Foundation
import UIKit

class PokemonDetailCoordinator: Coordinator {
    let id: String
    let navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(navigationController: UINavigationController, id: String) {
        self.navigationController = navigationController
        self.id = id
    }

    func start() {
        let viewModel = PokemonDetailViewModel(id: id)
        let pokemonDetailViewController = PokemonDetailViewController(viewModel: viewModel)
        pokemonDetailViewController.delegate = self
        navigationController.pushViewController(pokemonDetailViewController, animated: true)
    }
}

extension PokemonDetailCoordinator: PokemonDetailViewProtocol {
    func pushToDetailView(id: String) {
        let pokemonDetailCoordinator = PokemonDetailCoordinator(navigationController: navigationController, id: id)
        add(child: pokemonDetailCoordinator)
        pokemonDetailCoordinator.start()
    }
}
