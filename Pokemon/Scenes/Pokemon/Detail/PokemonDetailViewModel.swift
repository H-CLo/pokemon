//
//  PokemonDetailViewModel.swift
//  Pokemon
//
//  Created by Lo on 2024/6/18.
//

import Combine
import Foundation

class PokemonDetailViewModel: BaseViewModel {
    // MARK: - Property

    let id: String
    var pokemonDetail: PokemonDetail?

    // MARK: - Binding

    var pokemonDetailBlock = PassthroughSubject<PokemonDetail, Never>()
    var flavorTextBlock = PassthroughSubject<String, Never>()
    var evolutionBlock = PassthroughSubject<[PokemonEvolutionChain.Species], Never>()

    init(id: String, appDependencies: AppDependencies) {
        self.id = id
        super.init(appDependencies: appDependencies)
    }

    func start() {
        fetchPokemonDetail(id: id)
    }
}

// MARK: - Api

extension PokemonDetailViewModel {
    func fetchPokemonDetail(id: String, completion: ((_ model: PokemonDetail?) -> Void)? = nil) {
        apiManager.requestDetail(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.pokemonDetail = model
                self.pokemonDetailBlock.send(model)
                self.requestSpecies(urlStr: model.species.url)
                completion?(model)
            case .failure:
                completion?(nil)
            }
        }
    }

    func requestSpecies(urlStr: String, completion: ((_ model: PokemonSpecies?) -> Void)? = nil) {
        apiManager.request(customURL: urlStr) { [weak self] (result: Result<PokemonSpecies, Error>) in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.sendFlavorText(from: model)
                self.requestEvolutionChain(urlStr: model.evolution_chain.url)
                completion?(model)
            case .failure:
                completion?(nil)
            }
        }
    }

    func requestEvolutionChain(urlStr: String, completion: ((_ model: PokemonEvolutionChain?) -> Void)? = nil) {
        apiManager.request(customURL: urlStr) { [weak self] (result: Result<PokemonEvolutionChain, Error>) in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                sendEvolutions(from: model)
                completion?(model)
            case .failure:
                completion?(nil)
            }
        }
    }

    func sendFlavorText(from: PokemonSpecies) {
        let firstEnText = from.flavor_text_entries.first { $0.language.name == "en" }?.flavor_text ?? ""
        flavorTextBlock.send(firstEnText)
    }

    func sendEvolutions(from: PokemonEvolutionChain) {
        let species = getSpecies(chain: from.chain)
        evolutionBlock.send(species)
    }

    func getSpecies(evolution: PokemonEvolutionChain.EvolvesTo?) -> [PokemonEvolutionChain.Species] {
        guard let evolution = evolution else { return [] }
        var result = [evolution.species]
        result.append(contentsOf: getSpecies(evolution: evolution.evolves_to.first))
        return result
    }

    // Recursive get evolution species
    func getSpecies(chain: PokemonEvolutionChain.Chain) -> [PokemonEvolutionChain.Species] {
        var result = [chain.species]
        if let first = chain.evolves_to.first {
            result += getSpecies(chain: first)
        }
        return result
    }
}

// MARK: - Favorite

extension PokemonDetailViewModel {
    func getFavoriteInfo(model: PokemonDetail) -> (Pokemon, Bool) {
        let target = Target.pokemonDetail(id: model.id.description)
        let pokemon = Pokemon(name: model.name, url: target.baseURL + target.path + "/")
        return (pokemon, favoriteManager.hasFavorite(pokemon))
    }

    func favoriteTapped() {
        guard let detail = pokemonDetail else { return }
        let favoriteInfo = getFavoriteInfo(model: detail)
        favoriteInfo.1 ? favoriteManager.removeFavorite(favoriteInfo.0) : favoriteManager.addFavorite(favoriteInfo.0)
    }
}
