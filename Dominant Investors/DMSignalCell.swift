//
//  DMSignalCell.swift
//  Dominant
//
//  Created by Nekit on 19.02.17.
//  Copyright © 2017 Dominant. All rights reserved.
//

import UIKit

class DMSignalCell: UITableViewCell {
    
    @IBOutlet weak var ticker: UILabel!
    @IBOutlet weak var entryPrice: UILabel!
    @IBOutlet weak var potential: UILabel!
    @IBOutlet weak var stopLoss: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    open func configureWith(model : DMInvestmentSignalModel) {
        
    }
    
}
