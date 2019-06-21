//
//  FloorMemberCell.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class FloorMemberCell: UICollectionViewCell {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var lbTitle: UILabel!
     @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var viewNotification: UIView!
    @IBOutlet weak var lbCountNoti: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewNotification.isHidden = true
    }
    

}
