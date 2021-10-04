//
//  DetailViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

class DetailViewController: UIViewController  {
    
    // MARK: - Properties
    
    var recipeIndexPath: Int?
    var searchResponse: Bool!
    var recipeService = [Hit]()
    private var isFavourited: Bool!
    private var coreDataManager: CoreDataManager?
    @IBOutlet var recipeImage: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var getDirectionsButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
        getDirectionsButton.addCornerRadius()
        getDirectionsButton.applyGradient(colours: [.systemYellow, .systemPink])
        tableView.dataSource = self

        loadImage()
        loadTitle()
        controlFavoriteStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if navigationController?.tabBarItem.tag == 0 {
            if coreDataManager?.controlFavorite(recipe: title ?? "recette") == false {
                  favoriteButton.setImage(.init(systemName: "star"), for: .normal)
            }
        }
    }

    
    // utiliser sdwebimage??
    private func loadImage() {
        if searchResponse {
            if let imageToLoad =  recipeService[recipeIndexPath!].recipe.image.data {
                recipeImage.image  = UIImage(data: imageToLoad)?.circleMask
            }
        } else {
            if let imageToLoad = coreDataManager?.favorite[recipeIndexPath!].image {
                recipeImage.image  = UIImage(data: imageToLoad)?.circleMask
            }
        }
    }

    private func loadTitle() {
        if searchResponse {
            title = recipeService[recipeIndexPath!].recipe.label
        } else {
            title = coreDataManager?.favorite[recipeIndexPath!].name
        }
    }

    private func controlFavoriteStatus() {
        if !searchResponse {
            updateFavoriteButton(isFavourite: true)
            isFavourited = true
        } else {
            updateFavoriteButton(isFavourite: false)
            isFavourited = false
        }
        if searchResponse {
            if coreDataManager?.controlFavorite(recipe: title ?? "recette") == true {
                updateFavoriteButton(isFavourite: true)
                isFavourited = true
            }
        }
        favoriteButton.tintColor = .yellow
    }
    
    private func updateFavoriteButton(isFavourite : Bool){
        if isFavourite {
            favoriteButton.setImage(.init(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(.init(systemName: "star"), for: .normal)
        }
    }

    @IBAction private func favouriteButtonDidTap(_ sender: Any) {
        if searchResponse && !isFavourited {
           // print(4)
            updateFavoriteButton(isFavourite: true)
            addFavourite()
            isFavourited = true
        } else  if searchResponse && isFavourited {
          //  print(5)
            updateFavoriteButton(isFavourite: false)
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            isFavourited = false
        } else  if !searchResponse && isFavourited {
         //   print(6)
            updateFavoriteButton(isFavourite: false)
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            navigationController?.popViewController(animated: true)
            isFavourited = false
            if navigationController?.tabBarItem.tag == 1 {
                tabBarController?.selectedIndex = 0
                    viewWillAppear(true)
                tabBarController?.selectedIndex = 1
            }
        }
    }

    private func addFavourite() {
        guard let name = title else { return }
        let time = recipeService[recipeIndexPath!].recipe.totalTime
        let stringTime = String(time)
        let calories = Int(recipeService[recipeIndexPath!].recipe.calories)
        let stringCalories = String(calories)
        let image = (recipeService[recipeIndexPath!].recipe.image.data)!
        let url = recipeService[recipeIndexPath!].recipe.url
        var listOfIngredients: [String] = []
        var longListOfIngredients: [String] = []
        for ingredients in recipeService[recipeIndexPath!].recipe.ingredients {
            listOfIngredients.append(ingredients.food)
            longListOfIngredients.append(ingredients.text)
        }
        coreDataManager?.createFavorite(name: name, time: stringTime, calories: stringCalories, ingredients: listOfIngredients, image: image, ingredientsDetail: longListOfIngredients, url: url)
    }

    /// Open on Safari, website instructions
    @IBAction private func getDirectionsButton(_ sender: Any) {
        var recipeUrl: String = ""
        guard let index = recipeIndexPath else { return }
        if searchResponse {
            recipeUrl = recipeService[index].recipe.url
        } else {
            recipeUrl = (coreDataManager?.favorite[index].url)!
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
            return (coreDataManager?.favorite[recipeIndexPath!].ingredientsDetail?.count)!
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        if searchResponse {
            cell.textLabel?.text = ". " + recipeService[recipeIndexPath!].recipe.ingredients[indexPath.row].text
            return cell
        } else {
            cell.textLabel?.text = ". " + (coreDataManager?.favorite[recipeIndexPath!].ingredientsDetail?[indexPath.row])!
            return cell
        }
    }
}

//        if searchResponse && isFavourited == false {
//            isFavourited = !isFavourited
//        }
