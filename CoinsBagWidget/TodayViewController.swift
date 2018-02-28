//
//  TodayViewController.swift
//  CoinsBagWidget
//
//  Created by Adil Ben Moussa on 07/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDataSource,UITableViewDelegate, UITableViewCellProtocol{
    
    @IBOutlet weak var profitValue: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var tasksMap: [String: Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 56
        self.profitValue.font = .primaryExtraBold
        // Init the data service
        DataService.shared.bootstrap()
        
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        }
    }
    
    // MARK: - NCWidgetProviding
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        fetchTickers()
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
        return UIEdgeInsets.zero
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: maxSize.width, height: 300)
        }
        else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
    }
    
    // UITableViewCellProtocol
    func needsReleoad() {
        tableView.reloadData()
    }
    
    // MARK TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.shared.coins.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = DataService.shared.coins[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetTableViewCell", for: indexPath) as! WidgetTableViewCell
        cell.coin = coin
        cell.delegate = self
        cell.updateContent(loading: false)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        let coin = DataService.shared.coins[indexPath.row]
        let url =  URL(string:"\(kAppURLScheme)://\(coin.id)")
        self.extensionContext?.open(url!, completionHandler:{(success: Bool) -> Void in
//            print("App opened...")
        })
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Mark Tickers
    // Just copied from the app view controller. this needs to be shared in the future
    func reloadIfNeeded() {
        var canReload = true
        tasksMap.forEach { (key: String, value: Bool ) in
            if(!value){
                canReload = false
            }
        }
        
        if (canReload){
            reload()
        }
    }
    
    func reload() {
        self.tableView.reloadData()
        self.updateUserSum()
        self.tasksMap = [:]
    }
    
    func fetchTicker(coin: CoinStats) {
        tasksMap[coin.id] = false
        CryptoCurrencyKit.fetchTicker(coinId: coin.id, convert: DataService.shared.currency) { (response) in
            switch response {
            case .success(let ticker):
                DataService.shared.replaceTickerInCoinStats(ticker: ticker)
                self.tasksMap[coin.id] = true
                self.reloadIfNeeded()
            case .failure(_):
                self.tasksMap[coin.id] = true
                self.reloadIfNeeded()
            }
        }
    }
    
    // Fetsh
    func fetchTickers() {
        CryptoCurrencyKit.fetchTickers (convert: DataService.shared.currency) { response in
            switch response {
            case .success(let data): do {
                data.forEach { ticker in
                    DataService.shared.replaceTickerInCoinStats(ticker: ticker)
                }
                let leftOvers = DataService.shared.coins.filter{ (coin: CoinStats) -> Bool in
                    return coin.ticker == nil
                }
                
                leftOvers.forEach { coin in
                    if( coin.ticker == nil) {
                        self.fetchTicker(coin: coin)
                    }
                }
                
                // update when no left over are done
                if(leftOvers.count == 0) {
                    self.reload()
                }
                }
                
            case .failure(let error): do {
                print(error)
                }
            }
        }
    }
    
    func updateUserSum() {
        let sum = DataService.shared.sumCoinsValue()
        let persistedAmount = DataService.shared.getPersistedAmount()
        let diff = sum - persistedAmount
        var diffString = ""
        var displayValue = ""
        if (persistedAmount > 0 && diff < 0) {
            diffString = " (- \(String(format:"%@%.f",DataService.shared.currency.symbol, abs(diff))) )"
            displayValue = String(format:"%@%.2f %@", DataService.shared.currency.symbol, sum, diffString)
            self.profitValue.textColor = .red
        }
        else if (persistedAmount > 0 && diff > 0){
            diffString = " (+ \(String(format:"%@%.f",DataService.shared.currency.symbol, abs(diff))) )"
            displayValue = String(format:"%@%.2f %@", DataService.shared.currency.symbol, sum, diffString)
            self.profitValue.textColor = .green500
        } else {
            displayValue = String(format:"%@%.2f", DataService.shared.currency.symbol, sum)
            self.profitValue.textColor = .todataWidgetPrimary
        }
        self.profitValue.text = displayValue
        DataService.shared.persistAmount(amout: sum)
    }
}

