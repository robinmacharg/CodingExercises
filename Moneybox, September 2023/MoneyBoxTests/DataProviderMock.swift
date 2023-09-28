//
//  DataProviderMock.swift
//  MoneyBoxTests
//
//  Created by Robin Macharg on 27/09/2023.
//

import Foundation
import Networking

public class DataProviderMock: DataProviderLogic {
    
    private var succeed: Bool
    
    public init(succeed: Bool) {
        self.succeed = succeed
    }
    
    private func filename(_ filename: String) -> String {
        return filename + (succeed ? "Succeed" : "Fail")
    }
    
    public func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, Error>) -> Void)) {
        StubData.read(file: filename("Login")) { result in
            completion(result)
        }
    }
    
    public func fetchProducts(completion: @escaping ((Result<AccountResponse, Error>) -> Void)) {
        StubData.read(file: filename("Accounts")) { result in
            completion(result)
        }
    }
    
    public func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, Error>) -> Void)) {
        StubData.read(file: filename("AddMoney")) { result in
            completion(result)
        }
    }
}
