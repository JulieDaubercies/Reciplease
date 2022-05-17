//
//  DetailViewModel.swift
//  Reciplease
//
//  Created by DAUBERCIES on 30/04/2022.
//

import Foundation
import UIKit

class DetailViewModel {
    
    // MARK: - Properties
    
    static let shared = DetailViewModel()
    
    var recipeIndexPath: Int?
    var searchResponse: Bool!
    var recipeService = [Hit]()
    var isFavourited: Box<Bool> = Box(true)
    var moveView: Box<Bool> = Box(false)
    var coreDataManager: CoreDataManager?
    
    var circleImage: UIImage! {
        guard let index = recipeIndexPath else { return UIImage(named: "meal")! }
        var image: UIImage?
        if searchResponse {
            if let imageToLoad =  recipeService[index].recipe.image.data {
                image  = UIImage(data: imageToLoad)?.circleMask
            }
        } else {
            if let imageToLoad = coreDataManager?.favorite[index].image {
                image = UIImage(data: imageToLoad)?.circleMask
            }
        }
        return image
    }
    
    var title: String! {
        guard let index = recipeIndexPath else { return "Recipe" }
        var recipeTitle: String?
        if searchResponse {
            recipeTitle = recipeService[index].recipe.label
        } else {
            recipeTitle = coreDataManager?.favorite[index].name
        }
         return recipeTitle
    }
    
    var url: URL? {
        var recipeUrl: String = ""
        guard let index = recipeIndexPath else { return nil }
        if searchResponse {
            recipeUrl = recipeService[index].recipe.url
        } else {
            guard let url = coreDataManager?.favorite[index].url else { return nil }
            recipeUrl = url
        }
        return URL(string: recipeUrl)
    }
    
    var numberOfRows: Int? {
        guard let index = recipeIndexPath else { return 0 }
        if searchResponse {
            return recipeService[index].recipe.ingredients.count
        } else {
            guard let favoriteRecipeCount = coreDataManager?.favorite[index].ingredientsDetail?.count else { return 0 }
            return favoriteRecipeCount
        }
    }
    
    var ingredientSearchListRecipe: [Ingredient]? {
        guard let index = recipeIndexPath else { return nil }
        var informations: [Ingredient]?
        informations = recipeService[index].recipe.ingredients
        return informations
    }
    
    var ingredientListFavoriteRecipe: [String]? {
        guard let index = recipeIndexPath else { return nil }
        var informations: [String]?
        informations = coreDataManager?.favorite[index].ingredientsDetail
        return informations
    }
    
    // MARK: - Init
    
    init() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
    }
    
    // MARK: - Methods
    
    func controlFavoriteStatus() {
        if !searchResponse {
            isFavourited.value = true
        } else {
            isFavourited.value = false
        }
        if searchResponse {
            if coreDataManager?.controlFavorite(recipe: title ?? "recette") == true {
                isFavourited.value = true
            }
        }
    }
    
    func favoriteChange() {
        if searchResponse && !isFavourited.value {
            guard let index = recipeIndexPath else { return }
            coreDataManager?.createFavorite(recipe: recipeService[index].recipe)
            moveView.value = false
            isFavourited.value = true
        } else  if searchResponse && isFavourited.value {
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            moveView.value = false
            isFavourited.value = false
        } else  if !searchResponse && isFavourited.value {
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            moveView.value = true
            isFavourited.value = false
        }
    }
}
