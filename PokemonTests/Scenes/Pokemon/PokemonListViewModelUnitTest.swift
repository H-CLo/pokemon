//
//  PokemonListViewModelUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/19.
//

import Combine
@testable import Pokemon
import XCTest

final class PokemonListViewModelUnitTest: XCTestCase {
    var subscriptions = Set<AnyCancellable>()

    let mockPokemons = [Pokemon(name: "1", url: "1"),
                        Pokemon(name: "2", url: "2"),
                        Pokemon(name: "3", url: "3"),
                        Pokemon(name: "4", url: "4"),
                        Pokemon(name: "5", url: "5")]
    let mockPokemonDetails = ["1": PokemonDetail(id: 1, name: "1", sprites: PokemonDetailSprites(front_default: ""), species: PokemonDetailSpecies(name: "", url: ""), types: []),
                              "2": PokemonDetail(id: 2, name: "2", sprites: PokemonDetailSprites(front_default: ""), species: PokemonDetailSpecies(name: "", url: ""), types: []),
                              "3": PokemonDetail(id: 3, name: "3", sprites: PokemonDetailSprites(front_default: ""), species: PokemonDetailSpecies(name: "", url: ""), types: []),
                              "4": PokemonDetail(id: 4, name: "4", sprites: PokemonDetailSprites(front_default: ""), species: PokemonDetailSpecies(name: "", url: ""), types: []),
                              "5": PokemonDetail(id: 5, name: "5", sprites: PokemonDetailSprites(front_default: ""), species: PokemonDetailSpecies(name: "", url: ""), types: [])]

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        subscriptions.removeAll()
    }

    // MARK: - TableView

    func test_getSequenceCount() {
        let viewModel = PokemonListViewModel()
        viewModel.unitTest_setPokemons(mockPokemons)
        XCTAssert(viewModel.getSequenceCount() == 5)
    }

    func test_getSequencePokemon() {
        let viewModel = PokemonListViewModel()
        viewModel.unitTest_setPokemons(mockPokemons)
        let pokemon = viewModel.getSequencePokemon(2)
        XCTAssertNotNil(pokemon)
        XCTAssert(pokemon?.name == "3")
        XCTAssert(pokemon?.url == "3")

        let pokemon1 = viewModel.getSequencePokemon(100)
        XCTAssertNil(pokemon1)
    }

    func test_getSequencePokemonDetail() {
        let viewModel = PokemonListViewModel()
        viewModel.unitTest_setPokemons(mockPokemons)
        viewModel.unitTest_setPokemonDetails(mockPokemonDetails)
        let detail = viewModel.getSequencePokemonDetail(4)
        XCTAssertNotNil(detail)
        XCTAssert(detail?.id == 5)

        let detail1 = viewModel.getSequencePokemonDetail(100)
        XCTAssertNil(detail1)
    }

    func test_getPokemonIndex() {
        let viewModel = PokemonListViewModel()
        viewModel.unitTest_setPokemons(mockPokemons)
        let index = viewModel.getPokemonIndex(byID: "2")
        XCTAssert(index == 1)

        let index1 = viewModel.getPokemonIndex(byID: "100")
        XCTAssertNil(index1)
    }

    // MARK: - Grid List

    func test_exchangeGridListLayout() {
        let viewModel = PokemonListViewModel()
        let expec = XCTestExpectation(description: "test_exchangeGridListLayout")
        let toType = PokemonListLayoutType.list
        viewModel.layoutTypeBlock.sink { type in
            XCTAssert(type == toType)
            expec.fulfill()
        }.store(in: &subscriptions)
        viewModel.exchangeGridListLayout()
        wait(for: [expec])
    }

    // MARK: - Favorite

    func test_showFavoritesPressed() {
        let viewModel = PokemonListViewModel()
        // Clear up all pokemons
        FavoriteManager.shared.removeAll()

        // Set new favorite pokemons
        FavoriteManager.shared.addFavorites(mockPokemons)

        // Change favorite list
        viewModel.showFavoritesPressed()

        // Check data
        let count = viewModel.getSequenceCount()
        XCTAssert(count == 5)

        let pokemon = viewModel.getSequencePokemon(2)
        XCTAssertNotNil(pokemon)
        XCTAssert(pokemon?.name == "3")

        let pokemon1 = viewModel.getSequencePokemon(100)
        XCTAssertNil(pokemon1)
    }

    // MARK: - Api

    func test_canLoadMore() {
        let viewModel = PokemonListViewModel()
        viewModel.unitTest_setPokemons(mockPokemons+mockPokemons)
        // Check if load more work
        XCTAssert(viewModel.canLoadMore(index: 10))
        // Less than 5 index
        XCTAssertFalse(viewModel.canLoadMore(index: 4))

        // Setup patameters
        viewModel.unitTest_setParameter(reachEndOfItems: true)
        XCTAssertFalse(viewModel.canLoadMore(index: 10))
        viewModel.unitTest_setParameter(reachEndOfItems: false) // Reset

        viewModel.unitTest_setParameter(isFetchingMore: true)
        XCTAssertFalse(viewModel.canLoadMore(index: 10))
        viewModel.unitTest_setParameter(isFetchingMore: false) // Reset

        viewModel.unitTest_setParameter(showFavorites: true)
        XCTAssertFalse(viewModel.canLoadMore(index: 10))
        viewModel.unitTest_setParameter(showFavorites: false) // Reset
    }
}
