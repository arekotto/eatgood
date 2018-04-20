//
//  ScaledHeightImageView.swift
//  Eat Good
//
//  Created by Arek Otto on 16/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        guard let image = self.image else {
            return CGSize(width: -1.0, height: -1.0)
        }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let viewWidth = frame.size.width
        
        let ratio = viewWidth/imageWidth
        let scaledHeight = imageHeight * ratio
        
        return CGSize(width: viewWidth, height: scaledHeight)
    }
    
}
