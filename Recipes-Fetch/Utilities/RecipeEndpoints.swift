//
//  RecipeEndpoints.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/25/25.
//

import Foundation

enum RecipeEndpoints: String {
    case allRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json",
    malformedRecipes = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json",
    emptyRecipe = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"
}
