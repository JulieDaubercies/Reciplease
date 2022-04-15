//
//  CustomTableViewCell.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit
import SDWebImage
import CoreData

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var shadowView: UIView!
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var viewForTime: UIView!
    @IBOutlet var ingredientsLabel: UILabel!
        
    func configure() {
        shadowView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.masksToBounds = false
        recipeImage.layer.cornerRadius = 10
    }
    
    var recipeInformations: Recipe? {
        didSet {
            recipeLabel.text = recipeInformations?.label
            
            guard let time = recipeInformations?.totalTime else { return }
            timeLabel.text = String(time) + "min"
            
            guard let kcal = recipeInformations?.calories else { return }
            let calories = Int(kcal)
            caloriesLabel.text = String(calories) + "kcal"
            
            guard let urlString = recipeInformations?.image else { return }
            recipeImage.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "meal"), options: .continueInBackground, completed: nil)
            
            var listOfIngredients: String = ""
            guard let arrayOfIngredients = recipeInformations?.ingredients else { return }
            for ingredients in arrayOfIngredients {
                listOfIngredients = listOfIngredients + ingredients.food + ","
            }
            ingredientsLabel.text = "\(listOfIngredients)"
        }
    }
    
    var favoriteRecipeInformations: FavoriteRecipe? {
        didSet {
            recipeLabel.text = favoriteRecipeInformations?.name
            
            guard let time = favoriteRecipeInformations?.time else { return }
            timeLabel.text = String(time) + "min"
            
            guard let kcal = favoriteRecipeInformations?.calories else { return }
            caloriesLabel.text = String(kcal) + "kcal"
            
            guard let image = favoriteRecipeInformations?.image else { return }
            recipeImage.image = UIImage(data: image)
            
            ingredientsLabel.text = favoriteRecipeInformations?.ingredients?.joined(separator: ",")
        }
    }
//    var recipe: Recipe? {
//        didSet {
//            recipeLabel.text = recipe?.label
//        }
//    }
//
//    var time: Recipe? {
//        didSet {
//            guard let time = time?.totalTime else { return }
//            timeLabel.text = String(time) + "min"
//        }
//    }
//
//    var calories: Recipe? {
//        didSet {
//            guard let kcal = calories?.calories else { return }
//            let calories = Int(kcal)
//            caloriesLabel.text = String(calories) + "kcal"
//        }
//    }
//
//    var picture: Recipe? {
//        didSet {
//            guard let urlString = picture?.image else { return }
//            recipeImage.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "meal"), options: .continueInBackground, completed: nil)
//        }
//    }
//
//    var list: Recipe? {
//        didSet {
//            var listOfIngredients: String = ""
//            guard let arrayOfIngredients = list?.ingredients else { return }
//            for ingredients in arrayOfIngredients {
//                listOfIngredients = listOfIngredients + ingredients.food + ","
//            }
//            ingredientsLabel.text = "\(listOfIngredients)"
//        }
//    }
}
