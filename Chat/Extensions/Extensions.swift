//
//  Extensions.swift
//  Chat
//
//  Created by VEENA on 20/04/21.
//

import Foundation
import UIKit

extension UILabel {
    
    public func setRoundedCorner(){
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}

extension UIImageView {
        public func maskCircle(image: UIImage) {
           self.contentMode = UIView.ContentMode.scaleAspectFill
           self.layer.cornerRadius = self.frame.height / 2
           self.layer.masksToBounds = false
           self.clipsToBounds = true
           self.image = image
         }
}

extension UIImageView {
    public func setCorner(value: CGFloat) {
            self.layer.cornerRadius = value
            self.layer.masksToBounds = true
         }
}

extension UIView {
        public func maskCircle() {
           self.contentMode = UIView.ContentMode.scaleAspectFill
           self.layer.cornerRadius = self.frame.height / 2
           self.layer.masksToBounds = false
           self.clipsToBounds = true
         }
}

extension UIView {
    public func setCornerRadius(value: CGFloat) {
            self.layer.cornerRadius = value
            self.layer.masksToBounds = true
         }
}

extension UIView {
    public func setBorder(color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
}

extension UIButton {
        public func roundedButton() {
           self.contentMode = UIView.ContentMode.scaleAspectFill
           self.layer.cornerRadius = self.frame.height / 2
           self.layer.masksToBounds = false
           self.clipsToBounds = true
         }
}

extension UIView {
    public func showProgress(spinner: UIActivityIndicatorView) {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(red: 0.11, green: 0.17, blue: 0.35, alpha: 1.0)
        spinner.startAnimating()
        self.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}

extension UIView {
    public func hideProgress(spinner: UIActivityIndicatorView) {
        spinner.stopAnimating()
    }
}


