//
//  CoreDataRecipleaseTests.swift
//  CoreDataRecipleaseTests
//
//  Created by DAUBERCIES on 30/09/2021.
//

import XCTest
@testable import Reciplease

class CoreDataRecipleaseTests: XCTestCase {


    // MARK: - Properties

    var coreDataStack: FakeCoreDataStack!
    var coreDataManager: CoreDataManager!

    //MARK: - Tests Life Cycle

    override func setUp() {
        super.setUp()
        coreDataStack = FakeCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }

    
    // MARK: - Tests

    func testAddTeskMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.controlFavorite(recipe: "My recipe")
       
    }
    
//    func testDeleteAllTasksMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
//        coreDataManager.createTask(name: "My Task")
//        coreDataManager.deleteAllTasks()
//        XCTAssertTrue(coreDataManager.tasks.isEmpty)
//    }

}
