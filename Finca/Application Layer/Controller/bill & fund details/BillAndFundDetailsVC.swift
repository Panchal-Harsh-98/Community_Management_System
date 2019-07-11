//
//  BillAndFundDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 14/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BillAndFundDetailsVC: BaseVC {
    var maintainanceList : Maintenance_Model!
    var billList : Bill_Model!
    @IBOutlet weak var lblBillHolderName: UILabel!
    @IBOutlet weak var lblBillHolderEmail: UILabel!
    @IBOutlet weak var lblpaymentStatus: UILabel!
    @IBOutlet weak var lblMaintenanceFor: UILabel!
    @IBOutlet weak var lblMaintenanceDate: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var lblPaymentDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(maintainanceList.maintenanceName!)
        lblpaymentStatus.layer.cornerRadius = 10
        lblpaymentStatus.layer.masksToBounds = true
        lblAmount.layer.masksToBounds = true
        lblAmount.layer.cornerRadius = 20
        lblBillHolderName.text = doGetLocalDataUser().user_full_name!
        lblBillHolderEmail.text = doGetLocalDataUser().user_email!
        lblMaintenanceFor.text = maintainanceList.maintenanceName
        lblMaintenanceDate.text = maintainanceList.createdDate
        lblDueDate.text = maintainanceList.endDate
        lblPaymentDate.text = maintainanceList.receiveMaintenanceDate
        lblDescription.text = maintainanceList.maintenanceDescription
        lblAmount.text = maintainanceList.maintenceAmount
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnPay(_ sender: UIButton) {
        
        self.toast(message: "Admin will contact you soon!!!!", type: 0)
    }
}
