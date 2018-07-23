//
//  FollowedFoodManager.swift
//  Eat Good
//
//  Created by Arek Otto on 13/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation

class FollowedFoodManager {
    
    private init() {}
    
    static let shared: FollowedFoodManager = FollowedFoodManager()
    
    private let foodKey = "followedFoodNames"
    
    var all: [String] {
        get {
            return UserDefaults.standard.object(forKey: foodKey) as? [String] ?? defaultFoodNames
        }
        set {
            UserDefaults.standard.set(newValue, forKey: foodKey)
        }
    }
    
    private var defaultFoodNames: [String] {
        return ["breakfast", "dinner", "dessert"]
    }
}
