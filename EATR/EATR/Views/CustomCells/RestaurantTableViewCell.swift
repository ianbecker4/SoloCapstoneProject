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
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantPriceLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    
    // MARK: - Properties
    var restaurant: Business?
    var category: Category?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Actions
    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Methods
    func updateViews(with restaurant: Business, category: Category) {
        self.restaurant = restaurant
        self.category = category
        restaurantImageView.af.setImage(withURL: restaurant.imageUrl)
        restaurantNameLabel.text = restaurant.name
        restaurantCategoryLabel.text = category.title
        restaurantPriceLabel.text = restaurant.price
        restaurantRatingLabel.text = "\(restaurant.rating)"
        restaurantDistanceLabel.text = restaurant.formattedDistance
    }
}
