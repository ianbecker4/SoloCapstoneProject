//
//  UserController.swift
//  EATR
//
//  Created by Ian Becker on 9/7/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import Firebase
import CoreLocation

class UserController {
    
    // MARK: - Shared Instance
    static let shared = UserController()
    
    // MARK: - SoT
    var currentUser: User?
    
    // MARK: - CRUD
    func createUserWith(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                completion(.failure(.firebaseError(error)))
            } else {
                guard let user = user else { return completion(.failure(.couldNotUnwrap))}
                
                let newUser = User(firstname: firstName, lastname: lastName, email: email, uid: user.user.uid)
                
                let db = Firestore.firestore()
                
                db.collection("users").document(user.user.uid).setData(["email" : email, "firstname" : firstName, "lastname" : lastName, "uid" : user.user.uid]) { (error) in
                    if let error = error {
                        print("Error saving user: \(error.localizedDescription)")
                        completion(.failure(.noUser))
                    } else {
                        print("User saved successfully")
                        completion(.success(newUser))
                    }
                }
            }
        }
    }
    
    func signInUserWith(email: String, password: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            if let error = error, user == nil {
                completion(.failure(.firebaseError(error)))
            } else {
                guard let user = user else { return completion(.failure(.couldNotUnwrap))}
                let loggedInUser = User(firstname: self.currentUser?.firstname ?? "", lastname: self.currentUser?.lastname ?? "", email: email, uid: user.user.uid)
                print("User signed in successfully")
                completion(.success(loggedInUser))
            }
        }
    }
    
    func updateUserFavorites(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else { return completion() }
        
        db.collection("users").document(user.uid).collection("favorites").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting favorites: \(error.localizedDescription)")
                completion()
            } else if let snapshot = querySnapshot {
                let favorites: [Business] = snapshot.documents.compactMap { document in
                    guard let id = document["documentID"] as? String,
                        let name = document["restaurantname"] as? String,
                        let price = document["restaurantprice"] as? String,
                        let rating = document["restaurantrating"] as? Double,
                        let location = document["restaurantlocation"] as? GeoPoint,
                        let lat = CLLocationDegrees(exactly: location.latitude),
                        let long = CLLocationDegrees(exactly: location.longitude)
                        else {return nil}
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    return Business(id: id, name: name, rating: rating, price: price, imageUrl: nil, distance: nil, coordinates: coordinates, categories: nil)
                }
                RestaurantController.shared.favoriteRestaurants = favorites
                completion()
            }
        }
    }
} // End of class
