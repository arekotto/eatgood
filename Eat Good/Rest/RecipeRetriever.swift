//
//  RecipeRetriever.swift
//  Eat Good
//
//  Created by Arek Otto on 12/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation

class RecipeSearchRetriever: RequestSubmitter {
    
    convenience init() {
        self.init(session: URLSession.shared)
    }
    
    /// The completion is called on a backgroud thread.
    func retrieveRecipes(page: Int, searchedString: String? = nil, completion: @escaping (_: [Recipe]?) -> Void) {
        let request = URLRequest(url: FoodToForkApi.getSearchUrl(query: searchedString, page: String(page)))
        submitRequest(request, parseTo: SearchResultTO.self) {
            completion($0?.recipes)
        }
    }
    
    struct SearchResultTO: Codable {
        var count: Int
        var recipes: [Recipe]
    }
}
