//
//  VisitorArrivedCell.swift
//  Finca
//
//  Created by harsh panchal on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class VisitorArrivedCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblVisitorName: UILabel!
    @IBOutlet weak var lblPaxWithVisitor: UILabel!
    @IBOutlet weak var lblVisitorStatus: UILabel!
    @IBOutlet weak var lblVisitorArrivedTime: UILabel!
    @IBOutlet weak var lblVisitorImage: UIImageView!
    @IBOutlet weak var ViewBtnPanel: UIView!
    @IBOutlet weak var btnPanelHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.cornerRadius = 5
        mainView.layer.shadowRadius = 5
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowOpacity = 0.4
        mainView.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
