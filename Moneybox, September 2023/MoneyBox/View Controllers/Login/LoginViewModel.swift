//
//  LoginModel.swift
//  MoneyBox
//
//  Created by Robin Macharg on 26/09/2023.
//

import Foundation
import Networking

final class LoginViewModel: ObservableObject {
    
    enum State: Equatable {
        case validCredentials(Bool)
        case loggingIn
        case loggedIn
        case error(LoginError)
    }
    
    // MARK: - Published properties
    
    @Published var state: State = .validCredentials(false)
    
    // MARK: - Properties
    
    var dataProvider: DataProviderLogic
    var user: LoginResponse.User?
    
    // MARK: - Lifecycle
    
    init(dataProvider: DataProviderLogic) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - Functions
    
    private func updateFieldsFilledIn() {
        let validCredentials = !(email?.isEmpty ?? true)
            && (email?.isEmail() ?? false)
            && !(password?.isEmpty ?? true)
        state = .validCredentials(validCredentials)
    }
    
    var email: String? {
        didSet {
            updateFieldsFilledIn()
        }
    }
    
    var password: String? {
        didSet {
            updateFieldsFilledIn()
        }
    }
    
    func login() {
        if let email, let password {
            state = .loggingIn
            DispatchQueue.global(qos: .userInitiated).async {
                let loginRequest = LoginRequest(email: email, password: password)
                self.dataProvider.login(request: loginRequest) { result in
                    switch result {
                    case .success(let response):
                        SessionManager().setUserToken(response.session.bearerToken)
                        self.user = response.user
                        self.state = .loggedIn
                    case .failure(_):
                        self.state = .error(.loginFailed("Login Failed.  Please try again."))
                    }
                }
            }
        }
        
        // In reality we should never hit this due to the login button being disabled.
        else {
            state = .error(.loginDetailNotProvided)
        }
    }
}
