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
    let loadingCellId = "LoadingCell"
    var ingredients: String?
    var nextPage: String?
    var isPaginating = false

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
        tableView.register(UINib.init(nibName: loadingCellId, bundle: nil), forCellReuseIdentifier: loadingCellId)
        tableView.separatorColor = UIColor.black
        tableView.reloadData()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) && !isPaginating {
            fetchMoreData()
        }
    }
    
    func getTheNextPage(link: String) {
        nextPage = link
    }
    
    func fetchMoreData(completed:((Bool) -> Void)? = nil) {
        if !self.isPaginating {
            self.isPaginating = true
        }
        guard let url = URL(string: nextPage! ) else { return }
        recipeService.fetchRequests(ingredients: ingredients!, url: url) { [weak self] result in
            DispatchQueue.main.async { [self] in
                switch result {
                case .success(let moreData):
                    self?.hits.append(contentsOf: moreData.hits)
                    self?.tableView.reloadData()
                    self?.getTheNextPage(link: moreData.links.next.href)
                    self?.isPaginating = false
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return hits.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as! CustomTableViewCell
            cell.selectionStyle = .none
            cell.recipe = hits[indexPath.row].recipe
            cell.time = hits[indexPath.row].recipe
            cell.calories = hits[indexPath.row].recipe
            cell.picture = hits[indexPath.row].recipe
            cell.list = hits[indexPath.row].recipe
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellId, for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
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
