//
//  RestaurantController.swift
//  EATR
//
//  Created by Ian Becker on 9/9/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import Moya
import CoreLocation
import Firebase

class RestaurantController {
    
    static let shared = RestaurantController()
    
    var favoriteRestaurants: [Business] = []
    
    func fetchRestaurants(for searchTerm: String, latitude: Double, longitude: Double, completion: @escaping (Result<[Business], NetworkError>) -> Void) {
        
        let service = MoyaProvider<YelpService.RestaurauntProvider>()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        service.request(.search(term: searchTerm, latitude: latitude, longitude: longitude)) { (result) in
            switch result {
            case .success(let response):
                let topLevelJSON = try? jsonDecoder.decode(TopLevelJSON.self, from: response.data)
                let restaurants = topLevelJSON?.businesses
                let shuffledRestaurants = restaurants?.shuffled()
                return completion(.success(shuffledRestaurants?.evenlySpaced(length: 3) ?? []))
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func saveFavorite(restaurant: Business) {
        guard let user = Auth.auth().currentUser else { return }
        
        favoriteRestaurants.append(restaurant)
        
        let name = restaurant.name
        let price = restaurant.price
        let rating = restaurant.rating
        let restaurantID = restaurant.id
        let lat = restaurant.coordinates.latitude
        let long = restaurant.coordinates.longitude
        
        let dict: [String : Any] = ["restaurantname" : name, "restaurantprice" : price, "restaurantrating" : rating, "restaurantlocation" : GeoPoint(latitude: lat, longitude: long), "documentID" : restaurantID]
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("favorites").document(restaurantID).setData(dict) { (error) in
            if let error = error {
                print("Error saving favorite: \(error.localizedDescription)")
            } else {
                print("Favorite successfully saved.")
            }
        }
    }
    
    func removeFromFavorites(withID id: String) {
        guard let index = favoriteRestaurants.firstIndex(where: {$0.id == id}),
            let user = Auth.auth().currentUser
            else { return }
        
        favoriteRestaurants.remove(at: index)
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("favorites").document(id).delete() { (error) in
            if let error = error {
                print("Error saving favorite: \(error.localizedDescription)")
            } else {
                print("Favorite successfully deleted.")
            }
        }
    }
} // End of class

extension Array {
    func evenlySpaced(length: Int) -> [Element] {
        guard length < self.count else { return self }
        
        let takeIndex = (self.count / length) - 1
        let nextArray = Array(self.dropFirst(takeIndex + 1))
        return [self[takeIndex]] + nextArray.evenlySpaced(length: length - 1)
    }
} // End of extension
