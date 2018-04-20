//
//  RecipeCollectionCell.swift
//  Eat Good
//
//  Created by Arek Otto on 16/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class RecipeCollectionCell: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var wrappingView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wrappingView.layer.cornerRadius = 5
    }
    
    func setFoodImage(_ image: UIImage) {
        foodImageView?.image = image
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func setup(with recipe: Recipe) {
        titleLabel.text = recipe.title
        foodImageView?.image = nil
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
}
