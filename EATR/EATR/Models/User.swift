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
    
    let email: String
    let uid: String
    
    init(authData: Firebase.User) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(email: String, uid: String) {
        self.email = email
        self.uid = uid
    }
} // End of struct
