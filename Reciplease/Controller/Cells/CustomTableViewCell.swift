//
//  CustomTableViewCell.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit
import SDWebImage

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var caloriesLabel: UILabel!
    @IBOutlet var viewForTime: UIView!
    @IBOutlet var ingredientsLabel: UILabel!
    
    var recipe: Recipe? {
        didSet {
            recipeLabel.text = recipe?.label
        }
    }
    var time: Recipe? {
        didSet {
            guard let time = time?.totalTime else { return }
            timeLabel.text = String(time) + "min"
        }
    }
    
    var calories: Recipe? {
        didSet {
            guard let kcal = calories?.calories else { return }
            caloriesLabel.text = String(kcal) + "kcal"
        }
    }

    var picture: Recipe? {
        didSet {
            guard let urlString = picture?.image else { return }
            recipeImage.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "meal"), options: .continueInBackground, completed: nil)
            recipeImage.contentMode = .scaleAspectFill
        }
    }
    
    var list: Recipe? {
        didSet {
            var listOfIngredients: String = ""
            guard let arrayOfIngredients = list?.ingredients else { return }
            for ingredients in arrayOfIngredients {
                listOfIngredients = listOfIngredients + ingredients.food + ","
            }
            ingredientsLabel.text = "\(listOfIngredients)"
        }
    }
    
    
    
    func configure(image: String) {
        let recipeImageView = recipeImage
        let stringImage = URL(string: image)!
        recipeImageView?.load(url: stringImage)
        recipeImage.contentMode = .scaleAspectFill
    }
}
