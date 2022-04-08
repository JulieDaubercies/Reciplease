//
//  RecipeService.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import Foundation
import Alamofire

class RecipeService {

    // MARK: - Properties

    private let session: AlamofireSession
    
    // MARK: - Initializer
    
    init(session: AlamofireSession = EdamamSession()) {
        self.session = session
    }

    // MARK: - Methods

    func fetchRequests(ingredients: String, url : URL, callback: @escaping (Result<RecipeStructure,NetworkError>)-> Void) {
        session.request(ingredients: ingredients, url: url) { dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(RecipeStructure.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
}
