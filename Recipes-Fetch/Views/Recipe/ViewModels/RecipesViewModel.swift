//
//  RecipesViewModel.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/25/25.
//

import Foundation

@Observable
class RecipesViewModel {
    var dataError: RFError?
    var hasError = false
    
    var networkManager = NetworkManager()    
    var meals: [Meals] = []
    
    var cuisineList: [String] = []    
    var selectedCuisine = ""
    
    var searchText = ""
}
