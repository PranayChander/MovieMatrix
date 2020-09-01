//
//  LoginViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 07/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet weak private var userNameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: MMButton!
    
    @Published var userName: String = ""
    @Published var password: String = ""
    
    var validatedUsername: AnyPublisher<String?, Never> {
           return $userName.map { username in
               guard username.count > 6 else {
                   return nil
               }
               return username
           }.eraseToAnyPublisher()
       }
    
    var validatedPassword: AnyPublisher<String?, Never> {
        return $password.map { psw in
               guard psw.count > 6 else {
                   return nil
               }
               return psw
           }.eraseToAnyPublisher()
       }
    @IBAction func usernameUpdated(_ sender: UITextField) {
        userName = sender.text ?? ""
    }
    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
    }
    
    var readyToSubmit: AnyPublisher<(String, String)?, Never> {
            return Publishers.CombineLatest(validatedUsername, validatedPassword)
                .map { value2, value1 in
                    guard let realValue2 = value2, let realValue1 = value1 else {
                        return nil
                    }
                    return (realValue2, realValue1)
                }
                .eraseToAnyPublisher()
        }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.readyToSubmit
            .map { $0 != nil }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellableSet)
    }
    
    @IBAction func login(_ sender: MMButton) {
        MMNetworkClient.getRequestToken(completion: handleRequestTokenResponse(responseTokenGenerated:error:))
    }
    
    @IBAction func loginViaWeb(_ sender: MMButton) {
        MMNetworkClient.getRequestToken { (success, error) in
            if success {
                DispatchQueue.main.async {
                    UIApplication.shared.open(MMNetworkClient.Endpoints.oAuth.url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    private func handleRequestTokenResponse(responseTokenGenerated: Bool?, error: Error?) {
        if let responseGenerated = responseTokenGenerated, responseGenerated == true {
            DispatchQueue.main.async {
                MMNetworkClient.userLogin(userName: self.userNameTextField.text!, password: self.passwordTextField.text!, completion: self.handleLoginResponse(loginResponse:error:))
            }
        } else {
            DispatchQueue.main.async {
                self.displayAlert(withTitle: MMStringConstants.loginFailed, withMessage: error!.localizedDescription)
            }
        }
    }
    
    private func handleLoginResponse(loginResponse: Bool?, error: Error?) {
        if let loginResponse = loginResponse, loginResponse == true {
            MMNetworkClient.startSession(completion: handleSession(sessionResponse:error:))
        } else {
            DispatchQueue.main.async {
                self.displayAlert(withTitle: MMStringConstants.loginFailed, withMessage: error!.localizedDescription)
            }
        }
    }
    
    func handleSession(sessionResponse: Bool?, error: Error?) {
        if let sessionResponse = sessionResponse, sessionResponse == true {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: MMSegueIdentifiers.loginComplete, sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.displayAlert(withTitle: MMStringConstants.loginFailed, withMessage: error!.localizedDescription)
            }
        }
    }
}
