//
//  ImageTableCell.swift
//  Eat Good
//
//  Created by Arek Otto on 16/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class ImageTableCell: UITableViewCell {
    
    @IBOutlet weak var foodImageView: ScaledHeightImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        foodImageView.layer.cornerRadius = 10
    }
}
