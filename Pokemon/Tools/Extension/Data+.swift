//
//  Data+.swift
//  Pokemon
//
//  Created by Lo on 2024/6/14.
//

import Foundation

extension Data {
    var prettyPrintedJSONString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
              let prettyJSON = String(data: data, encoding: .utf8) else { return nil }
        return prettyJSON
    }
}
