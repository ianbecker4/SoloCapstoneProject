//
//  Restaurant.swift
//  EATR
//
//  Created by Ian Becker on 9/9/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation

struct TopLevelJSON: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let rating: Double
    let price: String
    let imageUrl: URL
    let distance: Double
    let categories: [Category]
    
    static var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        return nf
    }
    
    var formattedDistance: String? {
        return Business.numberFormatter.string(from: distance as NSNumber)
    }
}

struct Category: Codable {
    let title: String
}
