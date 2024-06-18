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

    init(id: String) {
        self.id = id
    }

    func start() {
        fetchPokemonDetail(id: id)
    }
}

// MARK: - Api

extension PokemonDetailViewModel {
    func fetchPokemonDetail(id: String) {
        apiManager.requestDetail(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.pokemonDetail = model
                self.pokemonDetailBlock.send(model)
                self.requestSpecies(urlStr: model.species.url)
            case .failure:
                break
            }
        }
    }

    func requestSpecies(urlStr: String) {
        apiManager.request(customURL: urlStr) { [weak self] (result: Result<PokemonSpecies, Error>) in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.sendFlavorText(from: model)
                self.requestEvolutionChain(urlStr: model.evolution_chain.url)
            case .failure:
                break
            }
        }
    }

    func requestEvolutionChain(urlStr: String) {
        apiManager.request(customURL: urlStr) { [weak self] (result: Result<PokemonEvolutionChain, Error>) in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                debugPrint("Result = \(model)")
                sendEvolutions(from: model)
            case .failure:
                break
            }
        }
    }

    func sendFlavorText(from: PokemonSpecies) {
        let firstEnText = from.flavor_text_entries.first { $0.language.name == "en" }?.flavor_text ?? ""
        flavorTextBlock.send(firstEnText)
    }

    func sendEvolutions(from: PokemonEvolutionChain) {
        let species = [from.chain.species] + getSpecies(evolution: from.chain.evolves_to.first)
        evolutionBlock.send(species)
    }

    // Recursive get evolution species
    func getSpecies(evolution: PokemonEvolutionChain.EvolvesTo?) -> [PokemonEvolutionChain.Species] {
        guard let evolution = evolution else { return [] }
        var result = [evolution.species]
        result.append(contentsOf: getSpecies(evolution: evolution.evolves_to.first))
        return result
    }
}
