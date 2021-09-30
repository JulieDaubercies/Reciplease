//
//  RecipeService.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//


import Foundation
import Alamofire


enum EdamamError: Error {
    case noData, invalidResponse, undecodableData
}

class RecipeService {

    private let session: AlamofireSession
    
    init(session: AlamofireSession = EdamamSession()) {
        self.session = session
    }
    
    
    func fetchRequests(ingredients: String, to: Int, callback: @escaping (Result<Welcome,EdamamError>)-> Void) {
        guard let url = URL(string: "https://api.edamam.com/search?") else { return }
        
        session.request(ingredients: ingredients, to: to, url: url) { dataResponse in
            guard let data = dataResponse.data else {
                callback(.failure(.noData))
                return
            }
            guard dataResponse.response?.statusCode == 200 else {
                callback(.failure(.invalidResponse))
                return
            }
            guard let dataDecoded = try? JSONDecoder().decode(Welcome.self, from: data) else {
                callback(.failure(.undecodableData))
                return
            }
            callback(.success(dataDecoded))
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: - Properties
    
    private var url = "https://api.edamam.com/search?"
    
    // MARK: - Methods
    
    func fetchRequest(ingredients: String, to: Int, callback: @escaping (Result<Welcome, Error>) -> Void) {
        let parameters = ["q" : ingredients, "app_key" : "\(ApiKey.app_key)", "app_id" : "\(ApiKey.app_id)", "to": to] as [String : Any]
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let responseDecoded = try JSONDecoder().decode(Welcome.self, from: data)
                        callback(.success(responseDecoded))
                    } catch let error as NSError{
                        print(error)
                    }
                }
            case .failure(let error):
                print("Error:", error)
            }
        }
    }
}

// var url = "https://api.edamam.com/api/recipes/v2?"
