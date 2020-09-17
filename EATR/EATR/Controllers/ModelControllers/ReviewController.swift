//
//  ReviewController.swift
//  EATR
//
//  Created by Ian Becker on 9/16/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import Foundation
import Firebase

class ReviewController {
    
    // MARK: - Shared Instance
    static let shared = ReviewController()
    
    // MARK: - SoT
    var reviews: [Review] = []
    
    // MARK: - CRUD
    func createReview(for item: String, reviewText: String, restaurant: Business) {
        let review = Review(itemName: item, review: reviewText)
        
        reviews.append(review)
        
        guard let user = Auth.auth().currentUser else { return }
        
        let itemName = review.itemName
        let reviewText = review.review
        let restaurantID = restaurant.id
        
        let dict: [String : Any] = ["itemname" : itemName, "itemreview" : reviewText]
        
        let db = Firestore.firestore()
        
        db.collection("users").document(user.uid).collection("favorites").document(restaurantID).collection("reviews").document().setData(dict) { (error) in
            if let error = error {
                print("Error saving review: \(error.localizedDescription)")
            } else {
                print("Review successfuly saved.")
            }
        }
    }
    
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
} // End of class
