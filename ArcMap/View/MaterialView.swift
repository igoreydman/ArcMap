//
//  MaterialView.swift
//  ArcMap
//
//  Created by Igor Eydman on 4/22/18.
//  Copyright © 2018 Igor Eydman. All rights reserved.
//

import UIKit

class MaterialView: UIView {
    
    override func awakeFromNib() {
        //self.layer.cornerRadius = 3.0
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        //self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        
    }
}
