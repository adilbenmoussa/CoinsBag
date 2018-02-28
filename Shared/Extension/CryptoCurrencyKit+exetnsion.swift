//
//  CryptoCurrencyKit+exetnsion.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 17/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation

extension CryptoCurrencyKit {
    public static func fetchAllGeneratedCoins(response: ((_ r: ResponseA<CoinToken>) -> Void)?) {
        let urlRequest = URLRequest(url: URL(string: "https://files.coinmarketcap.com/generated/search/quick_search.json")!)
        requestA(urlRequest: urlRequest, response: response)
    }
}




