//
//  DataProvider.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 20.07.2022.
//

public protocol DataProviderLogic: AnyObject {
    func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, Error>) -> Void))
    func fetchProducts(completion: @escaping ((Result<AccountResponse, Error>) -> Void))
    func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, Error>) -> Void))
}

public class DataProvider: DataProviderLogic {
    public init() {}
    public func login(request: LoginRequest, completion: @escaping ((Result<LoginResponse, Error>) -> Void)) {
        API.Login.login(request: request).fetchResponse(completion: completion)
    }
    
    public func fetchProducts(completion: @escaping ((Result<AccountResponse, Error>) -> Void)) {
        API.Account.products.fetchResponse(completion: completion)
    }
    
    public func addMoney(request: OneOffPaymentRequest, completion: @escaping ((Result<OneOffPaymentResponse, Error>) -> Void)) {
        API.Account.addMoney(request: request).fetchResponse(completion: completion)
    }
}
