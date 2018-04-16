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
    
    func getRecipeDetailsTVC(recipe: Recipe, image: UIImage?, ingredients: [String]? = nil, shareActionSourceView: UIView? = nil) -> RecipeDetailsTVC {
        let recipeDetailsTVC = storyboard!.instantiateViewController(withIdentifier: "recipeDetailsTVC") as! RecipeDetailsTVC
        recipeDetailsTVC.setup(recipe: recipe, ingredients: ingredients, image: image) {
            self.shareRecipe($0, sourceView: shareActionSourceView ?? self.view)
        }
        return recipeDetailsTVC
    }
    
    func shareRecipe(_ recipe: Recipe, sourceView: UIView) {
        let activityItems = [URL(string: recipe.sourceUrl)!]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sourceView
        present(activityViewController, animated: true, completion: nil)
    }
}
