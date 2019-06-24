//
//  ExpectedVisitorCell.swift
//  Finca
//
//  Created by harsh panchal on 19/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ExpectedVisitorCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblVisitorName: UILabel!
    @IBOutlet weak var lblVisitDate: UILabel!
    @IBOutlet weak var lblVisitTime: UILabel!
    @IBOutlet weak var lblVisitorCount: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgVisitorProfile: UIImageView!
    @IBOutlet weak var lblExitTime: UILabel!
    @IBOutlet weak var lblExitDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnEditVisitorDetail: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        mainView.layer.cornerRadius = 7
        mainView.layer.shadowRadius = 4
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowOpacity = 0.5
        // Configure the view for the selected state
    }
    
    func visitTime(time : String) {
        lblVisitTime.text = "Visit Time : " + time
    }
    func visitorCount(Count : String) {
        lblVisitorCount.text = "Visitor Count : " + Count
    }
    func visitorExitDate(extDate : String) {
        lblExitDate.text = "Exit Date : " + extDate
    }
    func visitorExitTime(extTime : String) {
        lblExitTime.text = "Exit Time : " + extTime
    }
}
