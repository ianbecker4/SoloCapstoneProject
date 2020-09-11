//
//  FavoriteRestaurantTableViewCell.swift
//  EATR
//
//  Created by Ian Becker on 9/11/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class FavoriteRestaurantTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - Properties
    var favoriteRestaurant: (name: String, price: String, rating: String)? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    @IBAction func removeFromFavoritesButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let favoriteRestaurant = favoriteRestaurant else {return}
        restaurantNameLabel.text = favoriteRestaurant.name
        priceLabel.text = favoriteRestaurant.price
        ratingLabel.text = favoriteRestaurant.rating
    }
}
