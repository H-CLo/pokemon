//
//  PokemonBaseCollectionViewCell.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

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

    func configCell(item: Pokemon) {
        nameLabel.text = item.name
    }
}
