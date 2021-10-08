//
//  FavoriteTableViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    // MARK: - Properties

    private let customCellId = "CustomTableViewCell"
    private var coreDataManager: CoreDataManager?
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
        // Register cell
        tableView.register(UINib.init(nibName: customCellId, bundle: nil), forCellReuseIdentifier: customCellId)
        tableView.separatorColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favoriteRecipeCount = coreDataManager?.favorite.count else { return 0 }
        return favoriteRecipeCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as! CustomTableViewCell
        guard let data = coreDataManager?.favorite[indexPath.row] else { return cell }
        guard let image = data.image else { return cell}
        guard let calories = data.calories else { return cell}
        guard let time = data.time else { return cell}
        
        cell.recipeLabel.text = data.name
        cell.caloriesLabel.text = calories + "kcal"
        cell.timeLabel.text = time + "min"
        cell.ingredientsLabel.text = data.ingredients?.joined(separator: ",")
        cell.recipeImage.image = UIImage(data: image)
        cell.configure()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Smooth effect during scroll
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5
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
        vc.searchResponse = false
        navigationController?.pushViewController(vc, animated: true)
    }

// MARK: - UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Aucun favoris enregistrés"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return coreDataManager?.favorite.isEmpty ?? true ? 200 : 0
    }
}
