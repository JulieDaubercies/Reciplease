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

    func createFavorite(name: String, time: String, calories: String, ingredients: [String], image: Data, ingredientsDetail: [String], url: String) {
        let addFavorite = FavoriteRecipe(context: managedObjectContext)
        addFavorite.name = name
        addFavorite.time = time
        addFavorite.calories = calories
        addFavorite.ingredients = ingredients
        addFavorite.image = image
        addFavorite.ingredientsDetail = ingredientsDetail
        addFavorite.url = url
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
//        do {
//            try managedObjectContext.save()
//            print("saved!")
//        } catch let error as NSError  {
//            print("Could not save \(error), \(error.userInfo)")
//        }
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
