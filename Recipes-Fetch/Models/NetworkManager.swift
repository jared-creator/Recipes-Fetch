//
//  NetworkManager.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/25/25.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    
    var meals: [Meals] = []
    
    func fetchRecipes() async throws -> [Meals] {
        guard let url = URL(string: RecipeEndpoints.allRecipes.rawValue) else { return [] }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return [] }
        
        do {
            let recipes = try JSONDecoder().decode(Recipes.self, from: data)
            meals = recipes.recipes
        } catch {
            print(error)
        }
        return meals
    }
}
