//
//  ViewController.swift
//  Finca
//
//  Created by anjali on 03/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import DropDown

struct ModelInfoMember {
    var name:String!
    var number:String!
    var relation:String!
    var isEmergancy:Bool!
}
class DailogFamilyMember: BaseVC {
    @IBOutlet weak var lbDropDown: UILabel!
    @IBOutlet weak var tfNAme: ACFloatingTextfield!
    
    @IBOutlet weak var tfAge: ACFloatingTextfield!
    @IBOutlet weak var lbHeader: UILabel!
    
     let dropDown = DropDown()
    let titleMembers = ["Dad","Mom","Brother","Sister","Grandpa","Grandmother","Son","Daughter","Other"]
    
    var isEmergancy:Bool!
      var ownedDataSelectVC:OwnedDataSelectVC!
    
    var profileVC:ProfileVC!
    
    var isProfile:Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lbDropDown.text = "Dad"
        tfNAme.autocorrectionType = .no
        
        tfNAme.delegate = self
         tfAge.delegate = self
        doneButtonOnKeyboard(textField: tfAge)
        
        if isEmergancy {
            lbHeader.text = "Add New Emergency Member"
            tfAge.placeholder = "Emergency Number"
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    override func doneClickKeyboard() {
        
        view.endEditing(true)
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == tfAge {
            var maxLength = 2
            if isEmergancy {
                maxLength = 10
            }
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }

    @IBAction func onClickDropDoen(_ sender: Any) {
        dropDown.anchorView = lbDropDown
        dropDown.dataSource = titleMembers
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.lbDropDown.text = item
            
        }
        
          dropDown.show()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    @IBAction func onClickAdd(_ sender: Any) {
        
        
        if isValidate() {
            if (isProfile) {
              ///  let data = ModelInfoMember(name: tfNAme.text!,number: tfAge.text!,relation: lbDropDown.text!,isEmergancy: isEmergancy)
                
               
                if isEmergancy {
                    let data = Emergency(relation: lbDropDown.text!,emergencyContact_id: "",person_name: tfNAme.text!,relation_id: "",person_mobile: tfAge.text!)
                    profileVC.emergencyModel = data
                } else {
                    let data = Member(user_family_id: "",member_relation_name: lbDropDown.text!,member_name: tfNAme.text!,member_relation_id: "",member_age: tfAge.text!)
                    profileVC.memberModel = data
                }
                
                
            } else {
                let data = ModelInfoMember(name: tfNAme.text!,number: tfAge.text!,relation: lbDropDown.text!,isEmergancy: isEmergancy)
               ownedDataSelectVC.modelInfoMember = data
                
            }
            
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
    func isValidate() -> Bool {
        var validate = true
        
        if tfNAme.text == "" {
            showAlertMessage(title: "", msg: "Enter Name")
        validate = false
        }
        
        if tfNAme.text == "" {
            if isEmergancy {
                  showAlertMessage(title: "", msg: "Enter Emergancy Number")
            } else {
                  showAlertMessage(title: "", msg: "Enter Age")
            }
          
            validate = false
        }
        
        return validate
    }
    
}
