//
//  CoinEditViewController.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 16/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

class CoinEditViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var toolBar: UINavigationBar!
    @IBOutlet weak var ownHoldingTitle: UILabel!
    @IBOutlet weak var ownHoldingTextFiled: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    var selectedCoin: CoinStats?
    
    @IBAction func onDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: Any) {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.numberStyle = NumberFormatter.Style.decimal
        if let value: Double = formatter.number(from: self.ownHoldingTextFiled.text!) as? Double {
            selectedCoin?.amount = value
            DataService.shared.swapCoinAndpersistCoins(coin: self.selectedCoin!)
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onAmoutValueChanged(_ sender: Any) {
//        print(self.ownHoldingTextFiled.text ?? "")
//        print(Locale.current)
        if self.ownHoldingTextFiled.text!.isEmpty {
            self.saveButton.isEnabled = true
            self.saveButton.backgroundColor = .green500
            return
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 5
        if let _: Double = formatter.number(from: self.ownHoldingTextFiled.text!) as? Double {
            self.saveButton.isEnabled = true
            self.saveButton.backgroundColor = .green500
        } else {
             self.saveButton.isEnabled = false
            self.saveButton.backgroundColor = .gray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .secondary
        self.navigationController?.navigationBar.barTintColor = .secondary
        
        self.saveButton.layer.borderWidth = 0.5
        self.saveButton.backgroundColor = .green500
        self.saveButton.layer.borderColor = UIColor.white.cgColor
        self.saveButton.layer.cornerRadius = 5.0
        
        self.toolBar.tintColor = .white
        self.toolBar.backgroundColor = .secondary
        self.toolBar.barTintColor = .secondary
        self.view.backgroundColor = .primary;
        self.ownHoldingTitle.font = .primaryBold
        self.ownHoldingTextFiled.borderStyle = UITextBorderStyle.roundedRect;
        self.ownHoldingTextFiled.frame.size.height = 100;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ownHoldingTextFiled.becomeFirstResponder()
        ownHoldingTitle.text = "Own Holdings of (\(selectedCoin?.symbol ?? "---")):"
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 5
        formatter.numberStyle = NumberFormatter.Style.decimal
        let costString = formatter.string(for: selectedCoin?.amount)
        ownHoldingTextFiled.text = costString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


