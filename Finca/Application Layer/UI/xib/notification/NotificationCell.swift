//
//  NotificationCell.swift
//  Finca
//
//  Created by anjali on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class NotificationCell: UICollectionViewCell {
    @IBOutlet weak var bDelete: UIButton!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    
    @IBOutlet weak var lbDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
