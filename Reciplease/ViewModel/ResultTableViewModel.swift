//
//  ResultTableViewModel.swift
//  Reciplease
//
//  Created by DAUBERCIES on 15/04/2022.
//

import Foundation

protocol CallMoreData: AnyObject {
    func animate()
}

class ResultTableViewModel {
    
    // MARK: - Properties

    static let shared = ResultTableViewModel()
    
    private  var recipeService = RecipeService()
    var ingredients: String?
    var isPaginating: Box<Bool> = Box(false)
    var nextPage: String?
    var hits = [Hit]()
    var displayAlertDelegate: DisplayAlert?
    var delegateNetwork: CallMoreData?
    
    // MARK: - Methods
    
    
     func fetchMoreData() {
         if isPaginating.value == false {
             self.isPaginating.value = true
         }
        guard let nextRecipe = nextPage else { return }
        guard let url = URL(string: nextRecipe ) else { return }
        guard let ingredient = ingredients else { return }
        recipeService.fetchRequests(ingredients: ingredient, url: url) { [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let moreData):
                    self?.hits.append(contentsOf: moreData.hits)
                    
                    self?.delegateNetwork?.animate()
                    
                    self?.nextPage = moreData.links.next.href
                    self?.isPaginating.value = false
                case .failure(let error):
                    self?.displayAlertDelegate?.showAlert(message: "\(error)")
                }
            }
        }
    }
}
