//
//  PokemonDetailViewModelUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/19.
//

import Combine
@testable import Pokemon
import XCTest

final class PokemonDetailViewModelUnitTest: XCTestCase {
    var subscriptions = Set<AnyCancellable>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        subscriptions.removeAll()
    }

    func test_sendFlavorText() {
        let viewModel = PokemonDetailViewModel(id: "1")
        let species = PokemonSpecies(evolution_chain: PokemonSpeciesEvolutionChain(url: ""),
                                     flavor_text_entries: [PokemonSpeciesFlavorTextEntry(flavor_text: "Test1",
                                                                                         language: PokemonSpeciesFlavorTextEntry.Language(name: "zh-TW", url: ""),
                                                                                         version: PokemonSpeciesFlavorTextEntry.Version(name: "", url: "")),
                                                           PokemonSpeciesFlavorTextEntry(flavor_text: "Test2",
                                                                                         language: PokemonSpeciesFlavorTextEntry.Language(name: "en", url: ""),
                                                                                         version: PokemonSpeciesFlavorTextEntry.Version(name: "", url: "")),
                                                           PokemonSpeciesFlavorTextEntry(flavor_text: "Test3",
                                                                                         language: PokemonSpeciesFlavorTextEntry.Language(name: "cn", url: ""),
                                                                                         version: PokemonSpeciesFlavorTextEntry.Version(name: "", url: ""))])
        // In this case, we try to get first en text
        let expec = XCTestExpectation(description: "test_sendFlavorText")
        viewModel.flavorTextBlock.sink { text in
            XCTAssert(text == "Test2")
            expec.fulfill()
        }.store(in: &subscriptions)
        viewModel.sendFlavorText(from: species)
        wait(for: [expec])
    }

    func test_sendEvolutions() {
        let viewModel = PokemonDetailViewModel(id: "1")
        let chain3 = PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "3", url: "3"), is_baby: false, evolves_to: [])
        let chain2 = PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "2", url: "2"), is_baby: false, evolves_to: [chain3])
        let chain1 =
            PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "1", url: "1"), is_baby: false, evolves_to: [chain2])
        let mock = PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "0", url: "0"), is_baby: false, evolves_to: [chain1])
        let expec = XCTestExpectation(description: "test_sendEvolutions")
        viewModel.evolutionBlock.sink { species in
            XCTAssert(species.count == 4)
            expec.fulfill()
        }.store(in: &subscriptions)
        viewModel.sendEvolutions(from: PokemonEvolutionChain(chain: mock))
        wait(for: [expec])
    }

    func test_getSpecies() {
        let viewModel = PokemonDetailViewModel(id: "1")
        let mock1 = PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "0", url: "0"), is_baby: false, evolves_to: [])
        let result1 = viewModel.getSpecies(chain: mock1)
        XCTAssert(result1.count == 1)

        let chain3 = PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "3", url: "3"), is_baby: false, evolves_to: [])
        let chain2 = PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "2", url: "2"), is_baby: false, evolves_to: [chain3])
        let chain1 =
            PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "1", url: "1"), is_baby: false, evolves_to: [chain2])
        let mock2 = PokemonEvolutionChain.Chain(species: PokemonEvolutionChain.Species(name: "0", url: "0"), is_baby: false, evolves_to: [chain1])
        let result2 = viewModel.getSpecies(chain: mock2)
        XCTAssert(result2.count == 4)
    }
}
