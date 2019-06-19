//
//  BlockMemberCell.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BlockMemberCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    @IBOutlet weak var viewTest: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
    }

}
