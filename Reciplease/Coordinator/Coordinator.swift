//
//  Coordinator.swift
//  Reciplease
//
//  Created by DAUBERCIES on 07/08/2022.
//

import Foundation
import UIKit

protocol Coordinator {
    
     var childCoordinators: [Coordinator] {get set}
    
    var navigationController: UINavigationController {get set}
    
    func startCoordinator()
}


