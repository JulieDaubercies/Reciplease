//
//  SearchViewModel.swift
//  Reciplease
//
//  Created by DAUBERCIES on 08/04/2022.
//

import Foundation

protocol DisplayAlert: AnyObject {
    func showAlert(message: String)
}

protocol NetworkServiceDelegate: AnyObject {

    func didCompleteRequest(result: [Hit])
    func stopCall()
}

class SearchViewModel {
    
    private var recipeService = RecipeService()
    var displayAlertDelegate: DisplayAlert?
    var delegateNetwork: NetworkServiceDelegate?
    var hit = [Hit]()
    var ingredientField: Box<String> = Box("")
    var arrayOfIngredients: Box<[String]> = Box([])
    
    
    func addButton(ingredient: String) {
        if !ingredient.isBlank {
            arrayOfIngredients.value.append(ingredient.prefix(1).uppercased() + ingredient.lowercased().dropFirst())
            ingredientField.value = ""
        }
    }
    
    func clearButton() {
        arrayOfIngredients.value.removeAll()
    }
    
    func searchButton() {
        guard !arrayOfIngredients.value.isEmpty else {
            displayAlertDelegate?.showAlert(message: "Merci d'ajouter des ingrédients pour lancer une recherche")
            return
        }
       // startAnimation()
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2?") else { return }
        recipeService.fetchRequests(ingredients: arrayOfIngredients.value.joined(separator: ","), url : url) { [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let recipe):
                    self?.hit = recipe.hits
                    self?.delegateNetwork?.didCompleteRequest(result: self!.hit)
                case .failure(let error):
                    self?.displayAlertDelegate?.showAlert(message: "\(error)")
                    self?.delegateNetwork?.stopCall()
                }
            }
        }
    }
    
    
    
}
