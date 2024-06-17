//
//  PokemonBaseCollectionViewCell.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import SDWebImage
import UIKit

class PokemonBaseCollectionViewCell: UICollectionViewCell {
    let idLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let typesLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    let favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        idLabel.text = ""
        nameLabel.text = ""
        typesLabel.text = ""
        thumbnailImageView.image = nil
        favoriteButton.isFavorite = false
    }

    func configCell(item: Pokemon) {
        idLabel.text = "ID: \(item.id)"
        nameLabel.text = "Name: \(item.name)"
        favoriteButton.setFavoriteItem(pokemon: item)
    }

    func configCell(detail: PokemonDetail) {
        typesLabel.text = "Types: \(detail.types.map { $0.type.name }.joined(separator: ", "))"
        thumbnailImageView.sd_setImage(with: URL(string: detail.sprites.front_default))
    }
}
