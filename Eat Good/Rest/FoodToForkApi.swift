//
//  FoodToForkApi.swift
//  Eat Good
//
//  Created by Arek Otto on 12/04/2018.
//  Copyright © 2018 Arek Otto. All rights reserved.
//

import Foundation

struct FoodToForkApi {
    
    private static let key = Bundle.main.object(forInfoDictionaryKey: "APIKey") as! String
    
//    for debug
//    private static let key = "0822644115e106ceb90b5f5c3575e697"

    static func getSearchUrl(query: String? = nil, page: String? = nil) -> URL {
        var urlComponents = URLComponents(string: "http://food2fork.com/api/search")!
        var queryItems = [URLQueryItem(name: "key", value: key)]
        if query != nil {
            queryItems.append(URLQueryItem(name: "q", value: query!))
        }
        if page != nil {
            queryItems.append(URLQueryItem(name: "page", value: page!))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
    static func getRecipeURL(id: String) -> URL {
        var urlComponents = URLComponents(string: "http://food2fork.com/api/get")!
        urlComponents.queryItems = [URLQueryItem(name: "key", value: key), URLQueryItem(name: "rId", value: id)]
        return urlComponents.url!
    }
}
