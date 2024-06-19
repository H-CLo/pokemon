//
//  PokemonApiUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/15.
//

@testable import Pokemon
import XCTest

final class PokemonApiUnitTest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_pokemonList() {
        let expec = XCTestExpectation(description: "test_pokemonList")
        PokemonApi.shared.requestList(completion: { result in
            switch result {
            case let .success(model):
                XCTAssert(model.count > 0)
                XCTAssert(model.results.count > 0)
            case let .failure(error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonList_offset_limit() {
        let expec = XCTestExpectation(description: "test_pokemonList_offset_limit")
        PokemonApi.shared.requestList(offset: 40, limit: 20, completion: { result in
            switch result {
            case let .success(model):
                XCTAssert(model.count > 0)
                XCTAssert(model.results.count > 0)
                debugPrint("Models = \(model.results)")
            case let .failure(error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonDetail() {
        let expec = XCTestExpectation(description: "test_pokemonDetail")
        PokemonApi.shared.requestDetail(id: "1", completion: { result in
            switch result {
            case let .success(model):
                XCTAssert(model.sprites.front_default.count > 0)
                XCTAssert(model.species.name.count > 0)
                XCTAssert(model.types.count > 0)
                debugPrint("Models = \(model)")
            case let .failure(error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonRequestSpecies() {
        let expec = XCTestExpectation(description: "test_pokemonRequestSpecies")
        PokemonApi.shared.request(customURL: "https://pokeapi.co/api/v2/pokemon-species/1/",
                                  completion: { (result: Result<PokemonSpecies, Error>) in
                                      switch result {
                                      case let .success(model):
                                          XCTAssert(model.flavor_text_entries.count > 0)
                                          XCTAssert(model.evolution_chain.url.count > 0)
                                          expec.fulfill()
                                      case let .failure(error):
                                          XCTFail("Error = \(error.localizedDescription)")
                                      }
                                      expec.fulfill()
                                  })
        wait(for: [expec], timeout: 5)
    }

    func test_pokemonRequestEvolutionChain() {
        let expec = XCTestExpectation(description: "test_pokemonRequestSpecies")
        PokemonApi.shared.request(customURL: "https://pokeapi.co/api/v2/evolution-chain/1/",
                                  completion: { (result: Result<PokemonEvolutionChain, Error>) in
                                      switch result {
                                      case let .success(model):
                                          XCTAssert(model.chain.species.name.count > 0)
                                          XCTAssert(model.chain.evolves_to.count > 0)
                                          expec.fulfill()
                                      case let .failure(error):
                                          XCTFail("Error = \(error.localizedDescription)")
                                      }
                                      expec.fulfill()
                                  })
        wait(for: [expec], timeout: 5)
    }
}
