//
//  ProfileVC.swift
//  Finca
//
//  Created by anjali on 20/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseAllPayment:Codable {
   var message: String!//  "message" : "Get success.",
    var bill: String!//   "bill" : "0.00",
    var status: String!//   "status" : "200",
    var total: String!//   "total" : "20.00",
    var maintenance: String!//   "maintenance" : "20.00"
}

class ProfileVC: BaseVC {
    @IBOutlet weak var bMenu: UIButton!
     @IBOutlet weak var ivProfile: UIImageView!
    
    @IBOutlet weak var lbResidentNumber: UILabel!
    @IBOutlet weak var lbUnpaidMaintence: UILabel!
    @IBOutlet weak var lbUnpaidBill: UILabel!
    @IBOutlet weak var lbDue: UILabel!
    
    @IBOutlet weak var switchOwner: UISwitch!
    @IBOutlet weak var switchApartment: UISwitch!
    @IBOutlet weak var tfName: ACFloatingTextfield!
    @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    @IBOutlet weak var bMember: UIButton!
    @IBOutlet weak var bNumber: UIButton!
    @IBOutlet weak var cvNumber: UICollectionView!
    @IBOutlet weak var cvMember: UICollectionView!
    
    @IBOutlet weak var viewMaintance: UIView!
    @IBOutlet weak var heightConstrainstMember: NSLayoutConstraint!
    @IBOutlet weak var heightConstrainstNumber: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          doInintialRevelController(bMenu: bMenu)
        
        initUI()
    }
    
    func  initUI() {
        
        
        Utils.setRoundImageWithBorder(imageView: ivProfile, color: UIColor.red)
        
        Utils.setImageFromUrl(imageView: ivProfile, urlString: doGetLocalDataUser().user_profile_pic)
        
        lbResidentNumber.text = doGetLocalDataUser().block_name + "-" + doGetLocalDataUser().unit_name
        
         tfName.text = doGetLocalDataUser().user_first_name
        tfLastName.text = doGetLocalDataUser().user_last_name
        tfMobile.text = doGetLocalDataUser().user_mobile
        tfEmail.text = doGetLocalDataUser().user_email
        
        
        if doGetLocalDataUser().user_type == "0" {
            //owner
            switchOwner.isOn = false
            
        } else {
             //tenent
             switchOwner.isOn = true
            
        }
        
        doDisbleUI()
        doMaintence()
    }
    func doMaintence() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "userDetail":"userDetail",
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getUserPaymentData, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseAllPayment.self, from:json!)
                    
                    
                    if response.status == "200" {
                         self.lbUnpaidMaintence.text = response.maintenance
                        self.lbUnpaidBill.text = response.bill
                        self.lbDue.text = response.total
                        
                        
                    }else {
                        self.viewMaintance.isHidden = true
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func doDisbleUI() {
        tfName.textColor = UIColor(named: "grey_60")
         tfLastName.textColor = UIColor(named: "grey_60")
         tfMobile.textColor = UIColor(named: "grey_60")
         tfEmail.textColor = UIColor(named: "grey_60")
        
        bMember.isHidden = true
        bNumber.isHidden = true
        tfName.isEnabled = false
        tfLastName.isEnabled = false
        tfEmail.isEnabled = false
        tfMobile.isEnabled = false
    }
    func doEnsbleUI() {
        tfName.textColor = UIColor.black
        tfLastName.textColor = UIColor.black
        tfMobile.textColor = UIColor.black
        tfEmail.textColor = UIColor.black
        
        bMember.isHidden = false
        bNumber.isHidden = false
        
        tfName.isEnabled = true
        tfLastName.isEnabled = true
        tfEmail.isEnabled = true
        tfMobile.isEnabled = true
    }
    
    @IBAction func onEditProfile(_ sender: Any) {
        doEnsbleUI()
    }
    
    
   
    
   
    
    @IBAction func onClickAddMember(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.isEmergancy = false
        vc.profileVC = self
         vc.isProfile = true
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        
    }
    @IBAction func onClickEmergancy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.isEmergancy = true
        vc.profileVC = self
        vc.isProfile = true
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
}
