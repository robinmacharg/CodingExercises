//
//  OneOffPaymentRequest.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 18.01.2022.
//

import Foundation

// MARK: - OneOffPaymentRequest
public struct OneOffPaymentRequest: Encodable {
    
    public let amount: Int
    public let investorProductID: Int

    enum CodingKeys: String, CodingKey {
        case amount = "Amount"
        case investorProductID = "InvestorProductId"
    }
    
    public init(amount: Int, investorProductID: Int) {
        self.amount = amount
        self.investorProductID = investorProductID
    }
}
