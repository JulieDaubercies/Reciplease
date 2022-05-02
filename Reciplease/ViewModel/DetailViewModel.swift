//
//  DetailViewModel.swift
//  Reciplease
//
//  Created by DAUBERCIES on 30/04/2022.
//

import Foundation
import UIKit

class DetailViewModel {
    
    static let shared = DetailViewModel()
    
    var recipeIndexPath: Int?
    var searchResponse: Bool!
    var recipeService = [Hit]()
    private var circleImage: UIImage!
    private var title: String!
    private var isFavourited: Bool = true
    private var coreDataManager: CoreDataManager?
    
    
    init() {
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
    }
    
    func loadImage() -> UIImage {
        guard let index = recipeIndexPath else { return UIImage(named: "meal")! }
        if searchResponse {
            if let imageToLoad =  recipeService[index].recipe.image.data {
                circleImage  = UIImage(data: imageToLoad)?.circleMask
            }
        } else {
            if let imageToLoad = coreDataManager?.favorite[index].image {
                circleImage   = UIImage(data: imageToLoad)?.circleMask
            }
        }
        return circleImage
    }
    
     func loadTitle() -> String {
        guard let index = recipeIndexPath else { return "Recipe" }
        if searchResponse {
            title = recipeService[index].recipe.label
        } else {
            title = coreDataManager?.favorite[index].name
        }
         return title
    }
}
