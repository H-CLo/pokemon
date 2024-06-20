//
//  PokemonDetailCoordinatorUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/19.
//

import XCTest
@testable import Pokemon

final class PokemonDetailCoordinatorUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_pushToDetailView() {
        let coordinator = PokemonListCoordinator(navigationController: UINavigationController(), appDependencies: AppDependencies())
        coordinator.start()
        coordinator.pushToDetailView(id: "1")
        XCTAssert(coordinator.childCoordinators.count > 0)
    }
}
