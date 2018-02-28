//
//  NSBundle.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 14/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation

extension Bundle {
    
    class func documents() -> String! {
        let dirs: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as [AnyObject]
        return dirs[0] as? String
    }
    
    class func readPlistAsArray(filename: String, fromDocumentsFolder: Bool=false) -> NSArray? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            return NSArray(contentsOfFile: path)
        }
        return nil
    }
    
    class func readPlistAsDictionary(filename: String, fromDocumentsFolder: Bool=false) -> NSDictionary? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            return NSDictionary(contentsOfFile: path)
        }
        return nil
    }
}
