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
    var restaurant: Business? {
        didSet {
            updateFavoriteRestaurants()
        }
    }
    
    var favoriteRestaurants: [(name: String, price: String, rating: String)] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "SignUpVC", bundle: .main)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
            }
        }
        
        updateUserInfo()
        
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
        favoriteRestaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRestaurantCell", for: indexPath) as? FavoriteRestaurantTableViewCell else {return UITableViewCell()}
        
        let restaurant = favoriteRestaurants[indexPath.row]
        
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
    
    func updateFavoriteRestaurants() {
        guard let restaurant = self.restaurant else {return}
    }
}
