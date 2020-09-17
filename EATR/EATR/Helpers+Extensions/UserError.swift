//
//  UserError.swift
//  EATR
//
//  Created by Ian Becker on 9/17/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation

enum UserError: Error {
    case firebaseError(Error)
    case noUserLoggedIn
    case couldNotUnwrap
    case noUser
    
    
    var errorDescription: String {
        switch self {
        case .firebaseError(let error):
            return error.localizedDescription
        case .noUserLoggedIn:
            return "there is no user logged into firebase"
        case .couldNotUnwrap:
            return "Could not unwrap user from returned records"
        case .noUser:
            return "no User Found"
        }
    }
}
