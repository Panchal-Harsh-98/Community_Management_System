//
//  BalanceSheetCell.swift
//  Finca
//
//  Created by harsh panchal on 08/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BalanceSheetCell: UITableViewCell {

    @IBOutlet weak var lblBalanceAmount: UILabel!
    @IBOutlet weak var lblSheetName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
