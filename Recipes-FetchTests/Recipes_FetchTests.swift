//
//  Recipes_FetchTests.swift
//  Recipes-FetchTests
//
//  Created by Jared Work on 5/27/25.
//

import Testing
@testable import Recipes_Fetch

struct Recipes_FetchTests {
    var network = NetworkManager()
    
    @Test func networkCallShouldReturnNonNil() async throws {
        let _ = try await network.fetchRecipes(with: RecipeEndpoints.allRecipes.rawValue)
        #expect(network.meals != nil)
    }
    
    @Test func networkCallWithEmptyArrayEndpointShouldReturnNil() async throws {
        let _ = try await network.fetchRecipes(with: RecipeEndpoints.emptyRecipe.rawValue)
        #expect(network.meals.isEmpty)
    }
    
    @Test func networkCallWithMalformedDataShouldThrowError() async throws {
        await #expect(throws: RFError.malFormedJSON) {
            try await network.fetchRecipes(with: RecipeEndpoints.malformedRecipes.rawValue)
        }
    }
    
    @Test func imageIsCachedAfterFirstNetworkcall() async throws {
        let meal = try await network.fetchRecipes()
        for i in 0..<meal.count {
            #expect(network.getCachedImage(for: meal[i]) != nil)
        }
    }

}
