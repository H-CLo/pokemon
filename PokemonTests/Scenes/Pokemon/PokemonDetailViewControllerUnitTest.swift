//
//  PokemonDetailViewControllerUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/20.
//

import XCTest
@testable import Pokemon

final class PokemonDetailViewControllerUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_lifeCycle() {
        let viewController = PokemonDetailViewController(viewModel: PokemonDetailViewModel(id: "1", appDependencies: AppDependencies()))
        viewController.viewDidLoad()
    }

}
