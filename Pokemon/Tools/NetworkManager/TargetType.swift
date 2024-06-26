//
//  TargetType.swift
//  Pokemon
//
//  Created by Lo on 2024/6/14.
//

import Foundation

/// HTTP method
enum HTTPMethodType: String {
    case get = "GET"
    case post = "POST"
}

/// Define http request parameters
protocol TargetType {
    /// The target's base `URL`.
    var baseURL: String { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: HTTPMethodType { get }

    /// The headers to be used in the request.
    var headers: [String: String] { get }
}

enum Target {
    /// Retrieve Pokemon list without specifying ID or name, and control the number of results using limit and offset parameters.
    case pokemonList(offset: Int, limit: Int)
    /// Use this to retrieve the Pokemon data with specifying ID or name, response includes name, images, and other information you need.
    case pokemonDetail(id: String)
    /// Custom url
    case custom(urlStr: String)
}

extension Target: TargetType {
    var baseURL: String {
        switch self {
        case .pokemonList, .pokemonDetail:
            return "https://pokeapi.co/"
        case let .custom(str):
            return str
        }
    }

    var path: String {
        switch self {
        case let .pokemonList(offset, limit):
            return "api/v2/pokemon?offset=\(offset)&limit=\(limit)"
        case let .pokemonDetail(id):
            return "api/v2/pokemon/\(id)"
        case .custom:
            return ""
        }
    }

    var method: HTTPMethodType {
        switch self {
        case .pokemonList, .pokemonDetail, .custom:
            return .get
        }
    }

    var headers: [String: String] {
        return [:]
    }
}
