//
//  VotingCell.swift
//  Finca
//
//  Created by harsh panchal on 28/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class VotingCell: UITableViewCell {

    @IBOutlet weak var lblNomineeName: UILabel!
    @IBOutlet weak var ImageRadio: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
