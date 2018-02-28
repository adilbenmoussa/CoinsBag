//
//  EditCell.swift
//  CoinsBag
//
//  Created by Adil Ben Moussa on 15/01/2018.
//  Copyright © 2018 Adil Ben Moussa. All rights reserved.
//

import UIKit

class EditCell: UITableViewCell {
    
    @IBOutlet var coinName: UILabel!
    @IBOutlet var coinSymbol: UILabel!
    var coin: CoinStats?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundView = nil;
        self.backgroundColor = .primary;
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .secondary
        self.selectedBackgroundView = bgColorView
        
        coinName.font = .primaryBold
        
        coinSymbol.font = .secondaryLight
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
