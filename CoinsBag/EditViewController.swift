//
//  ViewController.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 07/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func onAddCoinClicked(_ sender: Any) {
    }
    
    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSegmenetControlValueChanged(_ sender: Any) {
        if(self.segmentedControl.selectedSegmentIndex == DataService.SettingSegmentMode.currency.rawValue) {
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrencyNavigatonController") as? UINavigationController{
                present(vc, animated: true, completion: nil)
            }
            self.segmentedControl.selectedSegmentIndex = DataService.SettingSegmentMode.ownHoldings.rawValue
        } else {
            self.tableView.setEditing(self.segmentedControl.selectedSegmentIndex == DataService.SettingSegmentMode.deleteOrOrder.rawValue, animated: true)
            DataService.shared.currentSettingSegmentMode = DataService.SettingSegmentMode(rawValue: self.segmentedControl.selectedSegmentIndex)!
            DataService.shared.persistSettingSegmentMode()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.segmentedControl.selectedSegmentIndex = DataService.shared.currentSettingSegmentMode.rawValue
        
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 50
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = .primary;
        // init with edit mode
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .secondary
        self.navigationController?.navigationBar.barTintColor = .secondary
        self.bottomBar.tintColor = .white
        self.bottomBar.backgroundColor = .secondary
        self.bottomBar.barTintColor = .secondary
        if DataService.SettingSegmentMode.deleteOrOrder == DataService.shared.currentSettingSegmentMode {
            self.tableView.setEditing(true, animated: true)
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell", for: indexPath) as! EditCell
        cell.coin = coin
        cell.coinName.text = coin.name
        
        var coinDetails = ""
        if coin.symbol == "BTC" || coin.symbol == "BCH" {
            coinDetails = "\(coin.symbol) x \(String(format:"%.5f", (coin.amount)!))"
        }
        else {
            coinDetails = "\(coin.symbol) x \(String(format:"%.3f", (coin.amount)!))"
        }
        cell.coinSymbol.text = coinDetails
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataService.shared.coins.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            DataService.shared.persistCoins()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = DataService.shared.coins[sourceIndexPath.row]
        DataService.shared.coins.remove(at: sourceIndexPath.row)
        DataService.shared.coins.insert(movedObject, at: destinationIndexPath.row)
        DataService.shared.persistCoins()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Change the selected background view of the cell.
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let coinEditViewController = (segue.destination as! UINavigationController).topViewController as? CoinEditViewController {
            coinEditViewController.selectedCoin = (sender as! EditCell).coin
        }
        
    }
}


