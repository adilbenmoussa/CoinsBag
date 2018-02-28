//
//  SearchCoinViewController.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 15/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation
import UIKit

class SearchCoinViewController: UITableViewController, UISearchBarDelegate {
    var coinsToken: [CoinToken] = []
    var originalCoinsToken: [CoinToken] = []
    let searchController = UISearchController(searchResultsController: nil)
    var sv: UIView? = nil
    
    @IBAction func onDoneClicked(_ sender: UIButton) {
        
        // Gather the selected coinTokens
        var needsPersist = false
        self.coinsToken.forEach { coinToken in
            if coinToken.isSelected! {
                let index = DataService.shared.coins.index(where: { $0.id == coinToken.slug})
                if index == nil {
                    DataService.shared.coins.append(CoinStats(id: coinToken.slug, symbol: coinToken.symbol, name: coinToken.name))
                    needsPersist = true
                }
            }
        }
        
        if needsPersist {
            DataService.shared.persistCoins()
        }
        
        if (sv != nil) {
            self.removeSpinner(spinner: sv!)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.tintColor = .white
        searchController.searchBar.backgroundColor = .primary
        searchController.searchBar.barTintColor = .primary
        
        self.tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
        self.tableView.allowsMultipleSelection = true
        self.tableView.rowHeight = 50
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = .primary;
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .secondary
        self.navigationController?.navigationBar.barTintColor = .secondary
        self.sv = self.displaySpinner()
        CryptoCurrencyKit.fetchAllGeneratedCoins { response in
            switch response {
                case .success(let data): do {
                    // filter out already added coins
                    self.originalCoinsToken = data.filter({ (coinToken: CoinToken) -> Bool in
                        return DataService.shared.coins.index(where: { $0.symbol == coinToken.symbol }) == nil
                    })
                    self.coinsToken = self.originalCoinsToken.map{ $0 }
                    self.removeSpinner(spinner: self.sv!)
                    self.tableView.reloadData()
                    }
                case .failure(let error): do {
                    self.removeSpinner(spinner: self.sv!)
//                    print(error)
                    }
            }
        }
    }
    
    // MARK: - Searchbar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.coinsToken = self.originalCoinsToken.map{ $0 }
        self.tableView.reloadData()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.coinsToken = self.originalCoinsToken.map{ $0 }
            self.tableView.reloadData()
            return
        }
        
        self.coinsToken = self.originalCoinsToken.filter({ (coinToken: CoinToken) -> Bool in
            return coinToken.contains(text: searchText)
        })
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("--> \(self.coinsToken.count)")
        return self.coinsToken.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.backgroundColor = .primary;

        let coinToken = self.coinsToken[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = coinToken.isSelected! ? .checkmark : .none
        cell.textLabel?.text = "\(coinToken.name) (\(coinToken.symbol))"
        cell.textLabel?.font = .primaryLight
        cell.textLabel?.textColor = .white
        
        updateCellCheck(cell: cell, isSelected: coinToken.isSelected!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.updateOriginalSelection(index: indexPath.row, isSelected: (cell?.isSelected)!)
        updateCellCheck(cell: cell!, isSelected: (cell?.isSelected)!)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.updateOriginalSelection(index: indexPath.row, isSelected: (cell?.isSelected)!)
        updateCellCheck(cell: cell!, isSelected: (cell?.isSelected)!)
    }
    
    func updateOriginalSelection(index: Int, isSelected: Bool) {
        let coin = self.coinsToken[index]
        self.coinsToken[index].isSelected = isSelected
        // update oroginal
        if let originalCoinTokenIndex = self.originalCoinsToken.index(where: { $0.symbol == coin.symbol }) {
            self.originalCoinsToken[originalCoinTokenIndex].isSelected = isSelected
        }
    }
    
    func updateCellCheck(cell: UITableViewCell, isSelected: Bool) {
        let chevron = UIImage(named: "checkmark")
        cell.accessoryType = isSelected ? UITableViewCellAccessoryType.disclosureIndicator : .none
        cell.accessoryView = isSelected ? UIImageView(image: chevron!) : nil
    }
}

