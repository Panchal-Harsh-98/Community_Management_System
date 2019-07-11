//
//  AddNoOfUnitDialog.swift
//  Finca
//
//  Created by harsh panchal on 11/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class AddNoOfUnitDialog: UIViewController {

    @IBOutlet weak var tfTextField: UITextField!
    var billDetail : Bill_Model!
    @IBOutlet weak var lblUnitPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUnitPrice.text =  "Unit Price : "+StringConstants.RUPEE_SYMBOL+billDetail.unitPrice
        
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        doCallAddunitApi()
            
        
        
    }
    func doCallAddunitApi(){
        
    }
}
