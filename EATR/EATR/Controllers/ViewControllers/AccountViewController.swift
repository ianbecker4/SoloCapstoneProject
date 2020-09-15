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
    
    // MARK: - Properties
    

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
        updateUserFavorites{
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRestaurantCell", for: indexPath) as? FavoriteRestaurantTableViewCell else {return UITableViewCell()}
        
        let restaurant = RestaurantController.shared.favoriteRestaurants[indexPath.row]
        cell.favoriteRestaurant = restaurant
        
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Methods
    func updateUserInfo() {
        let db = Firestore.firestore()
        
        if let userID = Auth.auth().currentUser?.uid {
            
            _ = db.collection("users").getDocuments() { (snapshot, error) in
                if let error = error {
                    print("error getting documents: \(error)")
                } else {
                    if let currentUserDoc = snapshot?.documents.first(where: {($0["uid"] as? String) == userID}) {
                        let firstname = currentUserDoc["firstname"] as! String
                        let lastname = currentUserDoc["lastname"] as! String
                        let email = currentUserDoc["email"] as! String
                        self.nameLabel.text = "\(firstname) \(lastname)"
                        self.emailLabel.text = email
                    }
                }
            }
        }
    }
    
    func updateUserFavorites(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {return completion()}
        
        db.collection("users").document(user.uid).collection("favorites").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting favorites: \(error.localizedDescription)")
                completion()
            } else if let snapshot = querySnapshot {
                let favorites: [Business] = snapshot.documents.compactMap { document in
                    guard let name = document["restaurantname"] as? String,
                        let price = document["restaurantprice"] as? String,
                        let rating = document["restaurantrating"] as? Double,
                        let location = document["restaurantlocation"] as? GeoPoint,
                        let lat = CLLocationDegrees(exactly: location.latitude),
                        let long = CLLocationDegrees(exactly: location.longitude)
                        else {return nil}
                    let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    return Business(id: nil, name: name, rating: rating, price: price, imageUrl: nil, distance: nil, coordinates: coordinates, categories: nil)
                }
                RestaurantController.shared.favoriteRestaurants = favorites
                completion()
            }
        }
    }
}

extension AccountViewController: FavoriteRestaurantDelegate {
    func removeFromFavoritesButtonTapped(indexPath: IndexPath, restaurant: Business) {
        RestaurantController.shared.favoriteRestaurants.remove(at: indexPath.row)
        self.favoriteRestaurantTableView.reloadData()
    }
}
