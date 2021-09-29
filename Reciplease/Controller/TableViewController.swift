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
    var ingredients: String?
    var limit = 20
    
    private var recipe = [Hit]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell
        tableView.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.separatorColor = UIColor.black
        tableView.reloadData()
       // fetchData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

//        if offsetY > contentHeight - scrollView.frame.height {
//            recipeService.fetchRequest(ingredients: ingredients!, to: limit) { [weak self] result in
//                DispatchQueue.main.async { [self] in
//                    switch result {
//                    case .success(let recipe) :
//                       // self?.recipe.append(contentsOf: recipe.hits)
//                        self?.hits = recipe.hits
//                        self?.tableView.reloadData()
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//            }
            // ça fonctionne sur ce point
            // mais une autre recherche ne fonctionne pas
            // charge d'un coup 85 recettes, s'arrête à ce point
           // limit += 20
  //      }
    }
    
    func fetchData(completed: ((Bool) -> Void)? = nil) {
        recipeService.fetchRequest(ingredients: ingredients!, to: limit) { [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let recipe) :
                    self?.recipe.append(contentsOf: recipe.hits)
                    self?.hits = recipe.hits
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
            
        }
        limit += 20
    }

//    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        guard !recipe.isEmpty else { return }
//            fetchData { [weak self] success in
//                if !success {
//                    self?.hideBottomLoader()
//                }
//            }
//    }
//
//    private func hideBottomLoader() {
//        DispatchQueue.main.async {
//            let lastListIndexPath = IndexPath(row: self.recipe.count - 1, section: 0)
//            self.tableView.scrollToRow(at: lastListIndexPath, at: .bottom, animated: true)
//        }
//    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hits.count  // recipe.count //
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.recipe = hits[indexPath.row].recipe
        cell.time = hits[indexPath.row].recipe
        cell.calories = hits[indexPath.row].recipe
        cell.picture = hits[indexPath.row].recipe
        cell.list = hits[indexPath.row].recipe

//        let recipe = recipe[indexPath.row]
//        cell.recipe = recipe.recipe
//        cell.time = recipe.recipe
//        cell.calories = recipe.recipe
//        cell.picture = recipe.recipe
//        cell.list = recipe.recipe
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController)!
        vc.recipeIndexPath = indexPath.row
        vc.recipeService = hits
        vc.searchResponse = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
