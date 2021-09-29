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
    
    var searchList: String?
    // var url = "https://api.edamam.com/api/recipes/v2?"
    var url = "https://api.edamam.com/search?"
    var app_key = "98ee6e62007af9ff9f92549710183fbb"
    var app_id = "7732ff7c"
    var image: String!
    
    // api de recherche = https://api.edamam.com/search?q=tomato&app_key=98ee6e62007af9ff9f92549710183fbb&app_id=7732ff7c&from=21&to=30
    
    // MARK: - Methods
    
    func fetchRequest(ingredients: String, to: Int, callback: @escaping (Result<Welcome, Error>) -> Void) {
        //let parameters = ["q" : ingredients, "app_key" : "\(app_key)", "type" : "public", "app_id" : "\(app_id)"]
        let parameters = ["q" : ingredients, "app_key" : "\(app_key)", "app_id" : "\(app_id)", "to": to] as [String : Any]
        AF.request(url, method: .get, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success:
                if let data = response.data {
                    do {
                        let responseDecoded = try JSONDecoder().decode(Welcome.self, from: data)
                        callback(.success(responseDecoded))
                        self.image = responseDecoded.hits[0].recipe.image
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

//        let request = AF.request(RecipeService.url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil).responseDecodable(of: RecipeListResult.self) { response in
