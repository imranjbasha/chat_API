//
//  Extensions.swift
//  Chat
//
//  Created by VEENA on 20/04/21.
//

import Foundation
import UIKit

extension UILabel {
    
    func setRoundedCorner(){
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
    }
}
