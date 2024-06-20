//
//  PokemonSpecies.swift
//  Pokemon
//
//  Created by Lo on 2024/6/18.
//

import Foundation

struct PokemonSpecies: Codable {
    let evolution_chain: PokemonSpeciesEvolutionChain
    let flavor_text_entries: [PokemonSpeciesFlavorTextEntry]
}

struct PokemonSpeciesEvolutionChain: Codable {
    let url: String
}

struct PokemonSpeciesFlavorTextEntry: Codable {

    struct Language: Codable {
        let name: String
        let url: String
    }

    struct Version: Codable {
        let name: String
        let url: String
    }

    let flavor_text: String
    let language: Language
    let version: Version
}
