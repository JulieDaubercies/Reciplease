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

    // fonction pour les tests d'alamofire
    func fetchRequests(ingredients: String, url : URL, callback: @escaping (Result<Welcome,NetworkError>)-> Void) {
       // guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?") else { return }
        session.request(ingredients: ingredients, url: url) { dataResponse in
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

    
//https://api.edamam.com/api/recipes/v2?_cont=CHcVQBtNNQphDmgVQntAEX4BYlFtAwUDSmVHAGYbZVZxDAIFUXlSUDARNVQgDAdVFWUWVjFFYQAlDAsDSmQSVTMbYgQlAgYVLnlSVSBMPkd5BgMbUSYRVTdgMgksRlpSAAcRXTVGcV84SU4%3D
    
    
    
    // MARK: - Properties
    
    private var url = "https://api.edamam.com/search?"
    
    // MARK: - Methods
    
//    func fetchRequest(ingredients: String, to: Int, callback: @escaping (Result<Welcome, Error>) -> Void) {
//        let parameters = ["q" : ingredients, "app_key" : "\(ApiKey.app_key)", "app_id" : "\(ApiKey.app_id)", "to": to] as [String : Any]
//        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
//            switch response.result {
//            case .success:
//                if let data = response.data {
//                    do {
//                        let responseDecoded = try JSONDecoder().decode(Welcome.self, from: data)
//                        callback(.success(responseDecoded))
//                    } catch let error as NSError{
//                        print(error)
//                    }
//                }
//            case .failure(let error):
//                print("Error:", error)
//            }
//        }
//    }
}

// var url = "https://api.edamam.com/api/recipes/v2?"
