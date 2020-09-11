//
//  User.swift
//  EATR
//
//  Created by Ian Becker on 9/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let firstname: String
    let lastname: String
    let email: String
    let uid: String
    
    init(firstname: String, lastname: String, email: String, uid: String) {
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.uid = uid
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any],
        let email = dict["email"] as? String,
        let firstname = dict["firstname"] as? String,
        let lastname = dict["lastname"] as? String
            else {return nil}
        
        self.uid = snapshot.key
        self.email = email
        self.firstname = firstname
        self.lastname = lastname
    }
} // End of struct
