//
//  APIServiceProviding.swift
//  Pulselive
//
//  Created by Robin Macharg on 29/03/2023.
//

import Foundation

/**
 * Types providing API functionality should adopt this protocol
 */
public protocol APIServiceProviding {
    func getContentList() async throws -> PLContentList
    func getContentDetails(articleID: Int) async throws -> PLContentDetail
}
