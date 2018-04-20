//
//  FollowedFoodManager.swift
//  Eat Good
//
//  Created by Arek Otto on 13/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation

class FollowedFoodManager {
    static var all: [String] = (UserDefaults.standard.object(forKey: "followedFoodNames") as? [String]) ?? defaultFoodNames {
        didSet {
            UserDefaults.standard.set(all, forKey: "followedFoodNames")
        }
    }
    
    private static var defaultFoodNames: [String] {
        return ["breakfast", "dinner", "desert"]
    }
}
