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

class RestaurantController {
    
    static func fetchRestaurants(for searchTerm: String, latitude: Double, longitude: Double, completion: @escaping (Result<[Business], NetworkError>) -> Void) {
        
        let service = MoyaProvider<YelpService.RestaurauntProvider>()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        service.request(.search(term: searchTerm, latitude: latitude, longitude: longitude)) { (result) in
            switch result {
            case .success(let response):
                let topLevelJSON = try? jsonDecoder.decode(TopLevelJSON.self, from: response.data)
                let restaurants = topLevelJSON?.businesses
                // Try to get to categories
                let shuffledRestaurants = restaurants?.shuffled()
                return completion(.success(shuffledRestaurants?.evenlySpaced(length: 3) ?? []))
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func tenRandomRestaurants() {
        
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
