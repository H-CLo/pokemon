//
//  FavoriteButton.swift
//  Pokemon
//
//  Created by Lo on 2024/6/17.
//

import UIKit

class FavoriteButton: UIButton {
    private let favoriteManager: FavoriteManager
    private var favoriteItem: Pokemon?

    var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "like" : "unlike"
            setImage(UIImage(named: imageName), for: .normal)
        }
    }

    init(favoriteManager: FavoriteManager = FavoriteManager.shared) {
        self.favoriteManager = favoriteManager
        super.init(frame: .zero)
        setImage(UIImage(named: "unlike"), for: .normal)
        addTarget(self, action: #selector(favoriteDidPressed), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    func favoriteDidPressed() {
        guard let item = favoriteItem else { return }
        if favoriteManager.hasFavorite(item) {
            favoriteManager.removeFavorite(item)
            isFavorite = false
        } else {
            favoriteManager.addFavorite(item)
            isFavorite = true
        }
    }

    func setFavoriteItem(pokemon: Pokemon) {
        favoriteItem = pokemon
        isFavorite = favoriteManager.hasFavorite(pokemon)
    }
}
