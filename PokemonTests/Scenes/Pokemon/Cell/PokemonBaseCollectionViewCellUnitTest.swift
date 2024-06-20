//
//  PokemonBaseCollectionViewCellUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/20.
//

import XCTest
@testable import Pokemon

final class PokemonBaseCollectionViewCellUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_lifeCycle() {
        let cell = PokemonBaseCollectionViewCell(frame: .zero)
        cell.prepareForReuse()
        cell.configCell(item: Pokemon(name: "1", url: "1"))
        cell.configCell(detail: PokemonDetail(id: 1, name: "1", sprites: PokemonDetailSprites(front_default: ""), species: PokemonDetailSpecies(name: "", url: ""), types: []))
        cell.configCell(id: "1", isFavorite: true)
    }

    func test_grid_lifeCycle() {
        let cell = PokemonGridCollectionViewCell(frame: .zero)
    }

    func test_list_lifeCycle() {
        let cell = PokemonListCollectionViewCell(frame: .zero)
    }
}
