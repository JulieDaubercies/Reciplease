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
    
    var isFavourited: Box<Bool> = Box(true)
    private var coreDataManager: CoreDataManager?
    
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
    
    var moveView: Box<Bool> = Box(false)
    
    func favoriteChange() {
        if searchResponse && !isFavourited.value {
            print(1)
            guard let index = recipeIndexPath else { return }
            coreDataManager?.createFavorite(recipe: recipeService[index].recipe)
            moveView.value = false
            isFavourited.value = true
        } else  if searchResponse && isFavourited.value {
            print(2)
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            moveView.value = false
            isFavourited.value = false
        } else  if !searchResponse && isFavourited.value {
            print(3)
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            moveView.value = true
            isFavourited.value = false
        }
    }
}
