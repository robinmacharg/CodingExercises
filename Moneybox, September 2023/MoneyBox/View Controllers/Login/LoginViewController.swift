//
//  LoginViewController.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//
//  A login screen.  Takes email/password and attempts to log the user in.


import UIKit
import Combine
import Networking

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessage: UILabel!
    
    // Properties
    
    private var model = LoginViewModel(dataProvider: DataProvider())
    private var bindings = Set<AnyCancellable>()
    
    // MARK: - Actions
    
    @IBAction func login(_ sender: Any) {
        model.login()
    }
    
    // This is purely a convenience for reviewers
    @IBAction func prefillEmailAndPassword(_ sender: Any) {
        let email = "test+ios2@moneyboxapp.com"
        let password = "P455word12"
        emailTextField.text = email
        passwordTextField.text = password
        model.email = email
        model.password = password
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        errorMessage.text = ""
        setUpBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        enableScreen(true)
    }
    
    // MARK: - Methods
    
    func enableScreen(_ enabled: Bool) {
        activityIndicator.isHidden = enabled
        self.formContainer.isUserInteractionEnabled = enabled
        self.formContainer.layer.opacity = enabled ? 1.0 : 0.5
        
        if enabled {
            self.activityIndicator.stopAnimating()
        } else {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func setUpBindings() {
        model.$state
            .receive(on: DispatchQueue.main)
            .sink { state in
                switch state {
                case .validCredentials(let valid):
                    self.loginButton.isEnabled = valid
                    self.errorMessage.text = ""
                    
                case .loggingIn:
                    self.enableScreen(false)
                    
                case .loggedIn:
                    self.performSegue(withIdentifier: "login_accounts", sender: self)
                    
                case .error(let error):
                    self.enableScreen(true)
                    if case .loginFailed(let message) = error {
                        self.errorMessage.text = message
                    }
                }
            }
            .store(in: &bindings)
    }
}

// MARK: - Navigation

extension LoginViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "login_accounts":
            if let user = model.user {
                (segue.destination as? AccountsViewController)?.configure(user: user)
            }
        default:
            break
        }
    }
}

// MARK: - <UITextFieldDelegate>

extension LoginViewController: UITextFieldDelegate {
    
    /**
     * Update the model when the user enters text
     */
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String)
    -> Bool
    {
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        
        switch textField {
        case emailTextField:
            model.email = updatedString
        case passwordTextField:
            model.password = updatedString
        default:
            break
        }
        
        return true
    }
}
