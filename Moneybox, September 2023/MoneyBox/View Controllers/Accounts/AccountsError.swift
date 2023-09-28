//
//  AccountsError.swift
//  MoneyBox
//
//  Created by Robin Macharg on 27/09/2023.
//

import Foundation

enum AccountsError: Error, Equatable {
    case accountRetrievalError(String? = nil)
    
    func desription() -> String {
        switch self {
        case .accountRetrievalError:
            return "Failed to retrieve accounts"
       }
    }
}
