//
//  SignUpViewController.swift
//  EATR
//
//  Created by Ian Becker on 9/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import CoreLocation

class SignUpViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailAddressTextField.delegate = self
        passwordTextField.delegate = self
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func logInButtonTapped(_ sender: Any) {
        if emailAddressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            presentAlertController(title: "Sign In Failed", message: "Please fill in all fields")
        }
        
        let email = emailAddressTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                self.presentAlertController(title: "Sign In Failed", message: error.localizedDescription)
            } else {
                self.transitionToAccount()
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
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
                self.presentAlertController(title: "Sign Up Failed", message: "Please fill in all fields")
            }
            
            let cleanedPassword = createPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if Validation.isPasswordValid(cleanedPassword) == false {
                self.presentAlertController(title: "Sign Up Failed", message: "Please make sure your password is at least 8 characters, contains a special character, and a number.")
            }
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = createEmailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = createPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.presentAlertController(title: "Sign Up Failed", message: error.localizedDescription)
                } else {
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(user!.user.uid).setData(["email" : email, "firstname" : firstName, "lastname" : lastName, "uid" : user!.user.uid]) { (error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Sign Up Failed",
                                                          message: error?.localizedDescription,
                                                          preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: .default))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    self.transitionToAccount()
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
    
    // MARK: - Methods
    func transitionToAccount() {
        let accountViewController = (storyboard?.instantiateViewController(identifier: "AccountVC") as? AccountViewController)!
        
        let navigationController = UINavigationController.init(rootViewController: accountViewController)
        
        view.window?.rootViewController = navigationController
        view.window?.makeKeyAndVisible()
    }
    
    func presentAlertController(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
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
