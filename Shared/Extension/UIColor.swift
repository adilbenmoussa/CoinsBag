//
//  UIColor.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 14/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation

import UIKit

extension UIColor {
    
    class func hexStringToUIColor (hex:Int) -> UIColor {
        return UIColor(
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 08) & 0xff) / 255,
            blue: CGFloat((hex >> 00) & 0xff) / 255,
            alpha: 1
        )
    }
    
    // https://material.angularjs.org/1.1.4/demo/colors
    static let primary = UIColor.hexStringToUIColor(hex:0x0277BD)
    static let secondary = UIColor.hexStringToUIColor(hex:0x0288D1)
    static let tertiary = UIColor.hexStringToUIColor(hex:0x2196F3)
    static let green500 = UIColor.hexStringToUIColor(hex:0x4CAF50)
    static let red500 = UIColor.hexStringToUIColor(hex:0xF44336)
    
    static let todataWidgetPrimary = UIColor.black.withAlphaComponent(0.75)
    static let todataWidgetSecondary = UIColor.hexStringToUIColor(hex:0x005E88)
}
