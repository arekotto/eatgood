//
//  RecipeDetailsPresenter.swift
//  Eat Good
//
//  Created by Arek Otto on 14/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    
    func presentAlertWithOkAction(title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
        present(alertController, animated: true)
    }
    
    func pushRecipeDetailsTVC(recipe: Recipe, image: UIImage?, ingredients: [String]? = nil) {
        guard let recipeDetailsTVC = storyboard?.instantiateViewController(withIdentifier: "recipeDetailsTVC") as? RecipeDetailsTVC else {
            return
        }
        recipeDetailsTVC.setup(recipe: recipe, ingredients: ingredients, image: image)
        navigationController?.pushViewController(recipeDetailsTVC, animated: true)
    }
}
