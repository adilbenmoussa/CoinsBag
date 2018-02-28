//
//  CoinToken.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 17/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation

public struct CoinToken {
    public let slug: String
    public let name: String
    public let symbol: String
    public let tokens: [String]
    public var isSelected: Bool?
    
    enum CoinTokenKeys: String, CodingKey {
        case slug
        case name
        case symbol
        case tokens
        case isSelected
    }
    
    func contains (text: String) -> Bool {
        let lowercasedText = text.lowercased()
        return self.name.lowercased().contains(lowercasedText) ||
            self.symbol.lowercased().contains(lowercasedText) ||
            self.slug.lowercased().contains(lowercasedText)
    }
}

extension CoinToken: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CoinTokenKeys.self)
        slug = try values.decode(String.self, forKey: .slug)
        name = try values.decode(String.self, forKey: .name)
        symbol = try values.decode(String.self, forKey: .symbol)
        tokens =  try values.decode([String].self, forKey: .tokens) as [String]
        isSelected = false
    }
}

extension CoinToken: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CoinTokenKeys.self)
        try container.encode(slug, forKey: .slug)
        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(tokens, forKey: .tokens)
        try container.encode(isSelected, forKey: .isSelected)
    }
}
