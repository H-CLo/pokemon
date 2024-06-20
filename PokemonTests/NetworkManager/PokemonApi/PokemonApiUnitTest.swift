//
//  PokemonApiUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/15.
//

@testable import Pokemon
import XCTest

final class PokemonApiUnitTest: XCTestCase {
    let networkManager = NetworkManager()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_pokemonList() {
        HTTPStubsLoader.stubResponse(host: "pokeapi.co", path: "/api/v2/pokemon", fileName: "pokemonList")

        let expec = XCTestExpectation(description: "test_pokemonList")
        networkManager.requestList(completion: { result in
            switch result {
            case let .success(model):
                XCTAssert(model.count == 1310)
                XCTAssertNil(model.previous)
                XCTAssert(model.next == "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
            case let .failure(error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonList_offset_limit() {
        HTTPStubsLoader.stubResponse(host: "pokeapi.co", path: "/api/v2/pokemon", fileName: "pokemonList")

        let expec = XCTestExpectation(description: "test_pokemonList_offset_limit")
        networkManager.requestList(offset: 40, limit: 20, completion: { result in
            switch result {
            case let .success(model):
                XCTAssert(model.count == 1310)
                XCTAssertNil(model.previous)
                XCTAssert(model.next == "https://pokeapi.co/api/v2/pokemon?offset=20&limit=20")
            case let .failure(error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonDetail() {
        HTTPStubsLoader.stubResponse(host: "pokeapi.co", path: "/api/v2/pokemon/1", fileName: "pokemonDetail")

        let expec = XCTestExpectation(description: "test_pokemonDetail")
        networkManager.requestDetail(id: "1", completion: { result in
            switch result {
            case let .success(model):
                XCTAssert(model.sprites.front_default == "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
                XCTAssert(model.species.name == "bulbasaur")
            case let .failure(error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonRequestSpecies() {
        HTTPStubsLoader.stubResponse(host: "pokeapi.co", path: "/api/v2/pokemon-species/1", fileName: "pokemonSpecies")

        let expec = XCTestExpectation(description: "test_pokemonRequestSpecies")
        networkManager.request(customURL: "https://pokeapi.co/api/v2/pokemon-species/1/",
                               completion: { (result: Result<PokemonSpecies, Error>) in
                                   switch result {
                                   case let .success(model):
                                       XCTAssert(model.flavor_text_entries.first?.language.name == "en")
                                       XCTAssert(model.flavor_text_entries.first?.language.url == "https://pokeapi.co/api/v2/language/9/")
                                       XCTAssert(model.evolution_chain.url == "https://pokeapi.co/api/v2/evolution-chain/1/")
                                   case let .failure(error):
                                       XCTFail("Error = \(error.localizedDescription)")
                                   }
                                   expec.fulfill()
                               })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonRequestEvolutionChain() {
        HTTPStubsLoader.stubResponse(host: "pokeapi.co", path: "/api/v2/evolution-chain/1", fileName: "pokemonEvolutionChain")

        let expec = XCTestExpectation(description: "test_pokemonRequestSpecies")
        networkManager.request(customURL: "https://pokeapi.co/api/v2/evolution-chain/1/",
                               completion: { (result: Result<PokemonEvolutionChain, Error>) in
                                   switch result {
                                   case let .success(model):
                                       XCTAssert(model.chain.species.name == "bulbasaur")
                                       XCTAssert(model.chain.species.url == "https://pokeapi.co/api/v2/pokemon-species/1/")
                                   case let .failure(error):
                                       XCTFail("Error = \(error.localizedDescription)")
                                   }
                                   expec.fulfill()
                               })
        wait(for: [expec], timeout: 5)
    }
}
