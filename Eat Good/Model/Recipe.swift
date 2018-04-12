//
//  DishTO.swift
//  Eat Good
//
//  Created by Arek Otto on 12/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation

struct Recipe: Codable {
    var title: String
    var publisher: String
    var imageUrl: String?
    var publisherUrl: String
    var socialRank: Double
    var f2fUrl: String
    var sourceUrl: String
}
