//
//  PokemonList.swift
//  Pokemon
//
//  Created by Lo on 2024/6/15.
//

import Foundation

struct Pokemon: Codable, Hashable {
    let name: String
    let url: String
}

struct PokemonList: Codable {
    let count: Int
    let next: String
    let previous: String
    let results: [Pokemon]
}
