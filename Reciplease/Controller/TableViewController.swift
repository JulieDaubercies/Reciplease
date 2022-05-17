//
//  TableViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Properties

    private var viewModel = ResultTableViewModel.shared
    private var detailViewModel = DetailViewModel.shared
    private  var recipeService = RecipeService()
    private let customCellId = "CustomTableViewCell"
    private let loadingCellId = "LoadingCell"
    private var coreDataManager: CoreDataManager?
    var searchResponse: Bool!  // créer un protocol à la place
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.tabBarController?.delegate = self
            
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
        // Register cell
        tableView.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.register(UINib.init(nibName: loadingCellId, bundle: nil), forCellReuseIdentifier: loadingCellId)
        viewModel.displayAlertDelegate = self
        viewModel.delegateNetwork = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
       if tabBarController?.tabBar.selectedItem?.tag == 0 {
            searchResponse = true
        } else {
            searchResponse = false
        }
        tableView.reloadData()
    }
    
    // A faire attention par rapport aux mises à jour d'Apple (ancienne méthode)
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if searchResponse == true {
            let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            if (offsetY > contentHeight - scrollView.frame.height) && viewModel.isPaginating.value == false {
                viewModel.fetchMoreData()
            }
        }
    }
    
    

//     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
//        if selectedIndex == 0 {
//            searchResponse = true
//        } else {
//            searchResponse = false
//        }
//    }

    // MARK: - TableView data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if searchResponse == true {
            return 2
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if searchResponse == true {
                return viewModel.hits.count
            } else {
                guard let favoriteRecipeCount = coreDataManager?.favorite.count else { return 0 }
                return favoriteRecipeCount
            }
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
            cell.configure()
            if searchResponse == true {
                cell.recipeInformations = viewModel.hits[indexPath.row].recipe
                return cell
            } else {
                guard let data = coreDataManager?.favorite[indexPath.row] else { return cell }
                cell.favoriteRecipeInformations = data
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellId, for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }

    // Smooth effect during scroll
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.75) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController else { return }
        detailViewModel.recipeIndexPath = indexPath.row
        if searchResponse == true {
            detailViewModel.recipeService = viewModel.hits
            detailViewModel.searchResponse = true
        } else {
            detailViewModel.searchResponse = false
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
// MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        let footLabel = label.footLabel
        return footLabel
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.favorite.isEmpty ?? true ? 200 : 0
    }
}

// MARK: - extension new call loading

extension TableViewController: CallMoreData {
    
    func animate() {
        UIView.transition(with: (self.tableView)!, duration: 0.40, options: .transitionCrossDissolve, animations: { () -> Void in self.tableView.reloadData() }, completion: nil)
    }
}

// MARK: - extension Alert

extension TableViewController: DisplayAlert {
    func showAlert(message: String) {
        alert(message: message)
    }
}
