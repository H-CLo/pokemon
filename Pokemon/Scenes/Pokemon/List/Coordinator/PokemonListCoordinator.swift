//
//  PokemonListCoordinator.swift
//  Pokemon
//
//  Created by Lo on 2024/6/19.
//

import Foundation
import UIKit

class PokemonListCoordinator: Coordinator {

    override func start() {
        let viewModel = PokemonListViewModel(appDependencies: appDependencies)
        let pokemonListViewController = PokemonListViewController(viewModel: viewModel)
        pokemonListViewController.delegate = self
        navigationController.setViewControllers([pokemonListViewController], animated: false)
    }
}

extension PokemonListCoordinator: PokemonListViewControllerProtocol {
    func pushToDetailView(id: String) {
        let pokemonDetailCoordinator = PokemonDetailCoordinator(id: id, navigationController: navigationController, appDependencies: appDependencies)
        add(child: pokemonDetailCoordinator)
        pokemonDetailCoordinator.start()
    }
}
