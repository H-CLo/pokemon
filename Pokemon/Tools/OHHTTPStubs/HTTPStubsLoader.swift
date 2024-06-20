//
//  HTTPStubsLoader.swift
//  Pokemon
//
//  Created by Lo on 2024/6/20.
//

import OHHTTPStubs
import OHHTTPStubsSwift

class HTTPStubsLoader {
    static func reset() {
        HTTPStubs.removeAllStubs()
    }

    static func stubResponse(host: String, path: String, fileName: String) {
        stub(condition: isHost(host) && isPath(path)) { req -> HTTPStubsResponse in
            return jsonFixture(with: fileName)
        }
    }

    private static func jsonFixture(with filename: String) -> HTTPStubsResponse {
        return HTTPStubsResponse(fileAtPath: getJSONResponseString(filename), statusCode: 200, headers: nil)
    }

    private static func getJSONResponseString(_ name: String) -> String {
        guard let fileName = Bundle.main.path(forResource: name, ofType: "json") else {return ""}
        return fileName
    }
}
