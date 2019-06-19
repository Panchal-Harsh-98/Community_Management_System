//
//  HomeScreenCvCell.swift
//  Finca
//
//  Created by harsh panchal on 11/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class HomeScreenCvCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imgHomeCell: UIImageView!
    @IBOutlet weak var lblHomeCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewMain.layer.shadowOffset = CGSize.zero
        viewMain.layer.shadowRadius = 13
        viewMain.layer.shadowOpacity = 0.4
        viewMain.layer.masksToBounds = false
        viewMain.layer.cornerRadius = 7
    }

}
