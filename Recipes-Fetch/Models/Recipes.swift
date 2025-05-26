//
//  Recipes.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/25/25.
//

import Foundation

struct Recipes: Codable {
    var recipes: [Meals]
}

struct Meals: Codable {
    var id: String
    var cuisine: String
    var name: String
    var photo: String
    
    enum CodingKeys: String, CodingKey {
        case photo = "photo_url_large", id = "uuid",
        name, cuisine
    }
}
