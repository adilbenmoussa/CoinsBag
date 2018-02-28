//
//  WidgetTableViewCell.swift
//  CoinsBagWidget
//
//  Created by Adil Ben Moussa on 08/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

class WidgetTableViewCell: CoinPresentationCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profitButton.backgroundColor = .todataWidgetPrimary
    }
}
