//
//  AccountDetailsError.swift
//  MoneyBox
//
//  Created by Robin Macharg on 27/09/2023.
//

import Foundation

enum AccountDetailsError: Error, Equatable {
    case failedToAddMoney
    
    func description() -> String {
        switch self {
        case .failedToAddMoney:
            return "Failed to add money"
        }
    }
}
