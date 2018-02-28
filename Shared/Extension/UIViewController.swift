//
//  UIViewController.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 10/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

extension UIViewController {
    func displaySpinner() -> UIView {
        let spinnerView = UIView.init(frame: self.view.bounds)
        spinnerView.backgroundColor = .primary
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            self.view.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    func removeSpinner(spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
