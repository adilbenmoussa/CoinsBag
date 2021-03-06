//
//  AppTableViewCell.swift
//  CoinsBagWidget
//
//  Created by Adil Ben Moussa on 08/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

class AppTableViewCell: CoinPresentationCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundView = nil;
        self.backgroundColor = .primary;
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .secondary
        self.selectedBackgroundView = bgColorView
    }
}

