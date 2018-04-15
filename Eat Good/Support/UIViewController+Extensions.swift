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
    func pushRecipeDetailsTVC(recipe: Recipe, image: UIImage?) {
        guard let recipeDetailsTVC = storyboard?.instantiateViewController(withIdentifier: "recipeDetailsTVC") as? RecipeDetailsTVC else {
            return
        }
        recipeDetailsTVC.setup(with: recipe, and: image)
        navigationController?.pushViewController(recipeDetailsTVC, animated: true)
    }
}
