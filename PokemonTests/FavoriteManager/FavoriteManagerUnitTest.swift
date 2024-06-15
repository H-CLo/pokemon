//
//  FavoriteManagerUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/15.
//

import XCTest
@testable import Pokemon

final class FavoriteManagerUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_addFavorite() {
        let pokemon1 = Pokemon(name: "Test1", url: "Test1")
        let pokemon2 = Pokemon(name: "Test2", url: "Test2")
        let pokemon3 = Pokemon(name: "Test3", url: "Test3")
        let pokemon4 = Pokemon(name: "Test4", url: "Test4")
        let items = [pokemon1, pokemon2, pokemon3, pokemon4]
        FavoriteManager.shared.addFavorites(items)
        XCTAssert(items.count == FavoriteManager.shared.fetchFavorites().count)

        // Clear
        FavoriteManager.shared.removeAll()
    }

    func test_removeFavorite() {
        let pokemon1 = Pokemon(name: "Test5", url: "Test5")
        let pokemon2 = Pokemon(name: "Test6", url: "Test6")
        let pokemon3 = Pokemon(name: "Test7", url: "Test7")
        let pokemon4 = Pokemon(name: "Test8", url: "Test8")
        let items = [pokemon1, pokemon2, pokemon3, pokemon4]
        FavoriteManager.shared.addFavorites(items)
        FavoriteManager.shared.removeFavorite(pokemon1)
        let favorites = FavoriteManager.shared.fetchFavorites()
        XCTAssert(favorites.count == 3)
        XCTAssertFalse(favorites.contains(pokemon1))

        // Clear
        FavoriteManager.shared.removeAll()
    }

    func test_hasFavorite() {
        let pokemon1 = Pokemon(name: "Test9", url: "Test9")
        let pokemon2 = Pokemon(name: "Test10", url: "Test10")
        let pokemon3 = Pokemon(name: "Test11", url: "Test11")
        let pokemon4 = Pokemon(name: "Test12", url: "Test12")
        let pokemon5 = Pokemon(name: "Test13", url: "Test13")
        let items = [pokemon1, pokemon2, pokemon3, pokemon4]
        FavoriteManager.shared.addFavorites(items)
        XCTAssert(FavoriteManager.shared.hasFavorite(pokemon1))
        XCTAssert(FavoriteManager.shared.hasFavorite(pokemon2))
        XCTAssert(FavoriteManager.shared.hasFavorite(pokemon4))
        XCTAssertFalse(FavoriteManager.shared.hasFavorite(pokemon5))

        // Clear
        FavoriteManager.shared.removeAll()
    }
}
