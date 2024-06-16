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
        contentView.backgroundColor = .systemBlue
    }
}

private extension PokemonGridCollectionViewCell {
    func setupUI() {
        contentView.addSubview(idLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(typesLabel)
        contentView.addSubview(thumbnailImageView)

        idLabel.snp.makeConstraints {
            $0.top.width.centerX.equalToSuperview()
            $0.height.equalTo(15)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(idLabel.snp.bottom)
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(15)
        }

        typesLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.width.centerX.equalToSuperview()
            $0.height.equalTo(15)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(typesLabel.snp.bottom)
            $0.width.centerX.bottom.equalToSuperview()
        }
    }
}
