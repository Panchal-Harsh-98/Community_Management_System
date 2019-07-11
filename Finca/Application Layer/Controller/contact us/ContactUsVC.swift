//
//  ContactUsVC.swift
//  Finca
//
//  Created by anjali on 10/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ContactUsVC: BaseVC {

    @IBOutlet weak var bMenu: UIButton!
    
    @IBOutlet weak var tfFeedback: ACFloatingTextfield!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var ivEmail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doInintialRevelController(bMenu: bMenu)
        hideKeyBoardHideOutSideTouch()
        tfFeedback.delegate = self
        ivEmail.setImageColor(color: #colorLiteral(red: 0.1529411765, green: 0.5568627451, blue: 0.8862745098, alpha: 1))
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
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
    
    @IBAction func onClickSubmit(_ sender: Any) {
     
        if tfFeedback.text!.count < 9 {
            toast(message: "Enter feedback minimum 10 charecter", type: 1)
        } else {
            
            if doGetLocalDataUser().user_email != nil {
                  sendFeedback()
            } else {
                showAlertMessage(title: "", msg: "Add email in your profile for submit feedback")
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
    
    @IBAction func onClickUrl(_ sender: Any) {
        guard let url = URL(string: "https://www.fincasys.com") else { return }
        UIApplication.shared.open(url)
    }
    
    @IBAction func onclickEmail(_ sender: Any) {
        let email = "info@fincasys.com"
        if let url = URL(string: "mailto:\(email)") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func sendFeedback() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
      
        
        let params = ["key":apiKey(),
                      "name":doGetLocalDataUser().user_full_name!,
                      "mobile":doGetLocalDataUser().user_mobile!,
                      "email":doGetLocalDataUser().user_email!,
                      "message":tfFeedback.text!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.feedback_mail_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.tfFeedback.text = ""
                        self.toast(message: response.message, type: 0)
                        
                    }else {
                      //  self.showAlertMessage(title: "Alert", msg: response.message)
                          self.toast(message: response.message, type: 1)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
}
