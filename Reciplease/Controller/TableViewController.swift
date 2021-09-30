//
//  TableViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit


class TableViewController: UITableViewController {

    enum TableSection: Int {
        case userList
        case loader
    }
    
    // MARK: - Properties
    
    var recipeService = RecipeService()
    var hits = [Hit]()
    let customCellId = "CustomTableViewCell"
    var ingredients: String?
    
//    private var recipe = [Hit]() {
//        didSet {
//            DispatchQueue.main.async { [weak self] in
//                self?.fetchData()
//                self?.tableView.reloadData()
//            }
//        }
//    }
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell
        tableView.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.separatorColor = UIColor.black
        tableView.reloadData()
    }
    
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        if offsetY > contentHeight - scrollView.frame.height {
//            fetchData()
//        }
//    }
    
    // fonctionne avec hits.count + 20 mais met du temps à charger + mode recherche ne fonctionne plus (charge dans le vide)
    func fetchData(completed: ((Bool) -> Void)? = nil) {
        recipeService.fetchRequest(ingredients: ingredients!, to: hits.count + 20) { [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let recipe) :
                    self?.hits = recipe.hits
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hits.count
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
        vc.recipeIndexPath = indexPath.row
        vc.recipeService = hits
        vc.searchResponse = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
