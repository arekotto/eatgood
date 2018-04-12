//
//  Cell.swift
//  Eat Good
//
//  Created by Arek Otto on 12/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation
import UIKit

class LargeFoodTableCell: UITableViewCell {
    
    @IBOutlet weak var wrappingView: UIView!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubisherLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wrappingView.layer.cornerRadius = 26
    }
    
    func setFoodImage(_ image: UIImage) {
        foodImageView?.image = image
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    func setup(with recipe: Recipe) {
        titleLabel.text = recipe.title
        pubisherLabel.text = recipe.publisher
        foodImageView?.image = nil
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
}
