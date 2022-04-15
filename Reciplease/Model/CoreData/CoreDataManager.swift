//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import Foundation
import CoreData

final class CoreDataManager {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext

    var favorite: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        guard let addFavorite = try? managedObjectContext.fetch(request) else { return [] }
        return addFavorite
    }

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage Favorite Entity
    
    func createFavorite(recipe: Recipe) {
        let addFavorite = FavoriteRecipe(context: managedObjectContext)
        addFavorite.name = recipe.label
        addFavorite.time = String(recipe.totalTime)
        let kcal = Int(recipe.calories)
        addFavorite.calories = String(kcal)
        let ingredients = recipe.ingredients.map { $0.food }
        addFavorite.ingredients = ingredients
        guard let image = recipe.image.data else { return }
        addFavorite.image = image
        let detailIngredients = recipe.ingredients.map { $0.text }
        addFavorite.ingredientsDetail = detailIngredients
        addFavorite.url = recipe.url
        coreDataStack.saveContext()
    }
    
    func deleteOneFavorite(recipe: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        let predicate = NSPredicate(format: "name == '\(recipe)'")
        fetchRequest.predicate = predicate
        let result = try? managedObjectContext.fetch(fetchRequest)
        let resultData = result as! [FavoriteRecipe]
        for object in resultData {
            managedObjectContext.delete(object)
        }
        coreDataStack.saveContext()
    }

    func controlFavorite(recipe: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        let predicate = NSPredicate(format: "name == '\(recipe)'")
        fetchRequest.predicate = predicate
        let result = try? managedObjectContext.fetch(fetchRequest)
        let resultData = result as! [FavoriteRecipe]
        for _ in resultData { return true }
        return false
    }
}
