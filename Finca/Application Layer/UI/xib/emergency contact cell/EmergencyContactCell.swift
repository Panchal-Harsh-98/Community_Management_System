//
//  EmergencyContactCell.swift
//  Finca
//
//  Created by harsh panchal on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class EmergencyContactCell: UITableViewCell {

    @IBOutlet weak var lblPersonName: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
