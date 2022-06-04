//
//  DetailViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = DetailViewModel.shared
    var move: Bool!
    var recipeIndexPath: Int?
    @IBOutlet private var recipeImage: UIImageView!
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var getDirectionsButton: UIButton!
    @IBOutlet private var favoriteButton: UIButton!
    
    // MARK: - Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        getDirectionsButton.addShadow()
        tableView.dataSource = self
        recipeImage.image = viewModel.circleImage
        title = viewModel.title
        viewModel.controlFavoriteStatus()
        favoriteButton.tintColor = .yellow
        
        viewModel.moveView.bind { [weak self] change in
            self?.move = change
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        getDirectionsButton.applyGradient(colours: [.systemYellow, .systemPink]).frame = getDirectionsButton.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // ligne important pour que l'enregistrement du favori se fasse sur le bon index
        viewModel.recipeIndexPath = recipeIndexPath
        
        if tabBarController?.tabBar.selectedItem?.tag == 0 {
            viewModel.searchResponse = true
        } else {
            viewModel.searchResponse = false
        }
        
        viewModel.isFavourited.bind { [weak self] favorite in
            self?.updateFavoriteButton(isFavourite: favorite)
        }
        
        guard let coreDataManager = viewModel.coreDataManager else { return }
        if coreDataManager.controlFavorite(recipe: title ?? "recette") {
            favoriteButton.setImage(.init(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(.init(systemName: "star"), for: .normal)
        }
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
        viewModel.favoriteChange()
        if move {
            navigationController?.popViewController(animated: true)
        }
    }

    /// Open website instructions on Safari
    @IBAction private func getDirectionsButton(_ sender: Any) {
        UIApplication.shared.open(viewModel.url!)
    }
}

// MARK: - extension TabkeViewCell

extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let number = viewModel.numberOfRows else { return 0 }
        return number
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        if viewModel.searchResponse {
            guard let listFavorite = viewModel.ingredientSearchListRecipe?[indexPath.row].text else { return cell }
            cell.textLabel?.text = ". " + listFavorite
            return cell
        } else {
            guard let listSearch = viewModel.ingredientListFavoriteRecipe?[indexPath.row] else { return cell }
            cell.textLabel?.text = ". " + listSearch
            return cell
        }
    }
}
