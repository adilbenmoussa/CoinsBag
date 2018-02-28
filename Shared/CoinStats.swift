//
//  CoinStats.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 13/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation

struct CoinStats {
    let id: String
    let name: String
    let symbol: String
    var amount: Double?
    var ticker: Ticker?
    
    init(id: String, symbol: String, name: String, amount: Double? = 0, ticker: Ticker? = nil) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.amount = amount
        self.ticker = ticker
    }
    
    init?(dictionary : [String:Any]) {
        guard let id = dictionary["id"] else { return nil }
        guard let name = dictionary["name"] else { return nil }
        guard let symbol = dictionary["symbol"] else { return nil }
        guard let amount = dictionary["amount"] else { return nil }
        
        self.init(id: id as! String, symbol: symbol as! String, name: name as! String, amount: amount as? Double)
    }
    
    var propertyListRepresentation : [String:Any] {
        return ["id" : id, "symbol" : symbol, "name" : name, "amount": amount ?? 0]
    }
}

extension CoinStats: Equatable {
    public static func ==(lhs: CoinStats, rhs: CoinStats) -> Bool {
        return lhs.id.hashValue == rhs.id.hashValue
    }
}

extension CoinStats {
    public func format(value: Double) -> String {
        if self.symbol == "BTC" || self.symbol == "BCH" {
            return String(format:"%.5f", value)
        }
        else {
            return String(format:"%.2f", value)
        }
    }
}
