//
//  ReviewTableViewCell.swift
//  EATR
//
//  Created by Ian Becker on 9/16/20.
//  Copyright © 2020 Ian Becker. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    // MARK: - Properties
    var review: Review? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Methods
    func updateViews() {
        guard let review = review else {return}
        itemLabel.text = review.itemName
        reviewLabel.text = review.review
    }
} // End of class 
