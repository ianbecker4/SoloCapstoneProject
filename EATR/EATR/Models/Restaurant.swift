//
//  Restaurant.swift
//  EATR
//
//  Created by Ian Becker on 9/9/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import CoreLocation

struct TopLevelJSON: Codable {
    let businesses: [Business]
} // End of struct

struct Business: Codable {
    let id: String
    let name: String
    let rating: Double
    let price: String
    let imageUrl: URL?
    let distance: Double?
    let coordinates: CLLocationCoordinate2D
    let categories: [Category]?
    
    static var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        return nf
    }
    
    var formattedDistance: String? {
        guard let distance = distance else { return nil }
        
        return Business.numberFormatter.string(from: distance as NSNumber)
    }
} // End of struct

struct Category: Codable {
    let title: String
} // End of struct

extension CLLocationCoordinate2D: Codable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(latitude)
        try container.encode(longitude)
    }
} // End of extension
