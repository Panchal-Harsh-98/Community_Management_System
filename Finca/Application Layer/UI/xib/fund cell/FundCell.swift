//
//  FundCell.swift
//  Finca
//
//  Created by harsh panchal on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class FundCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblExpense: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
