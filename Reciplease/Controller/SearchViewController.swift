//
//  ViewController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import UIKit
import NVActivityIndicatorView

class SearchViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, Storyboarded  {
    
    // MARK: - Properties
    
    @IBOutlet private var ingredientTextField: UITextField!
    @IBOutlet private var addIngredientButton: UIButton!
    @IBOutlet private var clearButton: UIButton!
    @IBOutlet private var searchButton: UIButton!
    @IBOutlet private var tableView: UITableView!
    private let presentingIndicatorTypes = { return NVActivityIndicatorType.allCases.filter { $0 != .blank }}()
    var viewModel = SearchViewModel()
    let loading = NVActivityIndicatorView(frame: .zero, type: .ballPulseSync, color: .white, padding: 0)
    
    var tableViewModel = ResultTableViewModel.shared
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - Methods
        
    override func viewDidLoad() {
        super.viewDidLoad()
        addIngredientButton.addShadow()
        searchButton.addShadow()
        clearButton.addShadow()
        clearButton.applyGradient(colours: [.lightGray, .darkGray])
        addIngredientButton.applyGradient(colours: [.systemYellow, .systemPink])
        navigationController?.delegate = self
        viewModel.displayAlertDelegate = self
        viewModel.delegateNetwork = self
        viewModel.ingredientField.bind {  [weak self] food in
            self?.ingredientTextField.text = food
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //searchButton.applyGradient(colours: [.systemYellow, .systemPink]).frame = searchButton.bounds
        searchButton.ApplyGradientWithAnimation(colours: [.systemYellow, .systemPink])
    }
    

    @IBAction private func AddButton(_ sender: Any) {
        guard let element = ingredientTextField.text else {return }
        viewModel.addIngredient(ingredient: element)
        tableView.reloadData()
    }

    @IBAction private func clearButton(_ sender: Any) {
        viewModel.clearListOfIngredients()
        tableView.reloadData()
    }
    
    @IBAction private func searchButton(_ sender: UIButton) {
        startAnimation()
        viewModel.launchResearch()
    }

    /// Animation during network call
    private func startAnimation() {
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 40),
            loading.heightAnchor.constraint(equalToConstant: 40),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        view.alpha = 0.8
        loading.startAnimating()
    }

    @IBAction private func dismiss(_ sender: UITapGestureRecognizer) {
        ingredientTextField.resignFirstResponder()
    }
}

// MARK: - extension TableViewCell

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfIngredients.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"List", for: indexPath)
        cell.textLabel?.text = ". " + viewModel.arrayOfIngredients.value[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.arrayOfIngredients.value.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

// MARK: - extension networkCall management

extension SearchViewController: NetworkServiceDelegate {
    func didCompleteRequest(result: [Hit]) {
       // if let vc = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController {
            tableViewModel.hits = result
            tableViewModel.nextPage = viewModel.nextPage
            tableViewModel.ingredients = viewModel.arrayOfIngredients.value.joined(separator: ",")
        //    navigationController?.pushViewController(vc, animated: true)
            coordinator?.LaunchSearch()
      //  }
    }
    
    func stopAnimation() {
        loading.stopAnimating()
        view.alpha = 1
    }
}

// MARK: - extension Alert

extension SearchViewController: DisplayAlert {
    func showAlert(message: String) {
        alert(message: message)
    }
}
