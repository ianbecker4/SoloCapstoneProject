//
//  SignUpViewController.swift
//  EATR
//
//  Created by Ian Becker on 9/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

class SignUpViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Properties
    var locationManager: CLLocationManager?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user != nil {
//                self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
//                self.emailAddressTextField.text = nil
//                self.passwordTextField.text = nil
//            }
//        }
    }
    
    // MARK: - Actions
    @IBAction func logInButtonTapped(_ sender: Any) {
        guard let email = emailAddressTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {return}
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(title: "Sign In Failed",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Sign Up!", message: "Create your EATR account!", preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create Account!", style: .default) { (_) in
            
            let createEmailTextField = alert.textFields![0]
            let createPasswordTextField = alert.textFields![1]
            
            Auth.auth().createUser(withEmail: createEmailTextField.text!, password: createPasswordTextField.text!) { (user, error) in
                if error == nil {
                    Auth.auth().signIn(withEmail: self.emailAddressTextField.text!, password: self.passwordTextField.text!)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
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
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // Do work
                }
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
} // End of class

    // MARK: - Extensions
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailAddressTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        return true
    }
} // End of extension
