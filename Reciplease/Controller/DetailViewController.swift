//
//  DetailViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

class DetailViewController: UIViewController  {
    
    // MARK: - Properties
    
    var recipeUrl: String = ""
    var selectedImage: String?
    var recipeIndexPath: Int?
    var ingredients: String?
    var longListIngredients: [String]?
    var isFavourited: Bool!
    var searchResponse: Bool!
    
    var recipeService = [Hit]()
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var getDirectionsButton: UIButton!
    @IBOutlet var btnFavourite: UIButton!
    private var coreDataManager: CoreDataManager?
    
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
            isFavourited = false
        } else  if !searchResponse && !isFavourited {
            print(7)
            updateRighBarButton(isFavourite: true)
           // addFavouriteFromRecipeService()
            isFavourited = true
        }
    }

    func addFavouriteFromRecipeService() {
        guard let name = title else { return }
        let time = recipeService[recipeIndexPath!].recipe.totalTime
        let stringTime = String(time)
        let calories = recipeService[recipeIndexPath!].recipe.calories
        let stringCalories = String(calories)
        
       // let shortListOfIngredients = recipeService[recipeIndexPath!].recipe.ingredients
//        print("ya")
//        print(shortListOfIngredients)
      //  var array = ["a","b","c"]
        guard let shortListOfIngredients = ingredients else { return }
        let stringArray = (longListIngredients?.joined(separator: "::"))!
        let image = recipeService[recipeIndexPath!].recipe.image
        
        coreDataManager?.createTask(name: name, time: stringTime, calories: stringCalories, ingredients: shortListOfIngredients, image: image, ingredientsDetail: stringArray)
    }

    func unfavourite() {
        //do your unfavourite logic
    }

    /// Open on Safari website instructions
    @IBAction func getDirectionsButton(_ sender: Any) {
        guard let index = recipeIndexPath else { return }
        recipeUrl = recipeService[index].recipe.url
        if let url = URL(string: recipeUrl) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - extension TabkeViewCell

extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let index = recipeIndexPath
        if searchResponse {
            return recipeService[index!].recipe.ingredients.count
        } else {
            return longListIngredients!.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        if searchResponse {
            let index = recipeIndexPath
            cell.textLabel?.text = ". " + recipeService[index!].recipe.ingredients[indexPath.row].text
            return cell
        } else {
            cell.textLabel?.text = longListIngredients?[indexPath.row]
            return cell
        }
    }
}

//        if searchResponse && isFavourited == false {
//            print(4)
//            isFavourited = !isFavourited  // false devient true
//        }
