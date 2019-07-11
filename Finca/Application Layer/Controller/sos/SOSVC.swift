//
//  SOSVC.swift
//  Finca
//
//  Created by anjali on 10/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseSosEvent  :Codable {
    let status : String!//" : "200"
    let message : String!//" : "Events get success.",
    var sos_event : [SOSEventModel]!
    
}

struct SOSEventModel : Codable {
    let event_name : String!//" : "Fire",
    let sos_event_id : String!//" : "16",
    let event_type : String!//" : "",
    let event_status : String!//" : "0",
    let sos_for : String!//" : "1"
    
}

class SOSVC: BaseVC {

    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    @IBOutlet weak var tfMsg: ACFloatingTextfield!
    @IBOutlet weak var lbTitleEvent: UILabel!
    @IBOutlet weak var viewMainPicker: UIView!
      var sos_event = [SOSEventModel]()
    var sos_for = ""
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        // Do any additional setup after loading the view.
        viewMainPicker.isHidden = true
        doInintialRevelController(bMenu: bMenu)
        doGetEvent()
        hideKeyBoardHideOutSideTouch()
        tfMsg.delegate = self
        
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @IBAction func onClickSOSToSecurity(_ sender: Any) {
        
        if tfMsg.text == "" {
            toast(message: "Add Message", type: 1)
        } else {
            addSosGaurd()
        }
    }
  
    @IBAction func onClickSendSosEvent(_ sender: Any) {
        addSosEvent()
        
    }
    @IBAction func onClickShowPicker(_ sender: Any) {
         viewMainPicker.isHidden = false
    }
    @IBAction func onClickDonePicker(_ sender: Any) {
        viewMainPicker.isHidden = true
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
    func doGetEvent() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getEventsList":"getEventsList",
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getSOS_events_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                           self.sos_event.append(contentsOf: response.sos_event)
                          self.pickerView.reloadAllComponents()
                        self.lbTitleEvent.text = self.sos_event[0].event_name
                        self.sos_for = self.sos_event[0].sos_for
                    
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func addSosGaurd() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = format.string(from: date)
        // print("date " , formattedDate)
        
        let formatT = DateFormatter()
        formatT.dateFormat = "HH:mm:ss"
        let formattedTime = formatT.string(from: date)
        // print("date " , formattedTime)
        
        let sos_unit = doGetLocalDataUser().block_name + "-" + doGetLocalDataUser().unit_name
        let params = ["key":apiKey(),
                      "sentToGaurd":"sentToGaurd",
                      "society_id":doGetLocalDataUser().society_id!,
                      "sos_title":tfMsg.text!,
                      "sos_type":"1",
                      "sos_status":"1",
                      "sos_unit":sos_unit,
                      "sos_by":doGetLocalDataUser().user_first_name!,
                      "time":formattedTime,
                      "otime":formattedDate]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getSOS_events_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.tfMsg.text = ""
                        self.toast(message: response.message, type: 0)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    func addSosEvent() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = format.string(from: date)
        // print("date " , formattedDate)
        
        let formatT = DateFormatter()
        formatT.dateFormat = "HH:mm:ss"
        let formattedTime = formatT.string(from: date)
        // print("date " , formattedTime)
        
        let sos_unit = doGetLocalDataUser().block_name + "-" + doGetLocalDataUser().unit_name
        let params = ["key":apiKey(),
                      "addNewEventsList":"addNewEventsList",
                      "society_id":doGetLocalDataUser().society_id!,
                      "sos_title":lbTitleEvent.text!,
                      "sos_type":"1",
                      "sos_status":"1",
                      "sos_for":sos_for,
                      "sos_by":doGetLocalDataUser().user_full_name!,
                      "time":formattedTime,
                      "sos_unit":sos_unit,
                      "otime":formattedDate]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getSOS_events_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseSosEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.tfMsg.text = ""
                        self.toast(message: response.message, type: 0)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
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
extension SOSVC: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        
        return sos_event.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        return sos_event[row].event_name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
            self.lbTitleEvent.text = self.sos_event[row].event_name
          self.sos_for = self.sos_event[row].sos_for
        //    self.city_id = self.cities[row].city_id
        
        
        
    }
    
    
}
