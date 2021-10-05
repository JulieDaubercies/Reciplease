//
//  MockCoreDataStack.swift
//  RecipleaseTests
//
//  Created by DAUBERCIES on 05/10/2021.
//

import Reciplease
import Foundation
import CoreData

class MockCoreDataStack: CoreDataStack {
    
    convenience init() {
        self.init(modelName: "Reciplease")
    }
    
    override init(modelName: String) {
        super.init(modelName: modelName)
        let presistentStoreDescription = NSPersistentStoreDescription()
        presistentStoreDescription.type = NSInMemoryStoreType
        let container = NSPersistentContainer(name: modelName)
        container.persistentStoreDescriptions = [presistentStoreDescription]
        container.loadPersistentStores { storeDescriptor, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        self.persistentContainer = container
    }
}
