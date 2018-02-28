//
//  UIView.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 20/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

extension UIView {
    func setTopBorder(color: UIColor){
        let topBborder = CALayer()
        topBborder.borderColor = color.withAlphaComponent(0.2).cgColor
        topBborder.frame = CGRect(x: 0, y: 0.0, width:  self.frame.size.width, height: 1.0)
        topBborder.borderWidth = 1.0
        
        self.layer.addSublayer(topBborder)
        self.layer.masksToBounds = true
    }
    
    func setBottomBorder(color: UIColor){
        let bottomBborder = CALayer()
        bottomBborder.borderColor = color.withAlphaComponent(0.2).cgColor
        bottomBborder.frame = CGRect(x: 0.0, y: self.frame.size.height - 1.0, width: self.frame.size.width, height: 1.0)
        bottomBborder.borderWidth = 1.0
        
        self.layer.addSublayer(bottomBborder)
        self.layer.masksToBounds = true
    }
}

