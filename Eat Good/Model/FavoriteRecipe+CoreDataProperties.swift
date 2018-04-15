//
//  FavoriteRecipe+CoreDataProperties.swift
//  Eat Good
//
//  Created by Arek Otto on 15/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//
//

import Foundation
import CoreData

extension FavoriteRecipe {
    
    static let entityName = "FavoriteRecipe"

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteRecipe> {
        return NSFetchRequest<FavoriteRecipe>(entityName: entityName)
    }
    
    @nonobjc public class func fetchRequest(withId id: String) -> NSFetchRequest<FavoriteRecipe> {
        let fetchRequest = NSFetchRequest<FavoriteRecipe>(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "recipeId == %@", id)
        return fetchRequest
    }

    @NSManaged public var recipeId: String
    @NSManaged public var publisher: String
    @NSManaged public var ingredients: [String]?
    @NSManaged public var userRating: Double
    @NSManaged public var publisherUrl: String
    @NSManaged public var sourceUrl: String
    @NSManaged public var imageUrl: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var title: String

}


