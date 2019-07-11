//
//  ChangePasswordVC.swift
//  Finca
//
//  Created by anjali on 09/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ChangePasswordVC: BaseVC {

    @IBOutlet weak var tfOldPassword: ACFloatingTextfield!
    @IBOutlet weak var tfNewPassword: ACFloatingTextfield!
    @IBOutlet weak var tfConfirmPassword: ACFloatingTextfield!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfOldPassword.delegate = self
        tfNewPassword.delegate = self
        tfConfirmPassword.delegate = self
        
        hideKeyBoardHideOutSideTouch()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func onClickSave(_ sender: Any) {
      if  validate() {
            doChangePassword()
        }
    }
    
    @IBAction func onClickBAck(_ sender: Any) {
        
        doPopBAck()
    }
    
    func validate() -> Bool {
    var isValid = true
        
        if tfOldPassword.text == "" {
            tfOldPassword.showErrorWithText(errorText: "Enter your Old Password")
            isValid = false
        }
        if tfNewPassword.text!.count  < 4  {
            tfNewPassword.showErrorWithText(errorText: "Enter your new Password minimum 4 charecter")
            isValid = false
        } else {
            
            if tfConfirmPassword.text == "" {
                tfConfirmPassword.showErrorWithText(errorText: "Enter Confirm password")
                isValid = false
            } else  if tfNewPassword.text  != tfConfirmPassword.text  {
                tfConfirmPassword.showErrorWithText(errorText: "Confirm password doesn't match")
                isValid = false
            }
            
        }
        
        return isValid
    }
    
    func doChangePassword(){
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "change_password":"change_password",
                      "old_password":tfOldPassword.text!,
                      "user_password":tfNewPassword.text!,
                      "user_id":doGetLocalDataUser().user_id!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.forgotPassword, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.showAlertMessageWithClick(title: "", msg: response.message)
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
    
    override func onClickDone() {
       UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
        
        Utils.setHomeRootLocation()
    }
}
