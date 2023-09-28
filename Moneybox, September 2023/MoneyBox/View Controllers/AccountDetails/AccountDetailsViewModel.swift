//
//  AccountDetailsModel.swift
//  MoneyBox
//
//  Created by Robin Macharg on 26/09/2023.
//

import Foundation
import Networking

class AccountDetailsViewModel: ObservableObject {
    
    enum State {
        case initial
        case loading
        case loaded
        case sendingMoney
        case sent
        case error(AccountDetailsError)
    }
    
    // MARK: - Properties
    
    var id: Int?
    var account: String?
    var planValue: Double?
    var moneybox: Double?
    
    // MARK: - Published properties
    
    @Published var state: State = .initial
    
    // MARK: - Private properties
    
    private var dataProvider: DataProviderLogic
    
    // MARK: - Lifecycle
    
    init(dataProvider: DataProviderLogic) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - Methods
    
    func configure(
        account: String,
        planValue: Double,
        moneybox: Double,
        id: Int
    ) {
        self.account = account
        self.planValue = planValue
        self.moneybox = moneybox
        self.id = id
    }
    
    func addMoney(_ amount: Int) {
        state = .sendingMoney
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let id = self.id {
                let paymentRequest = OneOffPaymentRequest(
                    amount: amount,
                    investorProductID: id)
                self.dataProvider.addMoney(
                    request: paymentRequest) { result in
                        switch result {
                        case .success(let response):
                            self.moneybox = response.moneybox
                            self.state = .sent
                        case .failure(_):
                            self.state = .error(.failedToAddMoney)
                        }
                    }
            }
        }
    }
}
