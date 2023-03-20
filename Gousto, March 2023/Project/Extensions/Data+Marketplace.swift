//
//  Data+Marketplace.swift
//  Marketplace
//
//  Created by Robin Macharg on 20/03/2023.
//

import Foundation

extension Data {
    /**
     * Data as pretty-printed JSON
     * Based on: https://stackoverflow.com/a/54602699/2431627
     */
    func toJSON(pretty: Bool = true) -> String? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .withoutEscapingSlashes]) {
            return String(decoding: jsonData, as: UTF8.self)
        }
        return nil
    }
}
