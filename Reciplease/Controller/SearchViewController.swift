//
//  ViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit
import NVActivityIndicatorView

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    
    @IBOutlet var loadingView: UIView!
    @IBOutlet var ingredientTextField: UITextField!
    @IBOutlet var addIngredientButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var recipeService = RecipeService()
    var arrayOfIngredients: [String] = []
    var list: String = ""
    
    private let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    
    // MARK: - Methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reciplease"
        tableView.dataSource = self
        addIngredientButton.addCornerRadius()
        searchButton.addCornerRadius()
        clearButton.addCornerRadius()
        self.clearButton.applyGradient(colours: [.lightGray, .darkGray])
        self.searchButton.applyGradient(colours: [.systemYellow, .systemPink])
        self.addIngredientButton.applyGradient(colours: [.systemYellow, .systemPink])
        ingredientTextField.placeholder = "Carrot"
    }
    
    @IBAction func tappedAddButton(_ sender: Any) {
        // faire un guard let
        if ingredientTextField.text?.isBlank == true {
            // message d'erreur ??
        } else {
            arrayOfIngredients.append(ingredientTextField.text!.prefix(1).uppercased() + ingredientTextField.text!.lowercased().dropFirst())
            tableView.reloadData()
        }
    }

    @IBAction func clearButton(_ sender: Any) {
        arrayOfIngredients.removeAll()
        tableView.reloadData()
    }
    
    @IBAction func searchButton(_ sender: UIButton) {
        if arrayOfIngredients.isEmpty {
            // message d'erreur ??
        } else {
            startAnimation()
            recipeService.fetchRequest(ingredients: arrayOfIngredients.joined(separator: ",")) { [weak self] result in
                DispatchQueue.main.async { [self] in
                    switch result {
                    case .success(let recipe) :
                        if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "TableView") as? TableViewController {
                            vc.hits = recipe.hits
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }

    func startAnimation() {
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulseSync, color: .white, padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        loading.startAnimating()
        loadingView.isHidden = false
        loadingView.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            loading.stopAnimating()
            self.loadingView.isHidden = true
        }
    }

    @IBAction func dismiss(_ sender: UITapGestureRecognizer) {
        ingredientTextField.resignFirstResponder()
    }
}

// MARK: - extension TabkeViewCell

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfIngredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"List", for: indexPath)
        cell.textLabel?.text = ". " + arrayOfIngredients[indexPath.row]
        return cell
    }
}
