//
//  Data+Pulselive.swift
//  Pulselive
//
//  Created by Robin Macharg on 28/03/2023.
//
// swiftlint:disable opening_brace

import Foundation

extension Data {
    
    /**
     * Data as pretty-printed JSON
     * Based on: https://stackoverflow.com/a/54602699/2431627
     */
    func toJSON(pretty: Bool = true) -> String? {
        if String(data: self, encoding: .utf8) == "null" {
            return "null"
        }

        if let json = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json,
                                                      options: [.prettyPrinted, .withoutEscapingSlashes])
        {
            return String(decoding: jsonData, as: UTF8.self)
        }

        return nil
    }
}
