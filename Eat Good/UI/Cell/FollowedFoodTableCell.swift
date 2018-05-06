//
//  FollowedFoodTableCell.swift
//  Eat Good
//
//  Created by Arek Otto on 16/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import UIKit

class FollowedFoodTableCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var recipesWithImages = [(recipe: Recipe, image: UIImage?)]()
    private var recipeAction: ((_ recipe: Recipe, _ image: UIImage?) -> Void)!
    
    func setup(withRecipesWithImages recipesWithImages: [(recipe: Recipe, image: UIImage?)], recipeAction: @escaping (_ recipe: Recipe, _ image: UIImage?) -> Void) {
        self.recipesWithImages = recipesWithImages
        self.recipeAction = recipeAction
        collectionView.reloadSections([0])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesWithImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCollectionCell", for: indexPath) as! RecipeCollectionCell
        let recipeWithImage = recipesWithImages[indexPath.row]
        cell.setup(with: recipeWithImage.recipe)
        if let image = recipeWithImage.image {
            cell.setFoodImage(image)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipeWithImage = recipesWithImages[indexPath.row]
        recipeAction(recipeWithImage.recipe, recipeWithImage.image)
    }
    
    func showLoadingIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
