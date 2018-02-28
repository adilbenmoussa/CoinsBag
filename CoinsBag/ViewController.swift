//
//  ViewController.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 07/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITableViewCellProtocol {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailsViewContainer: UIView!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var marketCapTItle: UILabel!
    @IBOutlet weak var marketCapValue: UILabel!
    @IBOutlet weak var volume24Title: UILabel!
    @IBOutlet weak var volume24Value: UILabel!
    @IBOutlet weak var circulatingSupplyTitle: UILabel!
    @IBOutlet weak var circulatingSupplyValue: UILabel!
    @IBOutlet weak var profitValue: UILabel!
    @IBOutlet weak var coinNameValue: UILabel!
    var selectedCoin: CoinStats?
    var loading: Bool = false
    var tasksMap: [String: Bool] = [:]
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.bootstrapCoins), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.bootstrapCoins()
    }
    
    @objc func bootstrapCoins() {
        selectedCoin = nil
        DataService.shared.resetTickers()
        updateCoinDetailsUI()
        detailsView.isHidden = true
        loadingIndicator.startAnimating()
        fetchTickers()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        selectedCoin = nil
        DataService.shared.resetTickers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = .primary;

        self.tableView.addSubview(self.refreshControl)
        
        //  calculate 65% of the screen height
        // small screens
        let isSmall = UIScreen.main.bounds.height <= 568.0
        let preferedTableHeight = UIScreen.main.bounds.height * (isSmall ? 0.55 : 0.65)
        self.tableHeightConstraint.constant = preferedTableHeight;
        self.tableView.rowHeight = 60
        self.tableView.needsUpdateConstraints()
        
        self.detailsView.backgroundColor = .secondary
        self.detailsViewContainer.backgroundColor = .secondary
        self.detailsViewContainer.setTopBorder(color: .white)
        
        self.bottomBar.tintColor = .white
        self.bottomBar.backgroundColor = .secondary
        self.bottomBar.barTintColor = .secondary
        
        self.coinNameValue.font = .primaryBold
        self.coinNameValue.setBottomShadow(color: UIColor.darkGray)
        
        self.marketCapTItle.font = .primaryLight
        self.marketCapValue.font = .primaryBold
        
        self.volume24Title.font = .primaryLight
        self.volume24Value.font = .primaryBold
        
        self.profitValue.font = .primaryExtraLight
        
        self.circulatingSupplyTitle.font = .primaryLight
        self.circulatingSupplyValue.font = .primaryBold
        
        self.bottomBar.setTopBorder(color: .white)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        self.refreshControl.endRefreshing()
        self.detailsView.isHidden = false
        self.loadingIndicator.stopAnimating()
        self.setCoinFromExternal()
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
    
    func setCoinFromExternal() {
        if DataService.shared.selectedCoinIdFromExtension != nil {
            // find the coin
            if let index = DataService.shared.coins.index(where: {$0.id == DataService.shared.selectedCoinIdFromExtension}) {
                self.selectedCoin = DataService.shared.coins[index]
                self.tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
                self.updateCoinDetailsUI()
            }
            DataService.shared.selectedCoinIdFromExtension = nil
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
    
    // MARK pull to refresh
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ViewController.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.white
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        DataService.shared.resetTickers()
        bootstrapCoins()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppTableViewCell", for: indexPath)  as! AppTableViewCell
        cell.coin = coin
        cell.delegate = self
        cell.updateContent(loading: loading)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCoin = DataService.shared.coins[indexPath.row]
        updateCoinDetailsUI()
    }
    
    func updateCoinDetailsUI() {
        if (self.selectedCoin != nil) {
            self.coinNameValue.text = self.selectedCoin?.name ?? "---"
            if let marketCap = self.selectedCoin?.ticker?.marketCap(for: DataService.shared.currency) {
                self.marketCapValue.text = String(format:"%@%0.f", DataService.shared.currency.symbol, marketCap)
                
            } else {
                self.marketCapValue.text = "---"
            }
            
            if let volume24 = self.selectedCoin?.ticker?.volume24h(for: DataService.shared.currency) {
                self.volume24Value.text = String(format:"%@%0.f", DataService.shared.currency.symbol, volume24)
            } else {
                self.volume24Value.text = "---"
            }
            
            if let totalSupply = self.selectedCoin?.ticker?.totalSupply {
                self.circulatingSupplyValue.text = String(format:"%0.f (%@)", totalSupply, (self.selectedCoin?.symbol ?? ""))
            } else {
                self.circulatingSupplyValue.text = "---"
            }
        } else {
            self.coinNameValue.text = "Select a Coin"
            self.marketCapValue.text = "---"
            self.volume24Value.text = "---"
            self.circulatingSupplyValue.text = "---"
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
            self.bottomBar.backgroundColor = .red500
            self.bottomBar.barTintColor = .red500
        }
        else if (persistedAmount > 0 && diff > 0){
            diffString = " (+ \(String(format:"%@%.f",DataService.shared.currency.symbol, abs(diff))) )"
            displayValue = String(format:"%@%.2f %@", DataService.shared.currency.symbol, sum, diffString)
            self.bottomBar.backgroundColor = .green500
            self.bottomBar.barTintColor = .green500
        } else {
            displayValue = String(format:"%@%.2f", DataService.shared.currency.symbol, sum)
            self.bottomBar.backgroundColor = .secondary
            self.bottomBar.barTintColor = .secondary
        }
        self.profitValue.text = displayValue
        DataService.shared.persistAmount(amout: sum)
    }
    
    func needsReleoad() {
        tableView.reloadData()
    }
}

