//
//  PokemonDetail.swift
//  Pokemon
//
//  Created by Lo on 2024/6/15.
//

import Foundation

struct PokemonDetail: Codable {
    let sprites: PokemonDetailSprites
    let species: PokemonDetailSpecies
    let types: [PokemonDetailType]
}

struct PokemonDetailType: Codable {

    struct TypeModel: Codable {
        let name: String
        let url: String
    }

    let slot: Int
    let type: TypeModel
}

struct PokemonDetailSpecies: Codable {
    let name: String
    let url: String
}

struct PokemonDetailSprites: Codable {
    let front_default: String
}
