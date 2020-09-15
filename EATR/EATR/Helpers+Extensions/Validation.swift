//
//  Validation.swift
//  EATR
//
//  Created by Ian Becker on 9/10/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation

class Validation {
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
} // End of class
