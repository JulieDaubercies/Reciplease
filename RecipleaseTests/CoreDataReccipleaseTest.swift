//
//  CoreDataReccipleaseTest.swift
//  RecipleaseTests
//
//  Created by DAUBERCIES on 05/10/2021.
//

import XCTest
@testable import Reciplease

class CoreDataRecipleaseTests: XCTestCase {


    // MARK: - Properties

    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!

    //MARK: - Tests Life Cycle

    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }

    
    // MARK: - Tests

    func testCreateFavoriteMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        let urlImage = "https://food52.com/recipes/72140-grated-tomato"
        let image = urlImage.data!
        coreDataManager.createFavorite(name: "test", time: "", calories: "", ingredients: [""], image: image, ingredientsDetail: [""], url: "")
        
        XCTAssertTrue(!coreDataManager.favorite.isEmpty)
        XCTAssertTrue(coreDataManager.favorite.count == 1)
        XCTAssertTrue(coreDataManager.favorite[0].name == "test")
    }
    
    func testDeleteOneFavoriteMethods_WhenAnEntityIsCreatedAndDelete_ThenShouldBeCorrectlySaved() {
        let urlImage = "https://food52.com/recipes/72140-grated-tomato"
        let image = urlImage.data!
        coreDataManager.createFavorite(name: "test", time: "", calories: "", ingredients: [""], image: image, ingredientsDetail: [""], url: "")
        
        coreDataManager.deleteOneFavorite(recipe: "test")

        XCTAssertTrue(coreDataManager.favorite.isEmpty)
    }

    func testControlFavoriteMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        let urlImage = "https://food52.com/recipes/72140-grated-tomato"
        let image = urlImage.data!
        coreDataManager.createFavorite(name: "test", time: "", calories: "", ingredients: [""], image: image, ingredientsDetail: [""], url: "")
        
        coreDataManager.controlFavorite(recipe: "test")

        XCTAssertTrue(coreDataManager.favorite[0].name == "test")
    }
    
    func testControlFavorite2Methods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        let urlImage = "https://food52.com/recipes/72140-grated-tomato"
        let image = urlImage.data!
        coreDataManager.createFavorite(name: "test", time: "", calories: "", ingredients: [""], image: image, ingredientsDetail: [""], url: "")
        
        coreDataManager.controlFavorite(recipe: "fake")

        XCTAssertFalse(coreDataManager.favorite[0].name == "fake")
    }
}
