//
//  EventCell.swift
//  Finca
//
//  Created by anjali on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbDesc: UILabel!
    @IBOutlet weak var lbAttending: UILabel!
    
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbMonth: UILabel!
    @IBOutlet weak var lbYear: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
