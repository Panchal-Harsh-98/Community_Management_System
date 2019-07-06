//
//  AttendEventVC.swift
//  Finca
//
//  Created by anjali on 05/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class AttendEventVC: BaseVC {

    @IBOutlet weak var tfAttendPerson: ACFloatingTextfield!
    @IBOutlet weak var tfNote: ACFloatingTextfield!
    
    var attendPerson:String!
    var note:String!
    var event_id:String!
    var noOfAttent:String!
    var isShowDelet : Bool!
    @IBOutlet weak var bNoting: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyBoardHideOutSideTouch()
        // Do any additional setup after loading the view.
        if isShowDelet {
            bNoting.isHidden = false
        } else {
           bNoting.isHidden = true
        }
        
        
    tfAttendPerson.text = attendPerson
    tfNote.text = note
    }
    @IBAction func onClickBAck(_ sender: Any) {
        doPopBAck()
    }
    

   
    @IBAction func onClickSave(_ sender: Any) {
        if tfAttendPerson.text == "" {
            tfAttendPerson.showErrorWithText(errorText: "Enter how many person attend") //= "Enter how many person attend"
        } else {
            
            doSubmit()
        }
        
    }
    
    func doSubmit() {
    
    
            showProgress()
            //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
            let params = ["key":apiKey(),
                          "addEventAttendList":"addEventAttendList",
                          "user_id":doGetLocalDataUser().user_id!,
                          "society_id":doGetLocalDataUser().society_id!,
                          "event_id" : event_id!,
                          "unit_id":doGetLocalDataUser().unit_id!,
                          "going_person":tfAttendPerson.text!,
                          "notes":tfNote.text!,
                          "user_name":doGetLocalDataUser().user_full_name!]
            
            
            print("param" , params)
            
            let requrest = AlamofireSingleTon.sharedInstance
            
            
            requrest.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
                
                if json != nil {
                    self.hideProgress()
                    do {
                        let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                        
                        
                        if response.status == "200" {
                            
                            self.onNext()
                            
                        }else {
                            self.showAlertMessage(title: "Alert", msg: response.message)
                        }
                    } catch {
                        print("parse error")
                    }
                }
            }
            
        
    }
    
    @IBAction func onClickNotGoing(_ sender: Any) {
        doNotAttend()
    }
    func doNotAttend() {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "cancelAttend":"cancelAttend",
                      "society_id":doGetLocalDataUser().society_id!,
                      "event_id" : event_id!,
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "user_name":doGetLocalDataUser().user_full_name!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.onNext()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
        
    }
    
    func  onNext(){
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idEventsVC") as! EventsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
