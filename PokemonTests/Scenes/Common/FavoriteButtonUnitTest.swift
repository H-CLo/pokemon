//
//  FavoriteButtonUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/20.
//

import XCTest
@testable import Pokemon

final class FavoriteButtonUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_favortieButton() {
        let favoriteButton = FavoriteButton()
        favoriteButton.setID(pokemonID: "123")
        XCTAssert(favoriteButton.unitTest_getID() == "123")

        favoriteButton.setHasFavorite(true)
        XCTAssert(favoriteButton.unitTest_getIsFavorite() == true)
        favoriteButton.setHasFavorite(false)
        XCTAssert(favoriteButton.unitTest_getIsFavorite() == false)

        let expec = XCTestExpectation(description: "test_favortieButton")
        favoriteButton.setID(pokemonID: "456")
        favoriteButton.setBinding { id in
            XCTAssert(id == "456")
            expec.fulfill()
        }
        favoriteButton.favoriteDidPressed()
        self.wait(for: [expec])
    }
}
