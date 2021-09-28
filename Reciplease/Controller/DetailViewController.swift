//
//  DetailViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

class DetailViewController: UIViewController  {
    
    // MARK: - Properties
    
    var selectedImage: String?
    var recipeIndexPath: Int?
    var isFavourited: Bool!
    var searchResponse: Bool!
    
    var recipeService = [Hit]()
    private var coreDataManager: CoreDataManager?
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var getDirectionsButton: UIButton!
    @IBOutlet var btnFavourite: UIButton!
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
        getDirectionsButton.addCornerRadius()
        getDirectionsButton.applyGradient(colours: [.systemYellow, .systemPink])
        tableView.dataSource = self

        if let imageToLoad = selectedImage?.data {
            recipeImage.image  = UIImage(data: imageToLoad)?.circleMask
        }
        title()
        controlFavoriteStatus()
    }

    func title() {
        if searchResponse {
            title = recipeService[recipeIndexPath!].recipe.label
        } else {
            title = coreDataManager?.tasks[recipeIndexPath!].name
        }
        
    }
    
    func controlFavoriteStatus() {
        if !searchResponse {  // en mode favori = étoile pleine
            print(1)
            updateRighBarButton(isFavourite: true)
            isFavourited = true
        } else {  // mode recherche par défaut les étoiles sont creuses
            print(2)
            updateRighBarButton(isFavourite: false)
            isFavourited = false
        }
        
        if searchResponse { // mode recherche mais déjà recette en favori = étoile pleine
            print(3)
            if coreDataManager?.controlFavorite(recipe: title ?? "recette") == true {
                updateRighBarButton(isFavourite: true)
                isFavourited = true
            }
        }
        
        btnFavourite.tintColor = .yellow
    }
    
    func updateRighBarButton(isFavourite : Bool){
        if isFavourite {
            btnFavourite.setImage(.init(systemName: "star.fill"), for: .normal)
        } else {
            btnFavourite.setImage(.init(systemName: "star"), for: .normal)
        }
    }

    @IBAction func btnFavouriteDidTap(_ sender: Any) {
        if searchResponse && !isFavourited {
            print(4)
            updateRighBarButton(isFavourite: true)
            addFavouriteFromRecipeService()
            isFavourited = true
        } else  if searchResponse && isFavourited {
            print(5)
            updateRighBarButton(isFavourite: false)
            coreDataManager?.deleteOneTask(recipe: title ?? "recette")
            isFavourited = false
        } else  if !searchResponse && isFavourited {
            print(6)
            updateRighBarButton(isFavourite: false)
            coreDataManager?.deleteOneTask(recipe: title ?? "recette")
            let vc = (storyboard?.instantiateViewController(withIdentifier: "Favorite") as? FavoriteTableViewController)!
            navigationController?.pushViewController(vc, animated: true)
            isFavourited = false
        }
    }

    func addFavouriteFromRecipeService() {
        guard let name = title else { return }
        let time = recipeService[recipeIndexPath!].recipe.totalTime
        let stringTime = String(time)
        let calories = recipeService[recipeIndexPath!].recipe.calories
        let stringCalories = String(calories)
        let image = recipeService[recipeIndexPath!].recipe.image
        let url = recipeService[recipeIndexPath!].recipe.url
        
        var listOfIngredients: [String] = []
        var longListOfIngredients: [String] = []
        for ingredients in recipeService[recipeIndexPath!].recipe.ingredients {
            listOfIngredients.append(ingredients.food)
            longListOfIngredients.append(ingredients.text)
        }
        
        coreDataManager?.createTask(name: name, time: stringTime, calories: stringCalories, ingredients: listOfIngredients, image: image, ingredientsDetail: longListOfIngredients, url: url)
    }

    /// Open on Safari, website instructions
    @IBAction func getDirectionsButton(_ sender: Any) {
        var recipeUrl: String = ""
        guard let index = recipeIndexPath else { return }
        if searchResponse {
            recipeUrl = recipeService[index].recipe.url
        } else {
            recipeUrl = (coreDataManager?.tasks[index].url)!
        }
        if let url = URL(string: recipeUrl) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - extension TabkeViewCell

extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResponse {
            return recipeService[recipeIndexPath!].recipe.ingredients.count
        } else {
            return (coreDataManager?.tasks[recipeIndexPath!].ingredientsDetail?.count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        if searchResponse {
            cell.textLabel?.text = ". " + recipeService[recipeIndexPath!].recipe.ingredients[indexPath.row].text
            return cell
        } else {
            cell.textLabel?.text = coreDataManager?.tasks[recipeIndexPath!].ingredientsDetail?[indexPath.row]
            return cell
        }
    }
}

//        if searchResponse && isFavourited == false {
//            print(4)
//            isFavourited = !isFavourited  // false devient true
//        }
