//
//  MainCoordinator.swift
//  Reciplease
//
//  Created by DAUBERCIES on 07/08/2022.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    var navigationController : UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func startCoordinator() {
        
        let initialViewController = SearchViewController.instantiate()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(initialViewController, animated: false)
    }
    
    func LaunchSearch() {
       
        let vc = TableViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
