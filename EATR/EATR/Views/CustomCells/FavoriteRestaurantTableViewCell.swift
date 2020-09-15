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

protocol FavoriteRestaurantDelegate: class {
    func removeFromFavoritesButtonTapped(indexPath: IndexPath, restaurant: Business)
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
    var indexPath: IndexPath?
    
    // MARK: - Actions
    @IBAction func removeFromFavoritesButtonTapped(_ sender: Any) {
        guard let restaurant = favoriteRestaurant else {return}
        guard let indexPath = indexPath else {return}
        self.delegate?.removeFromFavoritesButtonTapped(indexPath: indexPath, restaurant: restaurant)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        guard let favoriteRestaurant = favoriteRestaurant else {return}
        
        let placemark = MKPlacemark(coordinate: favoriteRestaurant.coordinates)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = favoriteRestaurant.name
        
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMaps(with: [mapItem], launchOptions: options)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let favoriteRestaurant = favoriteRestaurant else {return}
        restaurantNameLabel.text = favoriteRestaurant.name
        priceLabel.text = favoriteRestaurant.price
        ratingLabel.text = "\(favoriteRestaurant.rating)"
    }
} // End of class
