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
    
    static func fetchRestaurants(for searchTerm: String, with coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[Business], NetworkError>) -> Void) {
        
        let service = MoyaProvider<YelpService.RestaurauntProvider>()
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        service.request(.search(term: searchTerm, latitude: coordinate.latitude, longitude: coordinate.longitude)) { (result) in
            switch result {
            case .success(let response):
                let topLevelJSON = try? jsonDecoder.decode(TopLevelJSON.self, from: response.data)
                let restaurants = topLevelJSON?.businesses
                return completion(.success(restaurants ?? []))
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}
