//
//  SendChatCell.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class SendChatCell: UITableViewCell {
    @IBOutlet weak var lbMessage: UILabel!
    
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
