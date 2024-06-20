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

/// Define http client request function protocol
protocol HttpClientProtocol {
    typealias ResponseHandler<Response: Decodable> = (Result<Response, Error>) -> Void
    static func get<T: TargetType, Response: Decodable>(target: T, completion: @escaping ResponseHandler<Response>)
    static func post<T: TargetType, Body: Encodable, Response: Decodable>(target: T, body: Body, completion: @escaping ResponseHandler<Response>)
}

/// Http request function definition
class HttpClient: HttpClientProtocol {
    static let sessionManager: Session = {
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = cache
        let session = Session(configuration: configuration)
        return session
    }()

    /// Http get request
    /// - Parameters:
    ///   - target: TargetType http request parameters
    ///   - completion: (Result<Response, Error>) -> Void
    static func get<T, Response>(target: T, completion: @escaping ResponseHandler<Response>) where T: TargetType, Response: Decodable {
        request(target: target, body: EmptyParameter(), completion: completion)
    }

    /// Http post request
    /// - Parameters:
    ///   - target: TargetType http request parameters
    ///   - body: Http request body
    ///   - completion: (Result<Response, Error>) -> Void
    static func post<T, Body, Response>(target: T, body: Body, completion: @escaping ResponseHandler<Response>) where T: TargetType, Body: Encodable, Response: Decodable {
        request(target: target, body: body, completion: completion)
    }

    /// Private function to implement http request with Alamofire framewrok
    /// - Parameters:
    ///   - target: TargetType http request parameters
    ///   - body: Http request body
    ///   - completion: (Result<Response, Error>) -> Void
    private static func request<T: TargetType, Body: Encodable, Response: Decodable>(target: T, body: Body, completion: @escaping (Result<Response, Error>) -> Void) {
        let urlStr = target.baseURL + target.path
        let method = HTTPMethod(rawValue: target.method.rawValue)
        let headers = HTTPHeaders(target.headers)

        debugPrint("URL = \(urlStr)")

        let url = URL(string: urlStr)
        debugPrint("Host = \(String(describing: url?.host()))")
        debugPrint("Path = \(String(describing: url?.path()))")


        debugPrint("Method = \(method)")
        debugPrint("Headers = \(headers)")

        sessionManager.request(urlStr,
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
                                      // debugPrint("prettyJSON = \(prettyJSON)")
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
