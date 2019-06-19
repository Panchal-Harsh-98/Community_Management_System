//
//  NavigationMenuCell.swift
//  Finca
//
//  Created by harsh panchal on 30/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class NavigationMenuCell: UITableViewCell {

    @IBOutlet weak var lblMenuItemName: UILabel!
    @IBOutlet weak var imgMenuItem: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
