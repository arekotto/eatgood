//
//  FavoriteRecipe+Extensions.swift
//  Eat Good
//
//  Created by Arek Otto on 15/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation
import UIKit

extension FavoriteRecipe {
    var image: UIImage? {
        get {
            return imageData != nil ? UIImage(data: imageData!) : nil
        }
        set {
            imageData = newValue != nil ? newValue!.pngData() : nil
        }
    }
}

extension FavoriteRecipe {
    func update(basedOn recipe: Recipe, dateAdded: Date, ingredients: [String]?, image: UIImage?) {
        self.ingredients = ingredients
        self.image = image
        self.dateAdded = dateAdded
        recipeId = recipe.recipeId
        publisher = recipe.publisher
        userRating = recipe.socialRank
        publisherUrl = recipe.publisherUrl
        sourceUrl = recipe.sourceUrl
        title = recipe.title
        imageUrl = recipe.imageUrl
    }
    
    func extractRecipe() -> Recipe {
        return Recipe(recipeId: recipeId, title: title, publisher: publisher, imageUrl: imageUrl, publisherUrl: publisherUrl, socialRank: userRating, sourceUrl: sourceUrl)
    }
}
