//
//  TableViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

// essayer de factoriser en une seule table View


class TableViewController: UITableViewController {

    // MARK: - Properties

    private var viewModel = ResultTableViewModel.shared
    private  var recipeService = RecipeService()
    private let customCellId = "CustomTableViewCell"
    private let loadingCellId = "LoadingCell"
    private var isPaginating = false

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell
        tableView.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.register(UINib.init(nibName: loadingCellId, bundle: nil), forCellReuseIdentifier: loadingCellId)
        viewModel.displayAlertDelegate = self
        viewModel.delegateNetwork = self
        
        viewModel.isPaginating.bind { scroll in
            self.isPaginating = scroll
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // A faire attention par rapport aux mises à jour d'Apple (ancienne méthode)
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) && isPaginating == false {
            viewModel.fetchMoreData()
        }
    }

    // MARK: - TableView data source

    override func numberOfSections(in tableView: UITableView) -> Int {
            return 2
        }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.hits.count
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
            cell.recipe = viewModel.hits[indexPath.row].recipe
            cell.time = viewModel.hits[indexPath.row].recipe
            cell.calories = viewModel.hits[indexPath.row].recipe
            cell.picture = viewModel.hits[indexPath.row].recipe
            cell.list = viewModel.hits[indexPath.row].recipe
            cell.configure()
            return cell
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
        vc.recipeIndexPath = indexPath.row
        vc.recipeService = viewModel.hits
        vc.searchResponse = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - extension new call management

extension TableViewController: CallMoreData {
    
    func animate() {
        UIView.transition(with: (self.tableView)!,
                          duration: 0.40,
                          options: .transitionCrossDissolve,
                          animations: { () -> Void in
            self.tableView.reloadData() },
                          completion: nil)
    }
}

// MARK: - extension Alert

extension TableViewController: DisplayAlert {
    func showAlert(message: String) {
        alert(message: message)
    }
}
