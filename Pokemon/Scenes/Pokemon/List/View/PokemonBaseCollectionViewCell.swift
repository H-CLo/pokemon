//
//  PokemonBaseCollectionViewCell.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import SDWebImage
import UIKit

protocol PokemonBaseCollectionViewCellDelegate: AnyObject {
    func favoriteTapped(id: String)
}

class PokemonBaseCollectionViewCell: UICollectionViewCell {
    // MARK: - Property

    weak var delegate: PokemonBaseCollectionViewCellDelegate?

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

    override init(frame: CGRect) {
        super.init(frame: frame)
        bindingFavoriteButton()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        idLabel.text = ""
        nameLabel.text = ""
        typesLabel.text = ""
        thumbnailImageView.image = nil
        favoriteButton.setID(pokemonID: "")
        favoriteButton.setHasFavorite(false)
    }

    func configCell(item: Pokemon) {
        idLabel.text = "ID: \(item.id)"
        nameLabel.text = "Name: \(item.name)"
    }

    func configCell(detail: PokemonDetail) {
        typesLabel.text = "Types: \(detail.types.map { $0.type.name }.joined(separator: ", "))"
        thumbnailImageView.sd_setImage(with: URL(string: detail.sprites.front_default))
    }

    func configCell(id: String, isFavorite: Bool) {
        favoriteButton.setID(pokemonID: id)
        favoriteButton.setHasFavorite(isFavorite)
    }

    func bindingFavoriteButton() {
        favoriteButton.setBinding { [weak self] id in
            self?.delegate?.favoriteTapped(id: id)
        }
    }
}
