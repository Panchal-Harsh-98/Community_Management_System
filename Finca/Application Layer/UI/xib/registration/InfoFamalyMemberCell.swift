//
//  InfoFamalyMemberCell.swift
//  Finca
//
//  Created by anjali on 04/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class InfoFamalyMemberCell: UICollectionViewCell {

    @IBOutlet weak var lbName: UILabel!
     @IBOutlet weak var lbMobile: UILabel!
     @IBOutlet weak var lbReletion: UILabel!
    
    @IBOutlet weak var rightCon: NSLayoutConstraint!
    @IBOutlet weak var bDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bDelete.isHidden = true
    }

}
