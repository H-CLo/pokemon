//
//  PokemonApi.swift
//  Pokemon
//
//  Created by Lo on 2024/6/14.
//

import Foundation

class PokemonApi: NetworkManager {
    typealias ResponseHandler<Response: Decodable> = Result<Response, Error>
    static let shared = PokemonApi()
}

extension PokemonApi {
    /// Request pokemon list api
    /// - Parameters:
    ///   - offset: list start offset
    ///   - limit: list count
    ///   - completion: (Result<PokemonList, Error>) -> Void
    func requestList(offset: Int = 0,
                     limit: Int = 20,
                     completion: @escaping (Result<PokemonList, Error>) -> Void)
    {
        request(target: Target.pokemonList(offset: offset, limit: limit),
                completion: { (result: ResponseHandler<PokemonList>) in
                    switch result {
                    case let .success(model):
                        completion(.success(model))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                })
    }

    /// Request pokemon detail information
    /// - Parameters:
    ///   - id: pokemon index ID
    ///   - completion: (Result<PokemonDetail, Error>) -> Void
    func requestDetail(id: String,
                       completion: @escaping (Result<PokemonDetail, Error>) -> Void)
    {
        request(target: Target.pokemonDetail(id: id),
                completion: { (result: ResponseHandler<PokemonDetail>) in
                    switch result {
                    case let .success(model):
                        completion(.success(model))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                })
    }

    func request<Response: Decodable>(customURL: String,
                                      completion: @escaping (Result<Response, Error>) -> Void)
    {
        request(target: Target.custom(urlStr: customURL),
                completion: { (result: ResponseHandler<Response>) in
                    switch result {
                    case let .success(model):
                        completion(.success(model))
                    case let .failure(error):
                        completion(.failure(error))
                    }
                })
    }
}
