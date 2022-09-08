//
//  Storyboarded.swift
//  Reciplease
//
//  Created by DAUBERCIES on 07/08/2022.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    
    static func instantiate() -> Self {
//        let id = String(describing: self)
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        return storyboard.instantiateViewController(withIdentifier: id) as! Self
        
        
        
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
