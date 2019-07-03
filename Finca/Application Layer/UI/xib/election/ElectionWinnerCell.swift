//
//  ElectionWinnerCell.swift
//  Finca
//
//  Created by harsh panchal on 27/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ElectionWinnerCell: UITableViewCell {

    @IBOutlet weak var lblNomineeName: UILabel!
    @IBOutlet weak var lblVoteCount: UILabel!
    @IBOutlet weak var imgWinnerBackground: UIImageView!
    @IBOutlet weak var mainView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.cornerRadius = 5
        mainView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOpacity = 0.6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
