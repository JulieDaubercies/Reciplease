//
//  AlertController.swift
//  Reciplease
//
//  Created by DAUBERCIES on 01/10/2021.
//

import UIKit

extension UIViewController {

    /// Alert message of Network Error
     func alert(message: String) {
        let ac = UIAlertController(title: "Nous rencontrons une erreur", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func animateStar() -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = 2*CGFloat.pi
        animation.duration = 2.0
        animation.speed = 0.5
        animation.repeatCount = Float.infinity
        animation.isRemovedOnCompletion = false
        return animation
    }
}
