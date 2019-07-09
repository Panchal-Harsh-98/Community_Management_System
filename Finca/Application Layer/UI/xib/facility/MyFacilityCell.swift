//
//  MyFacilityCell.swift
//  Finca
//
//  Created by anjali on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class MyFacilityCell: UICollectionViewCell {
    @IBOutlet weak var ivImage: UIImageView!
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var lbEndDate: UILabel!
    @IBOutlet weak var lbTotalPerson: UILabel!
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
