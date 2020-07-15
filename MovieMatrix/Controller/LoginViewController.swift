//
//  LoginViewController.swift
//  MovieMatrix
//
//  Created by pranay chander on 07/07/20.
//  Copyright © 2020 pranay chander. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak private var userNameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func login(_ sender: MMButton) {
        DispatchQueue.main.async {
            self.setloggingIn(true)
        }
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
                self.setloggingIn(false)
                self.displayAlert(withTitle: MMStringConstants.loginFailed, withMessage: error!.localizedDescription)
            }
        }
    }
    
    private func handleLoginResponse(loginResponse: Bool?, error: Error?) {
        if let loginResponse = loginResponse, loginResponse == true {
            MMNetworkClient.startSession(completion: handleSession(sessionResponse:error:))
        } else {
            DispatchQueue.main.async {
                self.setloggingIn(false)
                self.displayAlert(withTitle: MMStringConstants.loginFailed, withMessage: error!.localizedDescription)
            }
        }
    }
    func handleSession(sessionResponse: Bool?, error: Error?) {
        if let sessionResponse = sessionResponse, sessionResponse == true {
            DispatchQueue.main.async {
                self.setloggingIn(true)
                self.performSegue(withIdentifier: MMSegueIdentifiers.loginComplete, sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.setloggingIn(false)
                self.displayAlert(withTitle: MMStringConstants.loginFailed, withMessage: error!.localizedDescription)
            }
        }
    }
    
    private func setloggingIn(_ logIn: Bool) {
        view.isUserInteractionEnabled = !true
        if logIn {
//            activityIndicator.startAnimating()
        } else {
//            activityIndicator.stopAnimating()
            
        }
    }
}
