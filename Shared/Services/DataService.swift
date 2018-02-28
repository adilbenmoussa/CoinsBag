//
//  DataService.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 13/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation

enum TickerResponse<T: Codable> {
    case failure(error: Error)
    case success(T)
}

final class DataService {
    
    // *****************************************************************************************
    // !!! This is defined for simplicity sake, using singletons isn't advised               !!!
    // *****************************************************************************************
    
    // MARK: Shared Instance
    static let shared = DataService()
    
    // MARK: Local Variable
    var coins: [CoinStats]
    var userDefaults: UserDefaults!
    var selectedCoinIdFromExtension: String?
    
    var currency:CryptoCurrencyKit.Money!
    
    public enum SettingSegmentMode: Int {
        case ownHoldings = 0
        case deleteOrOrder = 1
        case currency = 2
    }
    
    var currentSettingSegmentMode = SettingSegmentMode.ownHoldings
    
    public enum ButtoMode: Int {
        case sum =  0
        case percentage = 1
    }
    var buttonMode = ButtoMode.sum
    
    // Can't init is singleton
    private init() {
        self.userDefaults = UserDefaults(suiteName: kSuiteName)!
        self.coins = []
    }
    
    public func bootstrap() {
        self.loadSettings()
    }
    
    private func loadSettings() {
        if let propertylistCoins = self.userDefaults.object(forKey: kSavedCoins) as? [[String:Any]] {
            self.coins = propertylistCoins.flatMap{ CoinStats(dictionary: $0) }
        } else {
            // gather the default coins
            self.coins = kDefaultCoins.map{ $0 }
            persistCoins()
        }
        
        loadPersistedButtonPriceMode()
        loadSettingSegmentMode()
        loadCurrency()
    }
    
    public func sumCoinsValue() -> Double {
        var sum = 0.0
        self.coins.forEach { coin in
            if(coin.ticker != nil) {
                let currentCoinValue = (coin.amount ?? 0) * (coin.ticker?.price(for: DataService.shared.currency) ?? 0.0)
                sum = sum + currentCoinValue
            }
        }
        return sum
    }
    
    // Mark Ticker Data
    func replaceTickerInCoinStats(ticker: Ticker) {
        if let index = self.coins.index(where: { $0.id == ticker.id }) {
            self.coins[index].ticker = ticker
        }
    }
    
    // Mark persist
    func swapCoinAndpersistCoins(coin: CoinStats) {
        if let index = self.coins.index(of: coin) {
            self.coins[index] = coin
            let propertylistCoins = self.coins.map{ $0.propertyListRepresentation }
            self.userDefaults.set(propertylistCoins, forKey: kSavedCoins)
            self.userDefaults.synchronize()
        }
    }
    
    public func persistCoins() {
        let propertylistCoins = self.coins.map{ $0.propertyListRepresentation }
        self.userDefaults.set(propertylistCoins, forKey: kSavedCoins)
        self.userDefaults.synchronize()
    }
    
    public func persistAmount(amout: Double) {
        self.userDefaults.set(amout, forKey: kSavedAmount)
        self.userDefaults.synchronize()
    }
    
    public func getPersistedAmount() -> Double {
        if let amount = self.userDefaults.object(forKey: kSavedAmount) as? Double {
            return amount
        }
        return 0.0
    }
    
    public func resetTickers() {
        for i in 0...(self.coins.count - 1) {
            self.coins[i].ticker = nil
        }
    }
    
    public func loadPersistedButtonPriceMode() {
        var mode = 0;
        if let modeValue = self.userDefaults.object(forKey: kButtonPriceMode) as? Int {
            mode = modeValue;
        }
        buttonMode = ButtoMode(rawValue: mode)!
    }
    
    public func persistButtonPriceMode() {
        self.userDefaults.set(buttonMode.rawValue, forKey: kButtonPriceMode)
        self.userDefaults.synchronize()
    }
    
    public func loadSettingSegmentMode() {
        var mode = 0;
        if let modeValue = self.userDefaults.object(forKey: kSettingSegmentMode) as? Int {
            mode = modeValue;
        }
        currentSettingSegmentMode = SettingSegmentMode(rawValue: mode)!
    }
    
    public func persistSettingSegmentMode() {
        self.userDefaults.set(currentSettingSegmentMode.rawValue, forKey: kSettingSegmentMode)
        self.userDefaults.synchronize()
    }
    
    public func loadCurrency() {
        var _currency: CryptoCurrencyKit.Money!
        if let c =  CryptoCurrencyKit.Money(rawValue: Locale.current.currencyCode!) {
            _currency = c
        }
        else {
           _currency = CryptoCurrencyKit.Money.eur
        }
        if let value = self.userDefaults.object(forKey: kSettingCurrency) as? String {
            _currency = CryptoCurrencyKit.Money(rawValue: value)!
        }
        currency = _currency
        persistCurrency()
    }
    
    public func persistCurrency() {
        self.userDefaults.set(currency.rawValue, forKey: kSettingCurrency)
        self.userDefaults.synchronize()
    }
    
}

