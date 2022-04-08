//
//  RecipleaseTests.swift
//  RecipleaseTests
//
//  Created by DAUBERCIES on 28/09/2021.
//

import XCTest
@testable import Reciplease

class RecipleaseTests: XCTestCase {

    // MARK: - Properties

    func testGetData_WhenNoDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: nil, data: nil))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?") else { return }
        requestService.fetchRequests(ingredients: "tomato", url: url) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with no data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetData_WhenIncorrectResponseIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseKO, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?") else { return }
        requestService.fetchRequests(ingredients: "tomato", url: url) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with incorrect response failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetData_WhenUndecodableDataIsPassed_ThenShouldReturnFailedCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.incorrectData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?") else { return }
        requestService.fetchRequests(ingredients: "tomato", url: url) { result in
            guard case .failure(let error) = result else {
                XCTFail("Test getData method with undecodable data failed.")
                return
            }
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }

    func testGetData_WhenCorrectDataIsPassed_ThenShouldReturnSuccededCallback() {
        let session = FakeEdamamSession(fakeResponse: FakeResponse(response: FakeResponseData.responseOK, data: FakeResponseData.correctData))
        let requestService = RecipeService(session: session)
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?") else { return }
        requestService.fetchRequests(ingredients: "tomato", url: url) { result in
            guard case .success(let data) = result else {
                print(result)
                XCTFail("Test getData method with correct data failed.")
                return
            }
            XCTAssertTrue(data.hits[0].recipe.label == "Roast potatoes")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.01)
    }
}
