//
//  NetworkManager.swift
//  Pokemon
//
//  Created by Lo on 2024/6/14.
//

import Alamofire
import Foundation

class NetworkManager {

    func request<T: TargetType, Body: Encodable, Response: Decodable>(target: T,
                                                                      body: Body = EmptyParameter(),
                                                                      completion: @escaping (Result<Response, Error>) -> Void) {
        switch target.method {
        case .get:
            HttpClient.get(target: target, completion: completion)
        case .post:
            HttpClient.post(target: target, body: body, completion: completion)
        }
    }
}
