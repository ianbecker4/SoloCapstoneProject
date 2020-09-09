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
    }
    
    // MARK: - Actions
    @IBAction func refreshButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath) as? RestaurantTableViewCell else {return UITableViewCell()}

        let restaurantToDisplay =
        
        return cell
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

extension RestaurantListTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = restaurantSearchBar.text, !searchTerm.isEmpty else {return}
        
        RestaurantController.fetchRestaurants(for: searchTerm, with: <#T##CLLocationCoordinate2D#>, completion: <#T##(Result<[Business], NetworkError>) -> Void#>)
    }
}
