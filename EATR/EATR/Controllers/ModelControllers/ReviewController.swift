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
    
    static let shared = ReviewController()
    
    var reviews: [Review] = []
    
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
} // End of class
