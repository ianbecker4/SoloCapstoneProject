//
//  AccountViewController.swift
//  EATR
//
//  Created by Ian Becker on 9/10/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var favoriteRestaurantTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteRestaurantTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            self.performSegue(withIdentifier: "ToSignInVC", sender: nil)
        }
        
        updateUserInfo()
        UserController.shared.updateUserFavorites{
            self.favoriteRestaurantTableView.reloadData()
        }
        
        favoriteRestaurantTableView.delegate = self
        favoriteRestaurantTableView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "ToSignInVC", sender: nil)
        } catch {
            let alert = UIAlertController(title: "Sign Out Failed",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RestaurantController.shared.favoriteRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRestaurantCell", for: indexPath) as? FavoriteRestaurantTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        let restaurant = RestaurantController.shared.favoriteRestaurants[indexPath.row]
        cell.favoriteRestaurant = restaurant
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Favorites"
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReviewVC" {
            guard let indexPath = favoriteRestaurantTableView.indexPathForSelectedRow else { return }
            let destinationVC = segue.destination as? ReviewViewController
            let restaurantToSend = RestaurantController.shared.favoriteRestaurants[indexPath.row]
            destinationVC?.restaurant = restaurantToSend
        }
    }
    
    // MARK: - Methods
    func updateUserInfo() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            _ = db.collection("users").getDocuments() { (snapshot, error) in
                if let error = error {
                    print("error getting user: \(error)")
                } else {
                    if let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == userID}) {
                        guard let firstname = currentUserDoc["firstname"] as? String,
                        let lastname = currentUserDoc["lastname"] as? String,
                        let email = currentUserDoc["email"] as? String
                            else { return }
                        self.nameLabel.text = "\(firstname) \(lastname)"
                        self.emailLabel.text = email
                    }
                }
            }
        }
    }
} // End of class

// MARK: - Extensions
extension AccountViewController: FavoriteRestaurantDelegate {
    func removeFromFavoritesButtonTapped(restaurant: Business) {
        RestaurantController.shared.removeFromFavorites(withID: restaurant.id)
        self.favoriteRestaurantTableView.reloadData()
    }
} // End of extension
