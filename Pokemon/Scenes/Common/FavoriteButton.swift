//
//  FavoriteButton.swift
//  Pokemon
//
//  Created by Lo on 2024/6/17.
//

import UIKit

class FavoriteButton: UIButton {
    // MARK: - Property

    private var id: String?

    // MARK: - Binding

    var pokemonPressed: ((_ id: String) -> Void)?

    var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "like" : "unlike"
            setImage(UIImage(named: imageName), for: .normal)
        }
    }

    init() {
        super.init(frame: .zero)
        setImage(UIImage(named: "unlike"), for: .normal)
        addTarget(self, action: #selector(favoriteDidPressed), for: .touchUpInside)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setID(pokemonID: String) {
        id = pokemonID
    }

    func setHasFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }

    func setBinding(_ block: @escaping (_ id: String) -> Void) {
        pokemonPressed = block
    }

    @objc
    func favoriteDidPressed() {
        guard let id = id else { return }
        pokemonPressed?(id)
        isFavorite = !isFavorite
    }
}
