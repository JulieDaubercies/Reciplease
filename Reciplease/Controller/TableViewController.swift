//
//  TableViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit


class TableViewController: UITableViewController {

    // MARK: - Properties
    
    var recipeService = RecipeService()
    var hits = [Hit]()
    let customCellId = "CustomTableViewCell"
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell
        tableView.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.separatorColor = UIColor.black
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  hits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.recipe = hits[indexPath.row].recipe
        cell.time = hits[indexPath.row].recipe
        cell.calories = hits[indexPath.row].recipe
        cell.picture = hits[indexPath.row].recipe
        cell.list = hits[indexPath.row].recipe
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController)!
        vc.selectedImage = hits[indexPath.row].recipe.image
        
        //
        var listOfIngredients: String = ""
        var longListOfIngredients: [String] = []
        for ingredients in hits[indexPath.row].recipe.ingredients {
            listOfIngredients = listOfIngredients + ingredients.food + ","
            longListOfIngredients.append(ingredients.text)
        }
        let ingredients = "\(listOfIngredients)"
        vc.ingredients = ingredients
        vc.longListIngredients = longListOfIngredients
        //
        vc.recipeIndexPath = indexPath.row
        vc.recipeService = hits
        vc.searchResponse = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
