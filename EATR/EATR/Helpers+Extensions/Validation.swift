//
//  Validation.swift
//  EATR
//
//  Created by Ian Becker on 9/10/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation

class Validation {
    
    static func isValidEmail(_ email: String) -> Bool {
      let emailTest = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,15}")
      return emailTest.evaluate(with: email)
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
} // End of class
