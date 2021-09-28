//
//  FavoriteTableViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit

class FavoriteTableViewController: UITableViewController {
    
    // MARK: - Properties

    let customCellId = "CustomTableViewCell"
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
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (coreDataManager?.tasks.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: customCellId, for: indexPath) as! CustomTableViewCell
        let data = coreDataManager?.tasks[indexPath.row]
        cell.recipeLabel.text = data?.name
        cell.caloriesLabel.text = data?.calories
        cell.timeLabel.text = data?.time
        cell.ingredientsLabel.text = data?.ingredients
        let recipeImageView = cell.recipeImage
        let stringImage = URL(string: data?.image ?? "bla")!
        recipeImageView?.load(url: stringImage)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController)!
        let data = coreDataManager?.tasks[indexPath.row]
        vc.selectedImage = data?.image
        let stringIngredientsDetail = data?.ingredientsDetail
        let array = stringIngredientsDetail?.components(separatedBy: "::")
        vc.longListIngredients = array
        vc.recipeIndexPath = indexPath.row
        vc.searchResponse = false
        navigationController?.pushViewController(vc, animated: true)
    }
}
