//
//  Account.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 17.01.2022.
//

import Foundation

public extension API {
    enum Account: AppNetworkable {
        case products
        case addMoney(request: OneOffPaymentRequest)
        
        public var request: URLRequest {
            switch self {
            case .products:
                return getRequest(with: "/investorproducts", httpMethod: .GET)
            case let .addMoney(request):
                return getRequest(with: "/oneoffpayments", encodable: request, httpMethod: .POST)
            }
        }
    }
}
