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

        idLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }

        typesLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalTo(90)
        }
    }
}
