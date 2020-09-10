//
//  RestaurantTableViewCell.swift
//  EATR
//
//  Created by Ian Becker on 9/9/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPriceLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    
    // MARK: - Properties
    var restaurant: Business? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let restaurant = restaurant else {return}
        self.restaurantImageView.af.setImage(withURL: restaurant.imageUrl)
        self.restaurantNameLabel.text = self.restaurant?.name
        self.restaurantPriceLabel.text = self.restaurant?.price
        self.restaurantRatingLabel.text = (String(describing: self.restaurant?.rating))
        self.restaurantDistanceLabel.text = self.restaurant?.formattedDistance
    }
} // End of class 
