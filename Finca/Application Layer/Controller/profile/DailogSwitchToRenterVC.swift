//
//  DailogSwitchToRenterVC.swift
//  Finca
//
//  Created by anjali on 01/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DailogSwitchToRenterVC: BaseVC ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var tfFirstNAme: ACFloatingTextfield!
    @IBOutlet weak var tfLastNAme: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfNumber: ACFloatingTextfield!
    
    @IBOutlet weak var ivProfile: UIImageView!
    var isImagePick = false
    var isOnwer:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        tfFirstNAme.delegate = self
        tfLastNAme.delegate = self
        tfEmail.delegate = self
        tfNumber.delegate = self
        
        doneButtonOnKeyboard(textField: tfNumber)
        // Do any additional setup after loading the view.
        hideKeyBoardHideOutSideTouch()
        Utils.setRoundImage(imageView: ivProfile)
    }
    override func doneClickKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }

    @IBAction func onClickSave(_ sender: Any) {
       if  isValidateData() {
        
    
            doSubmit()
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    @IBAction func onClickAddImage(_ sender: Any) {
        openPhotoSelecter()
    }
    @objc func openPhotoSelecter(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Chose a source", preferredStyle: .actionSheet)
        // actionSheet.view.layer.cornerRadius = 10
        
        actionSheet.addAction(UIAlertAction(title: "Camara", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
                
            }else{
                print("not")
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Galary", style: .default, handler: { (action:UIAlertAction) in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil )
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.ivProfile.image = selectedImage
        self.isImagePick = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func isValidateData() -> Bool {
        var isValid = true
        
        if tfFirstNAme.text == ""{
             showAlertMessage(title: "", msg: "Enter First Name")
             isValid = false
        }
        if tfLastNAme.text == ""{
            showAlertMessage(title: "", msg: "Enter Last Name")
            isValid = false
        }
        
        
        if !isValidEmail(email: tfEmail.text!){
            showAlertMessage(title: "", msg: "Enter Email Address")
            isValid = false
        }
        if tfNumber.text == ""{
            showAlertMessage(title: "", msg: "Enter Mobile Number")
            isValid = false
        }
        
        return isValid
    }
    
    func doSubmit() {
         showProgress()
        
        var user_profile_pic = ""
        if isImagePick {
            user_profile_pic = convertImageTobase64(imageView: ivProfile)
        }
        
        let params : [String:String]
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        if isOnwer{
            params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "switchUser":"switchUser",
                      "society_id":doGetLocalDataUser().society_id,
                      "user_profile_pic":user_profile_pic,
                      "user_first_name":tfFirstNAme.text!,
                      "user_last_name":tfLastNAme.text!,
                      "user_mobile":tfNumber.text!,
                      "user_email":tfEmail.text!,
                      "owner_name":doGetLocalDataUser().user_full_name!,
                      "owner_email":doGetLocalDataUser().user_email!,
                      "owner_mobile":doGetLocalDataUser().user_mobile!,
                      "addUser":"1",
                      "user_id":doGetLocalDataUser().user_id!,
                      "unit_id":doGetLocalDataUser().unit_id!]
        } else {
            params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "switchUser":"switchUser",
                      "society_id":doGetLocalDataUser().society_id,
                      "owner_name":doGetLocalDataUser().owner_name,
            "owner_email":doGetLocalDataUser().owner_email,
             "owner_mobile":doGetLocalDataUser().owner_mobile,
             "addUser":"0",
             "user_id":doGetLocalDataUser().user_id!,
             "unit_id":doGetLocalDataUser().unit_id!]
        }
       
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.switchUserController, parameters: params) { (json, error) in
            
            if json != nil {
                 self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        Utils.setHomeRootLogin()
                          UserDefaults.standard.set(nil, forKey: StringConstants.KEY_LOGIN)
                        
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfNumber {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
}
