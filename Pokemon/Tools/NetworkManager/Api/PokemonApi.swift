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
}
