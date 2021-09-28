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

    var tasks: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        guard let tasks = try? managedObjectContext.fetch(request) else { return [] }
        return tasks
    }

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage Task Entity

    func createTask(name: String, time: String, calories: String, ingredients: String, image: String, ingredientsDetail: String) {
        let task = FavoriteRecipe(context: managedObjectContext)
        task.name = name
        task.time = time
        task.calories = calories
        task.ingredients = ingredients
        task.image = image
        task.ingredientsDetail = ingredientsDetail
        coreDataStack.saveContext()
    }
    
    func deleteOneTask(recipe: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
//        let predicate = NSPredicate(format: recipe)
//        fetchRequest.predicate = predicate
        let result = try? managedObjectContext.fetch(fetchRequest)
        let resultData = result as! [FavoriteRecipe]
        for object in resultData {
            if object.name == recipe {
                managedObjectContext.delete(object)
            }
        }
        do {
            try managedObjectContext.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func controlFavorite(recipe: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        // predicate
        let result = try? managedObjectContext.fetch(fetchRequest)
        let resultData = result as! [FavoriteRecipe]
        for object in resultData {
            if object.name == recipe {
                return true
            }
        }
        return false
    }

}

