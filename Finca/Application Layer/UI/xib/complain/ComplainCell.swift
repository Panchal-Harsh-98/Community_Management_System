//
//  ComplainCell.swift
//  Finca
//
//  Created by harsh panchal on 02/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ComplainCell: UITableViewCell {

    @IBOutlet weak var lblCmpDate: UILabel!
    @IBOutlet weak var lblCmpStatus: UILabel!
    @IBOutlet weak var lblCmpTitle: UILabel!
    @IBOutlet weak var lblCmpDesc: UILabel!
    @IBOutlet weak var lblCmpAdminMsg: UILabel!
    @IBOutlet weak var viewBtnEdit: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
