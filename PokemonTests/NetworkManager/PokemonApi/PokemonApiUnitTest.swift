//
//  PokemonApiUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/15.
//

import XCTest
@testable import Pokemon

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
            case .success(let model):
                XCTAssert(model.count > 0)
                XCTAssert(model.results.count > 0)
            case .failure(let error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }

    func test_pokemonList_offset_limit() {
        let expec = XCTestExpectation(description: "test_pokemonList_offset_limit")
        PokemonApi.shared.requestList(offset: 40, limit: 20, completion: { result in
            switch result {
            case .success(let model):
                XCTAssert(model.count > 0)
                XCTAssert(model.results.count > 0)
            case .failure(let error):
                XCTFail("Error = \(error.localizedDescription)")
            }
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }

    func test_pokemonDetail() {
        let expec = XCTestExpectation(description: "test_pokemonDetail")
        PokemonApi.shared.requestDetail(id: "1", completion: { result in
            expec.fulfill()
        })
        self.wait(for: [expec], timeout: 5)
    }
}
