//
//  UIColorExtension.swift
//  ArcMap
//
//  Created by Igor Eydman on 4/22/18.
//  Copyright © 2018 Igor Eydman. All rights reserved.
//

import UIKit

extension UIColor{
    public convenience init(r: Int, g: Int, b: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    
    static var customWhite: UIColor {
        return UIColor(red:0.85, green:0.85, blue:0.85, alpha:1.0)
    }
    static var customBlack: UIColor {
        return UIColor(red:0.20, green:0.18, blue:0.22, alpha:1.0)
    }
}
