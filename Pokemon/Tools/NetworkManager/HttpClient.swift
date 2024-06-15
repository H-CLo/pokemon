//
//  HttpClient.swift
//  Pokemon
//
//  Created by Lo on 2024/6/15.
//

import Alamofire
import Foundation

struct EmptyParameter: Encodable {}

enum HTTPResponseError: Error {
    case noData
    case decodeFail(error: String)
}

protocol HttpClientProtocol {
    typealias ResponseHandler<Response: Decodable> = (Result<Response, Error>) -> Void
    static func get<T: TargetType, Response: Decodable>(target: T, completion: @escaping ResponseHandler<Response>)
    static func post<T: TargetType, Body: Encodable, Response: Decodable>(target: T, body: Body, completion: @escaping ResponseHandler<Response>)
}

class HttpClient: HttpClientProtocol {
    static func get<T, Response>(target: T, completion: @escaping ResponseHandler<Response>) where T: TargetType, Response: Decodable {
        request(target: target, body: EmptyParameter(), completion: completion)
    }

    static func post<T, Body, Response>(target: T, body: Body, completion: @escaping ResponseHandler<Response>) where T: TargetType, Body: Encodable, Response: Decodable {
        request(target: target, body: body, completion: completion)
    }

    private static func request<T: TargetType, Body: Encodable, Response: Decodable>(target: T, body: Body, completion: @escaping (Result<Response, Error>) -> Void) {
        let urlStr = target.baseURL + target.path
        let method = HTTPMethod(rawValue: target.method.rawValue)
        let headers = HTTPHeaders(target.headers)

        debugPrint("URL = \(urlStr)")
        debugPrint("Method = \(method)")
        debugPrint("Headers = \(headers)")

        AF.request(urlStr,
                   method: method,
                   parameters: body,
                   headers: headers)
            .response(queue: .main,
                      completionHandler: { response in
                          if let error = response.error {
                              debugPrint("Api error, target = \(target), error = \(error)")
                              completion(.failure(error))
                              return
                          }

                          do {
                              if let data = response.data {
                                  if let prettyJSON = data.prettyPrintedJSONString {
                                      debugPrint("prettyJSON = \(prettyJSON)")
                                  }
                                  let model = try JSONDecoder().decode(Response.self, from: data)
                                  completion(.success(model))
                              } else {
                                  let error = HTTPResponseError.noData
                                  debugPrint("Api error, target = \(target), error = \(error)")
                                  completion(.failure(error))
                              }
                          } catch {
                              let error = HTTPResponseError.decodeFail(error: error.localizedDescription)
                              debugPrint("Api error, target = \(target), error = \(error)")
                              completion(.failure(error))
                          }
                      })
    }
}