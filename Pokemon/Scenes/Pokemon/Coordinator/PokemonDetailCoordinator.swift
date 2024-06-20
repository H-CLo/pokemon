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

    init(id: String, navigationController: UINavigationController, appDependencies: AppDependencies) {
        self.id = id
        super.init(navigationController: navigationController, appDependencies: appDependencies)
    }

    override func start() {
        let viewModel = PokemonDetailViewModel(id: id, appDependencies: appDependencies)
        let pokemonDetailViewController = PokemonDetailViewController(viewModel: viewModel)
        pokemonDetailViewController.delegate = self
        navigationController.pushViewController(pokemonDetailViewController, animated: false)
    }
}

extension PokemonDetailCoordinator: PokemonDetailViewProtocol {
    func pushToDetailView(id: String) {
        let pokemonDetailCoordinator = PokemonDetailCoordinator(id: id, navigationController: navigationController, appDependencies: appDependencies)
        add(child: pokemonDetailCoordinator)
        pokemonDetailCoordinator.start()
    }
}
