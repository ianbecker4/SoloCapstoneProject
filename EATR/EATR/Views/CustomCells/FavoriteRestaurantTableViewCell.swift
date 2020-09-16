//
//  FavoriteRestaurantTableViewCell.swift
//  EATR
//
//  Created by Ian Becker on 9/11/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import MapKit
import Firebase

// MARK: - Protocol Method
protocol FavoriteRestaurantDelegate: class {
    func removeFromFavoritesButtonTapped(restaurant: Business)
}

class FavoriteRestaurantTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties
    var favoriteRestaurant: Business? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: FavoriteRestaurantDelegate?
    
    // MARK: - Actions
    @IBAction func removeFromFavoritesButtonTapped(_ sender: Any) {
        guard let restaurant = favoriteRestaurant else { return }
        
        self.delegate?.removeFromFavoritesButtonTapped(restaurant: restaurant)
    }
    
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        guard let favoriteRestaurant = favoriteRestaurant else { return }
        
        let placemark = MKPlacemark(coordinate: favoriteRestaurant.coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = favoriteRestaurant.name
        
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMaps(with: [mapItem], launchOptions: options)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let favoriteRestaurant = favoriteRestaurant else { return }
        
        restaurantNameLabel.text = favoriteRestaurant.name
        priceLabel.text = "Price level: \(self.favoriteRestaurant?.price ?? "")"
        ratingLabel.text = "Rating: \(self.favoriteRestaurant?.rating ?? 0.0)"
    }
} // End of class
