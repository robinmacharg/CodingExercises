//
//  API.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 15.01.2022.
//

import Foundation

public enum API {
    static func getURL(with path: String = "") -> URL {
        return URL(string: ("https://api-test02.moneyboxapp.com\(path)"))!
    }
    
    static func getHeaders() -> [String: String] {
        var headers: [String: String] = ["AppId": "8cb2237d0679ca88db6464",
                                         "Content-Type": "application/json",
                                         "appVersion": "8.10.0",
                                         "apiVersion": "3.0.0"]
        if let token = Authentication.token {
            headers["Authorization"] = "Bearer \(token)"
        }
        return headers
    }
}
