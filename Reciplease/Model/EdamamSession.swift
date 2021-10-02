//
//  EdamamSession.swift
//  Reciplease
//
//  Created by DAUBERCIES on 30/09/2021.
//

import Foundation
import Alamofire

protocol AlamofireSession {
    func request(ingredients: String, url: URL, callback: @escaping (AFDataResponse<Any>)-> Void)
    
}

class EdamamSession: AlamofireSession {
    
    func request(ingredients: String, url: URL, callback: @escaping (AFDataResponse<Any>) -> Void) {
        let parameters = ["q" : ingredients, "type": "public", "app_key" : "\(ApiKey.app_key)", "app_id" : "\(ApiKey.app_id)"]
        AF.request(url, method: .get, parameters: parameters).responseJSON { dataResponse in
            callback(dataResponse)
        }
    }
    
}

