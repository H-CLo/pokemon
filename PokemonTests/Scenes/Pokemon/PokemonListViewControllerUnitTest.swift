//
//  PokemonListViewControllerUnitTest.swift
//  PokemonTests
//
//  Created by Lo on 2024/6/20.
//

import XCTest
@testable import Pokemon

final class PokemonListViewControllerUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_lifeCycle_reloadData() {
        let viewController = PokemonListViewController(viewModel: PokemonListViewModel(appDependencies: AppDependencies()))
        viewController.viewDidLoad()
        viewController.collectionView.reloadData()
    }

    func test_navigationItemDidPressed() {
        let viewController = PokemonListViewController(viewModel: PokemonListViewModel(appDependencies: AppDependencies()))
        viewController.viewDidLoad()
        // Type 1 showFavorites
        viewController.navigationItemDidPressed(.showFavorites)
        // Type 2 change grid or list
        viewController.navigationItemDidPressed(.showFavorites)
    }

}
