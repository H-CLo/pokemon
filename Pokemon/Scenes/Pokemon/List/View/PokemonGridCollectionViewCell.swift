//
//  PokemonGridCollectionViewCell.swift
//  Pokemon
//
//  Created by Lo on 2024/6/16.
//

import SnapKit
import UIKit

class PokemonGridCollectionViewCell: PokemonBaseCollectionViewCell {
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
        contentView.backgroundColor = .lightGray
    }
}

private extension PokemonGridCollectionViewCell {
    func setupUI() {
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typesLabel)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(favoriteButton)

        idLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.height.equalTo(20)
            $0.trailing.equalTo(favoriteButton.snp.leading)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.height.equalTo(20)
            $0.trailing.equalTo(favoriteButton.snp.leading)
        }

        typesLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.leading.equalToSuperview()
            $0.height.equalTo(20)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(typesLabel.snp.bottom)
            $0.width.centerX.bottom.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.top.trailing.equalToSuperview()
        }
    }
}
