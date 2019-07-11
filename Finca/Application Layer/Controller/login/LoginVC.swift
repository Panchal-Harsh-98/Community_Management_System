//
//  LoginVC.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct LoginResponse : Codable {
    let society_id:String! //"society_id" : "32",
    let owner_name:String! //"owner_name" : "Xyz",
    let unit_id:String! //"unit_id" : "1901",
    let user_first_name:String! // "user_first_name" : "Ankit",
    let message:String!  //"message" : "login success.",
    let floor_name:String!  //"floor_name" : "1 F",
    let block_id:String!  // "block_id" : "104",
    let user_mobile:String!  //"user_mobile" : "9157146041",
    let user_last_name:String! // "user_last_name" : "Rana",
    let base_url:String!  //"base_url" : "http:\/\/www.hi-techsociety.in\/",
    let user_profile_pic:String! //"user_profile_pic" : "cident_profile\/user_1905220525.png",
    let status:String! //"status" : "200",
    let user_status:String! //"user_status" : "1",
    let owner_mobile:String!  //"owner_mobile" : "8585050606",
    let block_name:String!  //"block_name" : "Modi",
    let user_id_proof:String!  //"user_id_proof" : "user_id_proof",
    let unit_name:String! //"unit_name" : "Unit 4",
    let user_full_name:String! //"user_full_name" : "Ankit Rana",
    let owner_email:String!  //"owner_email" : "ankitrana1056@gmail.com",
    let user_id:String!  //"user_id" : "166",
    let floor_id:String! //"floor_id" : "446",
    let user_type:String! //"user_type" : "1",
    let user_email:String! //"user_email" : "ankitrana.r56@gmail.com"
    let unit_status:String! //"user_type" : "1",
    
    let emergency:[Emergency]!
    let member:[Member]!
}

struct Member : Codable {
   let user_family_id:String! // "user_family_id" : "19",
    let member_relation_name:String! //"member_relation_name" : "Wife",
    let member_name:String! //"member_name" : "Xyz",
    let member_relation_id:String!// "member_relation_id" : null,
    let member_age:String!// "member_age" : "12"
}
struct Emergency : Codable {
   let relation:String! //"relation" : "Dad",
   let emergencyContact_id:String! //"emergencyContact_id" : "14",
   let person_name:String! //"person_name" : "Ankit Rana",
  let relation_id:String!  //"relation_id" : null,
  let person_mobile:String!  //"person_mobile" : "989898688"
}

class LoginVC: BaseVC {

    @IBOutlet weak var ivLogo: UIImageView!
    
    @IBOutlet weak var ivPassword: UIImageView!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    @IBOutlet weak var tfPassword: ACFloatingTextfield!
    
    var society_id:String!
    var iconClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        doneButtonOnKeyboard(textField: tfMobile)
        //tfMobile.text = "9096693518"
        // tfPassword.text = "12345"
        tfMobile.delegate = self
         tfPassword.delegate = self
        ivLogo.setImageColor(color: UIColor.white)
        ivPassword.setImageColor(color: UIColor.white)
        
        hideKeyBoardHideOutSideTouch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    @IBAction func onClickLogin(_ sender: Any) {
        
        if validate() {
            doLogin()
        }
    }
    
    @IBAction func onClickPasswordShow(_ sender: Any) {
        
        if(iconClick == true) {
            tfPassword.isSecureTextEntry = false
            ivPassword.image = UIImage(named: "visibility_black")
            ivPassword.setImageColor(color: UIColor.white)
            
        } else {
            tfPassword.isSecureTextEntry = true
            ivPassword.image = UIImage(named: "visibility_off")
            ivPassword.setImageColor(color: UIColor.white)
            
        }
        
        iconClick = !iconClick
    }
    @IBAction func onClickRegister(_ sender: Any) {
        
      ///  let vc = storyboard?.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
     /// self.navigationController?.pushViewController(vc, animated: true)
        
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectUserTypeVC") as! SelectUserTypeVC
        vc.society_id = society_id
       
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
   
    
    @IBAction func onClickForgot(_ sender: Any) {
        if tfMobile.text!.count > 9 {
            doForgotPassword()
        } else {
            showAlertMessage(title: "", msg: "Enter Valid Mobile number")
        }
        
        
    }
    
    func doForgotPassword() {
      
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "user_login":"user_login",
                      "user_mobile":tfMobile.text!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.forgotPassword, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                         self.showAlertMessage(title: "", msg: response.message)
                    }else {
                        //                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @IBAction func onClickTerms(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idTermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func validate() -> Bool {
        var validate = true
        print("validate")
        if (tfMobile.text == ""){
            showAlertMessage(title: "", msg: "You need to enter a Rigistered Mobile Number.")
            validate = false
        }
        
        if (tfPassword.text == "" ){
            showAlertMessage(title: "", msg: "You need to enter a  Password")
            validate = false
        }
        return validate
    }
    
    func doLogin() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "user_login":"user_login",
                      "user_mobile":tfMobile.text!,
                      "user_password":tfPassword.text!,
                      "user_token":UserDefaults.standard.string(forKey: StringConstants.KEY_DEVICE_TOKEN)!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.login, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        UserDefaults.standard.set(self.tfPassword.text!, forKey: StringConstants.KEY_PASSWORD)
                        UserDefaults.standard.set(self.tfMobile.text!, forKey: StringConstants.KEY_USER_NAME)
                        
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        
                        UserDefaults.standard.set("1", forKey: StringConstants.KEY_LOGIN)
                        
                        
                        
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idRevealViewController") as! UINavigationController
                        self.present(vc, animated: true, completion: nil)
                    }else {
//                        UserDefaults.standard.set("0", forKey: StringConstants.KEY_LOGIN)
                        self.showAlertMessage(title: "Alert", msg: loginResponse.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfMobile {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
       return true
    }
}
