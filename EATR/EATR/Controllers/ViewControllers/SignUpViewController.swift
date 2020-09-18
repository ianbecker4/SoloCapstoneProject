//
//  SignUpViewController.swift
//  EATR
//
//  Created by Ian Becker on 9/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var appIconImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        appIconImageView.layer.cornerRadius = 10
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func logInButtonTapped(_ sender: Any) {
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            presentFailureAlertController(title: "Sign In Failed", message: "Please fill in all fields")
        }
        
        let email = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        UserController.shared.signInUserWith(email: email, password: password) { (result) in
            switch result {
            case .success(let user):
                guard let user = user else { return }
                UserController.shared.currentUser = user
                self.transitionToAccount()
            case .failure(let error):
                self.presentFailureAlertController(title: "Sign In Failed", message: "\(error.errorDescription)")
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        presentCreateAlertController()
    }
    
    // MARK: - Methods
    func transitionToAccount() {
        let accountViewController = (storyboard?.instantiateViewController(identifier: "AccountVC") as? AccountViewController)!
        
        let navigationController = UINavigationController.init(rootViewController: accountViewController)
        
        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
    
    func presentFailureAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentCreateAlertController() {
        let alert = UIAlertController(title: "Sign Up!", message: "Create your EATR account!", preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create Account!", style: .default) { (_) in
            
            let firstNameTextField = alert.textFields![0]
            let lastNameTextField = alert.textFields![1]
            let createEmailTextField = alert.textFields![2]
            let createPasswordTextField = alert.textFields![3]
            
            if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                createEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                createPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                self.presentFailureAlertController(title: "Sign Up Failed", message: "Please fill in all fields")
            }
            
            let cleanedEmail = createEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedPassword = createPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Validation.isValidEmail(cleanedEmail) == false {
                self.presentFailureAlertController(title: "Sign Up Failed", message: "Please make sure your email is in the correct format.")
            } else if Validation.isPasswordValid(cleanedPassword) == false {
                self.presentFailureAlertController(title: "Sign Up Failed", message: "Please make sure your password is at least 8 characters, contains a special character, and a number.")
            }
            
            guard let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !firstName.isEmpty, !lastName.isEmpty else { return }
            
            if Validation.isValidEmail(cleanedEmail) == true && Validation.isPasswordValid(cleanedPassword) == true {
            UserController.shared.createUserWith(firstName: firstName, lastName: lastName, email: cleanedEmail, password: cleanedPassword) { (result) in
                switch result {
                case .success(let user):
                    guard let user = user else { return }
                    UserController.shared.currentUser = user
                    self.transitionToAccount()
                case .failure(let error):
                    self.presentFailureAlertController(title: "Sign Up Failed", message: "Error creating user: \(error.localizedDescription)")
                    }
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField { (textFirstName) in
            textFirstName.placeholder = "Enter your first name here..."
        }
        alert.addTextField { (textLastName) in
            textLastName.placeholder = "Enter your last name here..."
        }
        alert.addTextField { (textEmail) in
            textEmail.placeholder = "Enter your email here..."
        }
        alert.addTextField { (textPassword) in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password here..."
        }
        alert.addAction(createAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
} // End of class

// MARK: - Extensions
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAddressTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
} // End of extension
