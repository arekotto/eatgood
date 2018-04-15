//
//  SmallFoodTableCell.swift
//  Eat Good
//
//  Created by Arek Otto on 15/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class SmallFoodTableCell: UITableViewCell {

    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodImageView.layer.cornerRadius = 10
    }

    func setup(title: String?, publisher: String?, image: UIImage? = nil) {
        titleLabel.text = title
        publisherLabel.text = publisher
        foodImageView.image = image
    }
}
