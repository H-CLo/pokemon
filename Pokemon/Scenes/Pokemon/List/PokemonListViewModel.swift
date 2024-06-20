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
    private var pokemonList = PokemonList(count: 0, next: "", previous: "", results: [])
    private var pokemons = [Pokemon]()
    private var displayPokemons: [Pokemon] { showFavorites ? favoritePokemons : pokemons }
    private var pokemonDetails = [String: PokemonDetail]()

    // Favorite
    private var showFavorites: Bool = false
    private var favoritePokemons = [Pokemon]()

    // Load more
    private var offSet = 0
    private let itemPerBatch = 50
    private var isFetchingMore = false
    private var reachEndOfItems = false

    // Binding

    var layoutTypeBlock = PassthroughSubject<PokemonListLayoutType, Never>()
    var pokemonsBlock = PassthroughSubject<[Pokemon], Never>()
    var pokemonDetailBlock = PassthroughSubject<(String, PokemonDetail), Never>()
    var showFavoriteBlock = PassthroughSubject<String, Never>()
}

// MARK: - TableView

extension PokemonListViewModel {
    func getSequenceCount() -> Int {
        return displayPokemons.count
    }

    func getSequencePokemon(_ index: Int) -> Pokemon? {
        return displayPokemons[safe: index]
    }

    func getSequencePokemonDetail(_ index: Int) -> PokemonDetail? {
        return pokemonDetails[getSequencePokemon(index)?.id ?? ""]
    }

    func getPokemonIndex(byID id: String) -> Int? {
        return displayPokemons.firstIndex { $0.id == id }
    }

    func getPokemon(byID id: String) -> Pokemon? {
        return displayPokemons.first { $0.id == id }
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

// MARK: - Favorite

extension PokemonListViewModel {
    func showFavoritesPressed() {
        showFavorites = !showFavorites
        favoritePokemons = Array(favoriteManager.fetchFavorites())
        favoritePokemons.sort { Int($0.id) ?? 0 < Int($1.id) ?? 0 }
        showFavoriteBlock.send("")
    }

    func hasFavorite(id: String) -> Bool {
        guard let pokemon = getPokemon(byID: id) else { return false }
        return favoriteManager.hasFavorite(pokemon)
    }

    func favoriteTapped(id: String) {
        guard let pokemon = getPokemon(byID: id) else { return }
        let hasFavorite = favoriteManager.hasFavorite(pokemon)
        hasFavorite ? favoriteManager.removeFavorite(pokemon) : favoriteManager.addFavorite(pokemon)
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
            case .failure:
                break
            }
        }
    }

    func canLoadMore(index: Int) -> Bool {
        guard !reachEndOfItems else { return false }
        guard !isFetchingMore else { return false }
        guard !showFavorites else { return false }
        return index >= pokemons.count - 5
    }

    func fetchMorePokemonList() {
        isFetchingMore = true
        fetchPokemonList { [weak self] in
            guard let self = self else { return }
            self.isFetchingMore = false
            // Check limitation
            self.reachEndOfItems = self.pokemons.count >= self.pokemonList.count
        }
    }

    func fetchPokemonDetails(_ items: [Pokemon]) {
        for item in items {
            apiManager.requestDetail(id: item.id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(model):
                    self.pokemonDetails[item.id] = model
                    self.pokemonDetailBlock.send((item.id, model))
                case .failure:
                    break
                }
            }
        }
    }
}

// MARK: - UnitTest

extension PokemonListViewModel {
    func unitTest_setPokemons(_ pokemons: [Pokemon]) {
        self.pokemons = pokemons
    }

    func unitTest_setPokemonDetails(_ pokemonDetails: [String: PokemonDetail]) {
        self.pokemonDetails = pokemonDetails
    }

    func unitTest_setParameter(reachEndOfItems: Bool) {
        self.reachEndOfItems = reachEndOfItems
    }

    func unitTest_setParameter(isFetchingMore: Bool) {
        self.isFetchingMore = isFetchingMore
    }

    func unitTest_setParameter(showFavorites: Bool) {
        self.showFavorites = showFavorites
    }
}
