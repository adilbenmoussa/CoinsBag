//
//  UILabel.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 15/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func setBottomShadow(color: UIColor) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowOpacity = 2.0
        self.layer.shadowRadius = 2.0
    }
}
