//
//  PokemonList.swift
//  Pokemon
//
//  Created by Lo on 2024/6/15.
//

import Foundation

struct Pokemon: Codable, Hashable {
    let id: String
    let name: String
    let url: String

    init(name: String, url: String) {
        self.id = ""
        self.name = name
        self.url = url
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)

        let lastComponent = URL(string: self.url)?.lastPathComponent ?? ""
        self.id = lastComponent
    }
}

struct PokemonList: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}
