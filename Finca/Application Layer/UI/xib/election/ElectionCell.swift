//
//  ElectionCell.swift
//  Finca
//
//  Created by harsh panchal on 26/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ElectionCell: UITableViewCell {

    @IBOutlet weak var lblstatus: UILabel!
    @IBOutlet weak var lblElectionName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
