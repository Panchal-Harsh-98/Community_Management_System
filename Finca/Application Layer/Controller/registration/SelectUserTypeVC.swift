//
//  SelectUserTypeVC.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class SelectUserTypeVC: BaseVC {

    @IBOutlet weak var bBack: UIButton!
     var society_id:String!
    var mobileNumber:String!
    @IBOutlet weak var ivRenter: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        changeButtonImageColor(btn: bBack, image: "back", color: ColorConstant.primaryColor)
        
    ivRenter.setImageColor(color: UIColor.white)
    }
    

    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onClickOwned(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
        vc.userType = "1"
        vc.society_id = society_id
      vc.mobileNumber = mobileNumber
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickRented(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idOwnedDataSelectVC") as! OwnedDataSelectVC
        vc.userType = "3"
        vc.society_id = society_id
        vc.mobileNumber = mobileNumber
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
