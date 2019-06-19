//
//  OTPVerificationVC.swift
//  Finca
//
//  Created by anjali on 30/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import Foundation
import UIKit
class OTPVerificationVC: BaseVC {
    @IBOutlet weak var tfOne: UITextField!
      @IBOutlet weak var tfTwo: UITextField!
      @IBOutlet weak var tfThree: UITextField!
      @IBOutlet weak var tfFour: UITextField!
    var selectedSociety : ModelSociety!
    @IBOutlet weak var bSend: UIButton!
    
    @IBOutlet weak var lbCountDown: UILabel!
    @IBOutlet weak var tfPhoneNumber: UITextField!
    @IBOutlet weak var bBack: UIButton!
    
    @IBOutlet weak var bReSend: UIButton!
    var count = 120
    var otpSend = ""
    override func viewDidLoad() {
        
        changeButtonImageColor(btn: bBack, image: "back", color: UIColor.white)
        
        tfOne.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfTwo.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfThree.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfFour.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        
        doneButtonOnKeyboard(textField: tfOne)
          doneButtonOnKeyboard(textField: tfTwo)
          doneButtonOnKeyboard(textField: tfThree)
          doneButtonOnKeyboard(textField: tfFour)
        doneButtonOnKeyboard(textField: tfPhoneNumber)
        
        tfOne.delegate = self
        tfTwo.delegate = self
        tfThree.delegate = self
        tfFour.delegate = self
        tfPhoneNumber.delegate = self
        
        tfOne.isEnabled = false
        tfTwo.isEnabled = false
        tfThree.isEnabled = false
        tfFour.isEnabled = false
        bReSend.isHidden = true
        
        
    }
    override func doneClickKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onResend(_ sender: Any) {
        sendOtp()
        bReSend.isHidden = true
    }
    @IBAction func onClickSubmit(_ sender: Any) {
        if tfPhoneNumber.text == "" {
            showAlertMessage(title: "", msg: "Enter Valid mobile number")
        } else {
            
          //  var randomOtp = randomOtp()
            let buttonTitle = (sender as AnyObject).title(for: .normal)
            
            
            if buttonTitle == "SEND" {
              
                sendOtp()
            } else {
                compreOtp()
                
            }
           }
        
    }
    
    func sendOtp() {
        count = 120
        bSend.setTitle("VERIFY", for: .normal)
        otpSend = randomOtp
        showAlertMessage(title: "", msg: "Otp is " + otpSend )
        doEnbleOTPView()
        
       /* if  bReSend.isHidden {
              bReSend.isHidden = false
        } else {
             bReSend.isHidden = true
        }*/
     
        // _ = Timer.init(timeInterval: 1, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startCountDown), userInfo: nil, repeats: true)
    }
   func doEnbleOTPView() {
    tfOne.isEnabled = true
    tfTwo.isEnabled = true
    tfThree.isEnabled = true
    tfFour.isEnabled = true
    }
    
    func compreOtp() {
     //   var tfOne.text + "" + tfTwo.text //+ "" +  tfThree.text + tfFour.text
       
        let inputOtp =  tfOne.text! + "" + tfTwo.text! + "" + tfThree.text! + "" + tfFour.text! ///+ "" + tfThree.text + "" + tfFour.text
        
        
        if otpSend != inputOtp { 
            
            showAlertMessage(title: "", msg: "Invalid OTP")
        } else {
            
            let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectUserTypeVC") as! SelectUserTypeVC
            vc.society_id = selectedSociety.society_id
            vc.mobileNumber = tfPhoneNumber.text!
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }
    
    var randomOtp: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while result.count < 4
        return result
    }
  @objc func startCountDown() {
   // print("statrt servcic")
    if(count > 0){
        let minutes = "0" + String(count / 60)
        var seconds = String(count % 60)
        if seconds.count == 1 {
            seconds = "0" + seconds
        }
        lbCountDown.text = minutes + ":" + seconds
        count = count - 1
    } else {
         bReSend.isHidden = false
       // count = 120
        lbCountDown.text = "00" + ":" + "00"
    }
    }
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 1
        
        if textField == tfPhoneNumber {
            maxLength = 10
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    @objc func textFieldDidChange(textField : UITextField)  {
        let text = textField.text
        
        if text?.utf16.count == 1 {
            switch textField {
                
            case tfOne :
                tfTwo.becomeFirstResponder()
                
            case tfTwo :
                tfThree.becomeFirstResponder()
                
            case tfThree :
                tfFour.becomeFirstResponder()
                
            case tfFour :
                tfFour.becomeFirstResponder()
            default:
                break
            }
            
            
        }
        let  char = text?.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            print("Backspace was pressed")
            
            switch textField {
                
            case tfOne :
                tfOne.resignFirstResponder()
                
            case tfTwo :
                tfOne.becomeFirstResponder()
                
            case tfThree :
                tfTwo.becomeFirstResponder()
                
            case tfFour :
                tfThree.becomeFirstResponder()
                
                
            default:
                break
                
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
}
