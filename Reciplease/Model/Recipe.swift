//
//  Recipe.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//


import Foundation

// MARK: - Welcome
struct Welcome: Decodable {
    let hits: [Hit]
    let links: WelcomeLinks
    
    enum CodingKeys: String, CodingKey {
        case links = "_links"
        case hits
    }
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe
}

// MARK: - Recipe
struct Recipe: Decodable {
    let label: String
    let image: String
    let ingredients: [Ingredient]
    let url: String
    let totalTime: Int
    let calories: Double
}

/// MARK: - Ingredient
struct Ingredient: Decodable {
    let text: String
    let food: String
}

// MARK: - WelcomeLinks
struct WelcomeLinks: Decodable {
    let next: Next
}

// MARK: - Next
struct Next: Decodable {
    let href: String    //nextpage
}
