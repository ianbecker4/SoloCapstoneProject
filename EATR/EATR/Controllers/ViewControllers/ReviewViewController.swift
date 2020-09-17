//
//  ReviewViewController.swift
//  EATR
//
//  Created by Ian Becker on 9/16/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit
import Firebase

class ReviewViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var dateLastVisitedPicker: UIDatePicker!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Properties
    var restaurant: Business? {
        didSet {
            loadViewIfNeeded()
            guard let restaurant = restaurant else { return }
            self.restaurantNameLabel.text = restaurant.name
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let restaurant = restaurant else { return }
        updateReviews(for: restaurant) {
            self.reviewTableView.reloadData()
        }
        
        updateDate()

        reviewTableView.delegate = self
        reviewTableView.dataSource = self
    }
    
    // MARK: - Actions
    @IBAction func reviewButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Review an item from this business!", message: "Enter the item name and your review below!", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter item name here..."
        }
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter your review here..."
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let itemName = alertController.textFields?[0].text, let reviewText = alertController.textFields?[1].text, let restaurant = self.restaurant, !itemName.isEmpty, !reviewText.isEmpty else { return }
            
            ReviewController.shared.createReview(for: itemName, reviewText: reviewText, restaurant: restaurant)
            self.reviewTableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .medium
        
        let dateAsString = dateFormatter.string(from: dateLastVisitedPicker.date)
        
        dateLabel.text = dateAsString
        
        guard let restaurant = restaurant else { return }
        
        guard let user = Auth.auth().currentUser else { return }
        
        let dict: [String : Any] = ["datelastvisited" : dateAsString]
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("favorites").document(restaurant.id).updateData(dict) { (error) in
            if let error = error {
                print("Error saving date: \(error.localizedDescription)")
            } else {
                print("Saved date successfully.")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReviewController.shared.reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCell", for: indexPath) as? ReviewTableViewCell else { return UITableViewCell() }
        
        let reviewToDisplay = ReviewController.shared.reviews[indexPath.row]
        cell.review = reviewToDisplay
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Item Reviews"
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
    func updateReviews(for restaurant: Business, completion: @escaping () -> Void) {
        guard let user = Auth.auth().currentUser else { return completion() }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("favorites").document(restaurant.id).collection("reviews").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting reviews: \(error.localizedDescription)")
                completion()
            } else if let snapshot = querySnapshot {
                let reviews: [Review] = snapshot.documents.compactMap { document in
                    guard let itemName = document["itemname"] as? String,
                        let reviewText = document["itemreview"] as? String else { return nil }
                    
                    return Review(itemName: itemName, review: reviewText)
                }
                ReviewController.shared.reviews = reviews
                completion()
            }
        }
    }
    
    func updateDate() {
        guard let user = Auth.auth().currentUser else { return  }
        
        guard let restaurant = restaurant else { return }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("favorites").document(restaurant.id).getDocument { (document, error) in
            if let error = error {
                print("Error getting date: \(error.localizedDescription)")
            } else if let document = document, document.exists {
                guard let date = document.get("datelastvisited") as? String else { return }
                self.dateLabel.text = date
            }
        }
    }
} // End of class 
