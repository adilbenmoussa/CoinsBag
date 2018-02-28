//
//  CoinPresentationCell.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 20/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//


import UIKit

protocol UITableViewCellProtocol{
    func needsReleoad()
}

class CoinPresentationCell: UITableViewCell {
    
    @IBOutlet var symbol: UILabel!
    @IBOutlet var coinValue: UILabel!
    @IBOutlet var coinAmount: UILabel!
    @IBOutlet var coinAmountText: UILabel!
    @IBOutlet var profitButton: UIButton!
    
    var coin: CoinStats?
    
    var delegate: UITableViewCellProtocol?
    
    @IBAction func toggleViewMode(_ sender: Any) {
        if (DataService.shared.buttonMode == DataService.ButtoMode.sum) {
            DataService.shared.buttonMode = DataService.ButtoMode.percentage
        }
        else {
            DataService.shared.buttonMode = DataService.ButtoMode.sum
        }
        DataService.shared.persistButtonPriceMode()
        delegate?.needsReleoad()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        symbol.font = .primaryBold
        coinValue.font = .primaryBold
        
        coinAmountText.font = .secondaryLight
        coinAmount.font = .secondaryLight
        
        profitButton.layer.borderWidth = 0.5
        profitButton.backgroundColor = .primary
        profitButton.layer.borderColor = UIColor.white.cgColor
        profitButton.layer.cornerRadius = 5.0
    }
    
    
    public func updateContent(loading: Bool = false) {
        coinAmount.text = loading ? "---" : coin?.format(value: coin!.amount!)
        symbol.text = coin!.symbol
        
        if (coin!.ticker != nil) {
            if let price = coin!.ticker?.price(for: DataService.shared.currency) {
                coinValue.text = String(format:"%@ %f", DataService.shared.currency.symbol, price)
            } else {
                coinValue.text = "---"
            }
        }
        
        // Button
        updateButtonContent()
    }
    
    func updateButtonContent() {
        let buttonMode = DataService.shared.buttonMode
        if (buttonMode == DataService.ButtoMode.sum) {
            if let price = coin!.ticker?.price(for: DataService.shared.currency) {
                let sum = coin!.amount! * price
                if(sum > 10000000){
                    profitButton.setTitle(String(format:"%@ %.f", DataService.shared.currency.symbol, sum), for: UIControlState.normal)
                } else {
                    profitButton.setTitle(String(format:"%@ %.2f", DataService.shared.currency.symbol, sum), for: UIControlState.normal)
                }
                
            } else {
                profitButton.setTitle("---", for: UIControlState.normal)
            }
        }
        else if (buttonMode == DataService.ButtoMode.percentage) {
            if let percentage24 = coin!.ticker?.percentChange24h {
                profitButton.setTitle("\(String(format:"%.2f", percentage24)) %", for: UIControlState.normal)
            } else {
                profitButton.setTitle("---", for: UIControlState.normal)
            }
        }
        
        if let percentage24 = coin!.ticker?.percentChange24h {
            profitButton.backgroundColor = percentage24 < 0 ? .red500 : .green500
        }
    }
}

