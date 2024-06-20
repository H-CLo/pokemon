//
//  BaseViewModel.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import Foundation

class BaseViewModel {
    var isLoading: (() -> Void)?

    let appDependencies: AppDependencies
    let apiManager: NetworkManager
    let favoriteManager: FavoriteManager

    init(appDependencies: AppDependencies) {
        self.appDependencies = appDependencies
        self.apiManager = appDependencies.apiManager
        self.favoriteManager = appDependencies.favoriteManager
    }
}
