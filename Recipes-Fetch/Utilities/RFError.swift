//
//  RFError.swift
//  Recipes-Fetch
//
//  Created by Jared Work on 5/26/25.
//

import Foundation

//Custom errors RF stands for Recipe Fetch, abbreviation of project name
enum RFError: String, Error {
    case invalidURL = "This URL is not valid. Please try again.",
    invalidResponse = "Invalide response from the server. Please try again.",
    malFormedJSON = "The list of recipes is incomplete.",
    invalidData = "Image data is not valid."
    
}
