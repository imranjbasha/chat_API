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

extension UIView {
        public func maskCircle() {
           self.contentMode = UIView.ContentMode.scaleAspectFill
           self.layer.cornerRadius = self.frame.height / 2
           self.layer.masksToBounds = false
           self.clipsToBounds = true
         }

}
