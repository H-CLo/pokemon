//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import Combine
import Foundation

class PokemonListViewModel: BaseViewModel {
    var layoutType: PokemonListLayoutType = .grid
    var pokemonList = PokemonList(count: 0, next: "", previous: "", results: [])
    var pokemons = [Pokemon]()
    var pokemonDetails = [String: PokemonDetail]()

    var offSet = 0
    let itemPerBatch = 50
    var isFetchingMore = false
    var reachEndOfItems = false

    // Binding

    var layoutTypeBlock = PassthroughSubject<PokemonListLayoutType, Never>()
    var pokemonsBlock = PassthroughSubject<[Pokemon], Never>()
    var pokemonDetailBlock = PassthroughSubject<(String, PokemonDetail), Never>()
}

// MARK: - TableView

extension PokemonListViewModel {

    func getSequencePokemon(_ index: Int) -> Pokemon? {
        return pokemons[safe: index]
    }

    func getSequencePokemonDetail(_ index: Int) -> PokemonDetail? {
        return pokemonDetails[getSequencePokemon(index)?.id ?? ""]
    }

    func getPokemonIndex(byID id: String) -> Int? {
        return pokemons.firstIndex { $0.id == id}
    }
}

// MARK: - Grid List

extension PokemonListViewModel {
    func exchangeGridListLayout() {
        switch layoutType {
        case .grid:
            layoutType = .list
            layoutTypeBlock.send(.list)
        case .list:
            layoutType = .grid
            layoutTypeBlock.send(.grid)
        }
    }
}

// MARK: - Api call

extension PokemonListViewModel {
    func fetchPokemonList(completion: (() -> Void)? = nil) {
        apiManager.requestList(offset: offSet, limit: itemPerBatch) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(model):
                self.offSet += self.itemPerBatch
                self.pokemonList = model
                self.pokemons.append(contentsOf: model.results)
                self.pokemons.sort { Int($0.id) ?? 0 < Int($1.id) ?? 0 }
                pokemonsBlock.send(self.pokemons)
                self.fetchPokemonDetails(model.results)
                completion?()
            case .failure(_):
                break
            }
        }
    }

    func canLoadMore(index: Int) -> Bool {
        guard !reachEndOfItems else { return false }
        guard !isFetchingMore else { return false }
        return index >= pokemons.count - 5
    }

    func fetchMorePokemonList() {
        isFetchingMore = true
        fetchPokemonList {[weak self] in
            guard let self = self else { return }
            self.isFetchingMore = false
            // Check limitation
            self.reachEndOfItems = self.pokemons.count >= self.pokemonList.count
        }
    }

    func fetchPokemonDetails(_ items: [Pokemon]) {
        for item in items {
            apiManager.requestDetail(id: item.id) {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let model):
                    self.pokemonDetails[item.id] = model
                    self.pokemonDetailBlock.send((item.id, model))
                case .failure(_):
                    break
                }
            }

        }
    }
}
