//
//  PokemonListViewModel.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import Combine
import Foundation

class PokemonListViewModel: BaseViewModel {
    var layoutType: PokemonListLayoutType = .grid
    var layoutTypeBlock = PassthroughSubject<PokemonListLayoutType, Never>()
}

extension PokemonListViewModel {
    func exchangeGridListLayout() {
        switch layoutType {
        case .grid:
            layoutType = .list
            layoutTypeBlock.send(.list)
        case .list:
            layoutType = .grid
            layoutTypeBlock.send(.grid)
        }
    }
}
