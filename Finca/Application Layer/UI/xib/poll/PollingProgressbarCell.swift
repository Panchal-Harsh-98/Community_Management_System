//
//  PollingProgressbarCell.swift
//  Finca
//
//  Created by harsh panchal on 05/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class PollingProgressbarCell: UITableViewCell {

    @IBOutlet weak var lblOptionName: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var lblPercentageProgress: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
