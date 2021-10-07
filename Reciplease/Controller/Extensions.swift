//
//  Extensions.swift
//  Reciplease
//
//  Created by DAUBERCIES on 28/09/2021.
//

import Foundation
import UIKit


extension String {
    
    /// Extension for conversion of URL image into data in DetailViewController
    var data: Data? {
        guard let url = URL(string: self) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        return data
    }

    ///Extension to avoid blank entry in textfield
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespaces) == String() ? true : false
    }
}

///  Extension to custumize picture in DetailViewController
extension UIImage {
var circleMask: UIImage {
    let square = size.width > size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
    let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    imageView.image = self
    imageView.layer.cornerRadius = square.width/2
    imageView.layer.borderColor = UIColor.white.cgColor
    imageView.layer.borderWidth = 5
    imageView.layer.masksToBounds = true
    UIGraphicsBeginImageContext(imageView.bounds.size)
    imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
    let result = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return result
    }
}

/// Extension to custumize Button in SearchViewController and DetailViewController
extension UIButton {
    func addCornerRadius() {
        let button: UIButton
        button = self
        button.layer.cornerRadius = 10
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 1)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.5
        button.layer.masksToBounds = false
    }

    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.cornerRadius = 10
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}




//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}


//    @discardableResult
//    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
//        return self.applyGradient(colours: colours, locations: nil)
//    }
//
//    @discardableResult
//    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.frame = self.bounds
//       // gradient.colors = [UIColor.systemYellow.cgColor, UIColor.systemPink.cgColor]
//       // gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        gradient.colors = colours.map { $0.cgColor }
//        gradient.locations = locations
//        gradient.cornerRadius = 10
//        self.layer.insertSublayer(gradient, at: 0)
//        return gradient
//    }
