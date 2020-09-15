//
//  RestaurantTableViewCell.swift
//  EATR
//
//  Created by Ian Becker on 9/9/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import AlamofireImage
import MapKit
import Firebase

protocol RestaurantDelegate: class {
    func favoriteButtonTapped(restaurant: Business)
}

class RestaurantTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantPriceLabel: UILabel!
    @IBOutlet weak var restaurantRatingLabel: UILabel!
    @IBOutlet weak var restaurantDistanceLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    // MARK: - Properties
    var restaurant: Business? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: RestaurantDelegate?
    
    // MARK: - Actions
    @IBAction func addToFavoritesButtonTapped(_ sender: Any) {
        guard let restaurant = restaurant else {return}
        self.delegate?.favoriteButtonTapped(restaurant: restaurant)
        saveFavorite()
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    @IBAction func getDirectionsButtonTapped(_ sender: Any) {
        guard let restaurant = restaurant else {return}
        
        let placemark = MKPlacemark(coordinate: restaurant.coordinates)
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = restaurant.name
        
        let options = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        
        MKMapItem.openMaps(with: [mapItem], launchOptions: options)
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let restaurant = restaurant,
            let url = restaurant.imageUrl
        else {return}
        self.restaurantImageView.af.setImage(withURL: url)
        self.restaurantNameLabel.text = self.restaurant?.name
        self.restaurantPriceLabel.text = self.restaurant?.price
        self.restaurantRatingLabel.text = (String(describing: self.restaurant?.rating))
        self.restaurantDistanceLabel.text = self.restaurant?.formattedDistance
    }
    
    func saveFavorite() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {return}
        
        guard let restaurant = restaurant else {return}
        let name = restaurant.name
        let price = restaurant.price
        let rating = restaurant.rating
        let lat = restaurant.coordinates.latitude
        let long = restaurant.coordinates.longitude
        
        let dict = ["favorites" : ["restaurantname" : name, "restaurantprice" : price, "restaurantrating" : rating, "restaurantlocation" : GeoPoint(latitude: lat, longitude: long)]]
        
        db.collection("users").document(user.uid).collection("favorites").addDocument(data: dict) { (error) in
            if let error = error {
                print("Error saving favorite: \(error.localizedDescription)")
            } else {
                print("Favorite successfully saved.")
            }
        }
    }
} // End of class 
