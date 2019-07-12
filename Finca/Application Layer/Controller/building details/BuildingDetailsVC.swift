//
//  BuildingDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BuildingDetailsVC: BaseVC {

    @IBOutlet weak var lblSocietyName: UILabel!
    @IBOutlet weak var imgCompanyLogo: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblBuilderName: UILabel!
    @IBOutlet weak var lblBuilderAddress: UILabel!
    @IBOutlet weak var lblMobileNumber: UILabel!
    @IBOutlet weak var btnSecretaryEmail: UIButton!
    
    @IBOutlet weak var btnSecretaryMobile: UIButton!
    @IBOutlet weak var btnDialBuilderNumber: UIButton!
    @IBOutlet var seperatorView: [UIView]!
    @IBOutlet weak var lblSecretaryMobile: UILabel!
    @IBOutlet weak var lblSecretaryEmail: UILabel!
    @IBOutlet weak var lblNumOfBlocks: UILabel!
    @IBOutlet weak var lblNumOfUnits: UILabel!
    @IBOutlet weak var lblPopulation: UILabel!
    @IBOutlet weak var lblSatff: UILabel!
    @IBOutlet weak var lblCarsParked: UILabel!
    @IBOutlet weak var lblBikesParked: UILabel!
    @IBOutlet var cardview : [UIView]!
    @IBOutlet weak var bMenu: UIButton!
    
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doGetBuildingDetails()
        
        for view in seperatorView{
            let gradient = CAGradientLayer()
            gradient.frame = view.bounds
            gradient.colors = [UIColor.white.cgColor, UIColor(named: "ColorPrimary")?.cgColor as Any, UIColor.white.cgColor]
            
            gradient.locations = [0, 0.5, 0.9]
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
            
            view.layer.addSublayer(gradient)
        }
        
        btnDialBuilderNumber.isEnabled = false
        btnSecretaryEmail.isEnabled = false
        btnSecretaryMobile.isEnabled = false
        
        for view in cardview{
            view.layer.shadowRadius = 2
            view.layer.shadowOffset = CGSize.zero
            view.layer.shadowOpacity = 0.3
        }
        
    }
    
    @IBAction func btnCallMobile(_ sender: UIButton) {
        let phone_number = lblMobileNumber.text!
        
        if let phoneCallURL = URL(string: "telprompt://\(phone_number)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    @IBAction func btnCallSecretary(_ sender: UIButton) {
        let phone_number = lblSecretaryMobile.text!
        
        if let phoneCallURL = URL(string: "telprompt://\(phone_number)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
    }
    @IBAction func btnOpenEmail(_ sender: UIButton) {
       
        let email = lblSecretaryEmail.text!
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadNoti()
    }
    func loadNoti() {
      
        if getChatCount() !=  "0" {
            self.viewChatCount.isHidden =  false
            self.lbChatCount.text = getChatCount()
            
        } else {
            self.viewChatCount.isHidden =  true
        }
        if getNotiCount() !=  "0" {
            self.viewNotiCount.isHidden =  false
            self.lbNotiCount.text = getNotiCount()
            
        } else {
            self.viewNotiCount.isHidden =  true
        }
    }
    
    func doGetBuildingDetails(){
        print("get polling options")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "buildingDetails":"buildingDetails",
                      "society_id":doGetLocalDataUser().society_id!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.buildingDetailsController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(BuildingDetailResponse.self, from:json!)
                    if response.status == "200" {
                        self.lblSocietyName.text = response.societyName
                        Utils.setImageFromUrl(imageView: self.imgCompanyLogo, urlString: response.socieatyLogo)
                        self.lblAddress.text = response.societyAddress
                        self.lblBuilderName.text = response.builderName
                        self.lblMobileNumber.text = response.builderMobile
                        self.lblSecretaryEmail.text = response.secretaryEmail
                        self.lblSecretaryMobile.text = response.secretaryMobile
                        
                        self.toast(message: response.message, type: 0)
                        self.btnSecretaryMobile.isEnabled = true
                        self.btnDialBuilderNumber.isEnabled = true
                        
                        self.lblNumOfBlocks.text = String(response.noOfBlocks)
                        self.lblNumOfUnits.text = String(response.noOfUnits)
                        self.lblPopulation.text = String(response.noOfPopulation)
                        self.lblSatff.text = String(response.noOfStaff)
                        self.lblCarsParked.text = response.carAllocate+"/"+response.carCapcity
                        self.lblBikesParked.text = response.bikeAllocate+"/"+response.bikeCapcity
                        
                        self.lblBuilderAddress.text = response.builderAddress
                        
                    }else {
                        
                        self.toast(message: response.message, type: 1)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func onClickNotification(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
