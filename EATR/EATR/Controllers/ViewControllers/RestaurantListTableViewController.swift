//
//  RestaurantListTableViewController.swift
//  EATR
//
//  Created by Ian Becker on 9/9/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import CoreLocation

class RestaurantListTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantSearchBar: UISearchBar!
    
    // MARK: - Properties
    var restaurants: [Business] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantSearchBar.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        guard let searchTerm = restaurantSearchBar.text, !searchTerm.isEmpty else { return }
        
        guard let lat = LocationManager.shared.locationManager.location?.coordinate.latitude,
            let long = LocationManager.shared.locationManager.location?.coordinate.longitude else { return }
        
        RestaurantController.shared.fetchRestaurants(for: searchTerm, latitude: lat, longitude: long) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let restaurants):
                    self.restaurants = restaurants
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as? RestaurantTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        let restaurant = self.restaurants[indexPath.row]
        cell.restaurant = restaurant
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 2
    }
} // End of class

// MARK: - Extensions
extension RestaurantListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = restaurantSearchBar.text, !searchTerm.isEmpty else { return }
        
        guard let lat = LocationManager.shared.locationManager.location?.coordinate.latitude,
            let long = LocationManager.shared.locationManager.location?.coordinate.longitude else { return }
        
        RestaurantController.shared.fetchRestaurants(for: searchTerm, latitude: lat, longitude: long) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let restaurants):
                    self.restaurants = restaurants
                    print("\(restaurants)")
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
} // End of extension

extension RestaurantListTableViewController: RestaurantDelegate {
    func favoriteButtonTapped(restaurant: Business) {
        RestaurantController.shared.saveFavorite(restaurant: restaurant)
    }
} // End of extension
