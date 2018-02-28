//
//  CurrencyViewController.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 20/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import Foundation
import UIKit

class CurrencyViewController: UITableViewController {
    
    @IBAction func onDoneClicked(_ sender: UIButton) {
       dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 50
        self.tableView.backgroundView = nil;
        self.tableView.backgroundColor = .primary;
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .secondary
        self.navigationController?.navigationBar.barTintColor = .secondary
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CryptoCurrencyKit.Money.allValues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        let money = CryptoCurrencyKit.Money.allValues[indexPath.row]
        cell.backgroundColor = .primary;

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = "\(money.rawValue) - \(money.symbol)"
        cell.textLabel?.font = .primaryLight
        cell.textLabel?.textColor = .white
        
        updateCellCheck(cell: cell, isSelected: DataService.shared.currency.rawValue == money.rawValue)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let money = CryptoCurrencyKit.Money.allValues[indexPath.row]
        DataService.shared.currency = money
        DataService.shared.persistCurrency()
        // reset the persisted coin price sum
        DataService.shared.persistAmount(amout: 0.0)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let money = CryptoCurrencyKit.Money.allValues[indexPath.row]
        updateCellCheck(cell: cell!, isSelected: DataService.shared.currency.rawValue == money.rawValue)
    }
    
    func updateCellCheck(cell: UITableViewCell, isSelected: Bool) {
        let chevron = UIImage(named: "checkmark")
        cell.accessoryType = isSelected ? UITableViewCellAccessoryType.disclosureIndicator : .none
        cell.accessoryView = isSelected ? UIImageView(image: chevron!) : nil
    }
}


