//
//  PokemonListCollectionViewCell.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import UIKit

class PokemonListCollectionViewCell: PokemonBaseCollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func configCell(item: Pokemon) {
        super.configCell(item: item)
        contentView.backgroundColor = .systemOrange
    }
}

private extension PokemonListCollectionViewCell {
    func setupUI() {
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typesLabel)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(favoriteButton)

        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalTo(thumbnailImageView.snp.leading)
            $0.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalTo(thumbnailImageView.snp.leading)
            $0.height.equalTo(30)
        }

        typesLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.equalTo(thumbnailImageView.snp.leading)
            $0.bottom.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.trailing.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalTo(favoriteButton.snp.leading)
            $0.width.equalTo(90)
        }
    }
}
