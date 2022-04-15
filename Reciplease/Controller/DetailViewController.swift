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
    private var isFavourited: Bool = true
    private var coreDataManager: CoreDataManager?
    @IBOutlet private var recipeImage: UIImageView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var getDirectionsButton: UIButton!
    @IBOutlet private var favoriteButton: UIButton!
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
        getDirectionsButton.addShadow()
        tableView.dataSource = self

        loadImage()
        loadTitle()
        controlFavoriteStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getDirectionsButton.applyGradient(colours: [.systemYellow, .systemPink]).frame = getDirectionsButton.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let coreDataManager = coreDataManager else {
            return
        }
        if coreDataManager.controlFavorite(recipe: title ?? "recette") {
            favoriteButton.setImage(.init(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(.init(systemName: "star"), for: .normal)
        }
    }
    
    private func loadImage() {
        guard let index = recipeIndexPath else { return }
        if searchResponse {
            if let imageToLoad =  recipeService[index].recipe.image.data {
                recipeImage.image  = UIImage(data: imageToLoad)?.circleMask
            }
        } else {
            if let imageToLoad = coreDataManager?.favorite[index].image {
                recipeImage.image  = UIImage(data: imageToLoad)?.circleMask
            }
        }
    }

    private func loadTitle() {
        guard let index = recipeIndexPath else { return }
        if searchResponse {
            title = recipeService[index].recipe.label
        } else {
            title = coreDataManager?.favorite[index].name
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
    
    private func updateFavoriteButton(isFavourite : Bool) {
        favoriteButton.layer.removeAllAnimations()
        if isFavourite {
            favoriteButton.setImage(.init(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(.init(systemName: "star"), for: .normal)
            favoriteButton.layer.add(animateStar(), forKey: nil)
        }
    }

    @IBAction private func favouriteButtonDidTap(_ sender: Any) {
        if searchResponse && !isFavourited {
            updateFavoriteButton(isFavourite: true)
            guard let index = recipeIndexPath else { return }
            coreDataManager?.createFavorite(recipe: recipeService[index].recipe)
            isFavourited = true
        } else  if searchResponse && isFavourited {
            updateFavoriteButton(isFavourite: false)
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            isFavourited = false
        } else  if !searchResponse && isFavourited {
            updateFavoriteButton(isFavourite: false)
            coreDataManager?.deleteOneFavorite(recipe: title ?? "recette")
            navigationController?.popViewController(animated: true)
            isFavourited = false
        }
    }

    /// Open website instructions on Safari
    @IBAction private func getDirectionsButton(_ sender: Any) {
        var recipeUrl: String = ""
        guard let index = recipeIndexPath else { return }
        if searchResponse {
            recipeUrl = recipeService[index].recipe.url
        } else {
            guard let url = coreDataManager?.favorite[index].url else { return }
            recipeUrl = url
        }
        if let url = URL(string: recipeUrl) {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - extension TabkeViewCell

extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let index = recipeIndexPath else { return 0 }
        if searchResponse {
            return recipeService[index].recipe.ingredients.count
        } else {
            guard let favoriteRecipeCount = coreDataManager?.favorite[index].ingredientsDetail?.count else { return 0 }
            return favoriteRecipeCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        guard let index = recipeIndexPath else { return cell }
        if searchResponse {
            cell.textLabel?.text = ". " + recipeService[index].recipe.ingredients[indexPath.row].text
            return cell
        } else {
            guard let favoriteIngredientsDetail = coreDataManager?.favorite[index].ingredientsDetail?[indexPath.row] else { return cell}
            cell.textLabel?.text = ". " + favoriteIngredientsDetail
            return cell
        }
    }
}
