//
//  SplashVC.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct CheckVersionResspon : Codable{
    let  version_code : String!//" : "1.0.0",
    let  back_banner : String!//" : "https:\/\/www.fincasys.com\/img\/backBanner\/mobile6.jpg",
    let  message : String!//" : "Get Version success.",
    let  version_name : String!//" : "1.0.0",
    let  version_id : String!//" : "4",
    let  version_app : String!//" : "1",
    let  status : String!//" : "200"

}

class SplashVC: BaseVC {
    
    @IBOutlet weak var progressBar: NVActivityIndicatorView!
    @IBOutlet weak var ivSWLogo: UIImageView!
    @IBOutlet weak var ivLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ivLogo.setImageColor(color: UIColor.white)
        ivSWLogo.setImageColor(color: UIColor.white)
        
        progressBar.color = UIColor.white
        progressBar.startAnimating()
        
       
        checkVersion()
        
       // Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(callback), userInfo: nil, repeats: false)
        
    }
    
    @objc func callback() {
        if !isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN) {
            
            // let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idLoginVC")as! LoginVC
            let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
            self.present(loginVc, animated: true, completion: nil)
            
        } else {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: StringConstants.HOME_NAV_CONTROLLER)as! SWRevealViewController
//
//            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idNavMainHome")as! UINavigationController
//
//
//            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idNavMain")as! UINavigationController
//
//            self.present(homeVC, animated: true, completion: nil)
            
           self.navigationController?.pushViewController(homeVC, animated: true)    
        }
        
    }
    func checkVersion() {
     
        var appVersionInt = 0
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        
        appVersionInt =  Int(appVersion!)!
        print("appVersion",appVersionInt)
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        
        
        let params = ["version_app":"1",
                      "getVersion":"getVersion",
                      "mobile_app":"2"]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPostMain(serviceName: ServiceNameConstants.version_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(CheckVersionResspon.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        UserDefaults.standard.set(response.back_banner, forKey: StringConstants.KEY_BACKGROUND_IMAGE)
                      
                        
                        let version = Int(response.version_code!)!
                        
                        print("local" ,appVersionInt )
                         print("set" ,version )
                        if appVersionInt >= version  {
                            if !self.isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN) {
                                
                                let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
                                self.present(loginVc, animated: true, completion: nil)
                                
                            } else {
                                self.doCheckLogin()
                               
                            
                                // self.doCheckLogin()
                            }
                           
                        } else {
                            self.showAlertMessageWithClick(title: "Update Avilable", msg: "A new of fincasys is avilable. Please update " + response.version_code + " now")
                        }
                     
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
    override func onClickDone() {
        // go to app store
    }
   func doCheckLogin() {
    
    
    showProgress()
    
    
    let params = ["key":apiKey(),
                  "check_login":"check_login",
                  "society_id":doGetLocalDataUser().society_id!,
                  "user_id":doGetLocalDataUser().user_id!,
                  "user_name":UserDefaults.standard.string(forKey: StringConstants.KEY_USER_NAME)!,
                  "user_password":UserDefaults.standard.string(forKey: StringConstants.KEY_PASSWORD)!]
    
    
    print("param" , params)
    
    let requrest = AlamofireSingleTon.sharedInstance
    
    
    requrest.requestPost(serviceName: ServiceNameConstants.check_login_status, parameters: params) { (json, error) in
        
        if json != nil {
            self.hideProgress()
            do {
                let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                
                
                if response.status == "200" {
                    
                 //   let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idRevealViewController")as! UINavigationController
              //      self.present(homeVC, animated: true, completion: nil)
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idHomeNavController")as! SWRevealViewController
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }else {
                      self.showAlertMessage(title: "Alert", msg: response.message)
                   //self.toast(message: response.message, type: 1)
                }
            } catch {
                print("parse error")
            }
        }
    }
    }
}
