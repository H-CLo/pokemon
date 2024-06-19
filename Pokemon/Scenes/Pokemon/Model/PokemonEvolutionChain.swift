//
//  PokemonEvolutionChain.swift
//  Pokemon
//
//  Created by Lo on 2024/6/18.
//

import Foundation

struct PokemonEvolutionChain: Codable {

    struct Species: Codable {
        let name: String
        let url: String
    }

    struct EvolvesTo: Codable {
        let species: Species
        let is_baby: Bool
        let evolves_to: [EvolvesTo]
    }

    struct Chain: Codable {
        let species: Species
        let is_baby: Bool
        let evolves_to: [Chain]
    }

    let chain: Chain
}
