//
//  BaseViewModel.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import Foundation

class BaseViewModel {
    var isLoading: (() -> Void)?

    let apiManager: NetworkManager
    let favoriteManager: FavoriteManager

    init() {
        apiManager = PokemonApi.shared
        favoriteManager = FavoriteManager.shared
    }
}
