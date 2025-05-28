//
//  NetworkManager.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/25/25.
//

import Foundation
import SwiftUI

class NetworkManager {
    static var shared = NetworkManager()
    
    init() {}
    
    var meals: [Meals] = []
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        return cache
    }()
    
    func fetchRecipes(with urlType: String? = nil) async throws -> [Meals] {
        guard let url = URL(string: urlType ?? RecipeEndpoints.allRecipes.rawValue) else {
            throw RFError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RFError.invalidResponse
        }
        
        do {
            let recipes = try JSONDecoder().decode(Recipes.self, from: data)
            meals = recipes.recipes
            for i in 0..<meals.count {
                try await cacheImage(from: meals[i])
            }
        } catch {
            throw RFError.malFormedJSON
        }
        return meals
    }
    
    private func cacheImage(from meals: Meals) async throws {
        guard let imageURL = URL(string: meals.photo) else {
            throw RFError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: imageURL)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw RFError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw RFError.invalidData
        }
        
        imageCache.setObject(image, forKey: meals.id as NSString)
    }
    
    func getCachedImage(for meal: Meals) -> UIImage? {
        if let returnedImage = imageCache.object(forKey: meal.id as NSString) {
            return returnedImage
        } else {
            return nil
        }
    }
}
