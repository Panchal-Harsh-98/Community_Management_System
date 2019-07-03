//
//  DocumentCell.swift
//  Finca
//
//  Created by harsh panchal on 25/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var lblDocumentName: UILabel!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
