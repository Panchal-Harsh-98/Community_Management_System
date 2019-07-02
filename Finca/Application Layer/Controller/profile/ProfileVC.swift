//
//  ProfileVC.swift
//  Finca
//
//  Created by anjali on 20/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseAllPayment:Codable {
   var message: String!//  "message" : "Get success.",
    var bill: String!//   "bill" : "0.00",
    var status: String!//   "status" : "200",
    var total: String!//   "total" : "20.00",
    var maintenance: String!//   "maintenance" : "20.00"
}

class ProfileVC: BaseVC ,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var bMenu: UIButton!
     @IBOutlet weak var ivProfile: UIImageView!
    
    @IBOutlet weak var lbResidentNumber: UILabel!
    @IBOutlet weak var lbUnpaidMaintence: UILabel!
    @IBOutlet weak var lbUnpaidBill: UILabel!
    @IBOutlet weak var lbDue: UILabel!
    
    @IBOutlet weak var switchOwner: UISwitch!
    @IBOutlet weak var switchApartment: UISwitch!
    @IBOutlet weak var tfName: ACFloatingTextfield!
    @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    @IBOutlet weak var bMember: UIButton!
    @IBOutlet weak var bNumber: UIButton!
    @IBOutlet weak var cvNumber: UICollectionView!
    @IBOutlet weak var cvMember: UICollectionView!
    
    @IBOutlet weak var viewMaintance: UIView!
    @IBOutlet weak var heightConstrainstMember: NSLayoutConstraint!
    @IBOutlet weak var heightConstrainstNumber: NSLayoutConstraint!
     var item = "InfoFamalyMemberCell"
    var  heightCVFamily = 0.0
    var  heightCVEmergancy = 0.0
    
    var emergency = [Emergency]()
    var member = [Member]()
    
    var emergencyModel:Emergency!
    var memberModel:Member!
    var isImagePick = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
          doInintialRevelController(bMenu: bMenu)
        switchApartment.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
        switchOwner.addTarget(self, action: #selector(switchChangedRenter), for: UIControl.Event.valueChanged)
        
        initUI()
    }
    
    @objc func switchChanged(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        // Do something
        if value {
            //
            doCallSwichApartment(unit_status: "5")
        } else {
            if doGetLocalDataUser().user_type == "0" {
                //owner
              doCallSwichApartment(unit_status: "1")
                
            } else {
                //tenent
                doCallSwichApartment(unit_status: "3")
                
            }
            
        }
        
    }
   
    
    @objc func switchChangedRenter(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        // Do something
        if value {
            //
            confirm(isOnwer: true)
        } else {
            confirm(isOnwer: false)
            
        }
        
        
    }
    
    func confirm(isOnwer:Bool){
    
        let refreshAlert = UIAlertController(title: "", message: "Are you sure to become Rent?", preferredStyle: UIAlertController.Style.alert)
    
    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
        self.showDailog(isOnwer: isOnwer)
    }))
    
    refreshAlert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (action: UIAlertAction!) in
   
    }))
    
    present(refreshAlert, animated: true, completion: nil)
    
    }
    
     func showDailog(isOnwer:Bool) {
        
        if isOnwer {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogSwitchToRenterVC") as! DailogSwitchToRenterVC
            
            vc.isOnwer = isOnwer
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            self.addChild(vc)
            self.view.addSubview(vc.view)
        } else {
            doSwitchToOnwer()
        }
       
        
     }
    
    func  initUI() {
        
        
        Utils.setRoundImageWithBorder(imageView: ivProfile, color: UIColor.red)
        
        Utils.setImageFromUrl(imageView: ivProfile, urlString: doGetLocalDataUser().user_profile_pic)
        
        lbResidentNumber.text = doGetLocalDataUser().block_name + "-" + doGetLocalDataUser().unit_name
        
         tfName.text = doGetLocalDataUser().user_first_name
        tfLastName.text = doGetLocalDataUser().user_last_name
        tfMobile.text = doGetLocalDataUser().user_mobile
        tfEmail.text = doGetLocalDataUser().user_email
        
        tfName.delegate = self
        tfLastName.delegate = self
        tfEmail.delegate = self
        tfMobile.delegate = self
        
        
        
        if doGetLocalDataUser().user_type == "0" {
            //owner
            switchOwner.isOn = false
            
        } else {
             //tenent
             switchOwner.isOn = true
            
        }
         if doGetLocalDataUser().unit_status == "5" {
             switchApartment.isOn = true
         } else {
              switchApartment.isOn = false
        }
        
        doDisbleUI()
        doMaintence()
        
        cvMember.delegate = self
        cvMember.dataSource = self
        
        let inbFloor = UINib(nibName: item, bundle: nil)
        cvMember.register(inbFloor, forCellWithReuseIdentifier: item)
        
        cvNumber.delegate = self
        cvNumber.dataSource = self
        cvNumber.register(inbFloor, forCellWithReuseIdentifier: item)
        
        heightCVFamily = 0.0
        heightCVEmergancy = 0.0
        
        heightConstrainstMember.constant = CGFloat(heightCVFamily)
        heightConstrainstNumber.constant = CGFloat(heightCVEmergancy)
        
        if member.count > 0{
            member.removeAll()
            cvMember.reloadData()
        }
        if emergency.count > 0{
            emergency.removeAll()
            cvNumber.reloadData()
        }
        
        
        if doGetLocalDataUser().member.count > 0 {
            member.append(contentsOf: doGetLocalDataUser().member)
            cvMember.reloadData()
            heightCVFamily =  heightCVFamily + (Double(doGetLocalDataUser().member.count) * 50.0)
          
            heightConstrainstMember.constant = CGFloat(heightCVFamily)
        }
        
        if doGetLocalDataUser().emergency.count > 0 {
            emergency.append(contentsOf: doGetLocalDataUser().emergency)
            cvNumber.reloadData()
            heightCVEmergancy =  heightCVEmergancy   + (Double(doGetLocalDataUser().emergency.count) * 50.0)
            heightConstrainstNumber.constant = CGFloat(heightCVEmergancy)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
     
    @IBAction func onClickSave(_ sender: Any) {
        doSubmitData()
    }
    func doMaintence() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "userDetail":"userDetail",
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getUserPaymentData, parameters: params) { (json, error) in
             self.hideProgress()
            if json != nil {
               
                do {
                    let response = try JSONDecoder().decode(ResponseAllPayment.self, from:json!)
                    
                    
                    if response.status == "200" {
                         self.lbUnpaidMaintence.text = response.maintenance
                        self.lbUnpaidBill.text = response.bill
                        self.lbDue.text = response.total
                        
                        
                    }else {
                        self.viewMaintance.isHidden = true
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func doDisbleUI() {
        tfName.textColor = UIColor(named: "grey_60")
         tfLastName.textColor = UIColor(named: "grey_60")
         tfMobile.textColor = UIColor(named: "grey_60")
         tfEmail.textColor = UIColor(named: "grey_60")
        
        bMember.isHidden = true
        bNumber.isHidden = true
        tfName.isEnabled = false
        tfLastName.isEnabled = false
        tfEmail.isEnabled = false
        tfMobile.isEnabled = false
    }
    func doEnsbleUI() {
        tfName.textColor = UIColor.black
        tfLastName.textColor = UIColor.black
        tfMobile.textColor = UIColor.black
        tfEmail.textColor = UIColor.black
        
        bMember.isHidden = false
        bNumber.isHidden = false
        
        tfName.isEnabled = true
        tfLastName.isEnabled = true
        tfEmail.isEnabled = true
        tfMobile.isEnabled = true
    }
    
    @IBAction func onEditProfile(_ sender: Any) {
        doEnsbleUI()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        self.ivProfile.image = selectedImage
        self.isImagePick = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickAddMember(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.isEmergancy = false
        vc.profileVC = self
         vc.isProfile = true
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        
    }
    @IBAction func onClickEmergancy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.isEmergancy = true
        vc.profileVC = self
        vc.isProfile = true
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
    }
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews ")
        if emergencyModel != nil {
          
               emergency.append(emergencyModel)
                emergencyModel = nil
                cvNumber.reloadData()
                heightCVEmergancy =  heightCVEmergancy + 50.0
                heightConstrainstNumber.constant = CGFloat(heightCVEmergancy)
               
        }
          if memberModel != nil      {
                member.append(memberModel)
                memberModel = nil
                cvMember.reloadData()
                heightCVFamily =  heightCVFamily + 50.0
                print("family " , member.count)
                heightConstrainstMember.constant = CGFloat(heightCVFamily)
            }
            
        }
    
    
    func doSubmitData() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        var member_family_id = ""
        var member_name = ""
        var member_age = ""
        var member_relation = ""
        
        
        if member.count > 0 {
            
            for data in member {
                
                if data.user_family_id == "" {
                    if member_family_id == "" {
                         member_family_id =  member_family_id + "0"
                    } else {
                        member_family_id =  member_family_id + "~" + "0"
                    }
                   
                } else {
                    if member_family_id == "" {
                        member_family_id =  member_family_id + data.user_family_id
                    } else {
                        member_family_id =  member_family_id + "~" + data.user_family_id
                    }
                   
                }
                
                if member_name == "" {
                    member_name = member_name + data.member_name
                } else {
                    member_name = member_name + "~" + data.member_name
                }
                
                if member_age == "" {
                    member_age = member_age + data.member_age
                } else {
                    member_age = member_age + "~" + data.member_age
                }
                if member_relation == "" {
                    member_relation = member_relation + data.member_relation_name
                } else {
                    member_relation = member_relation + "~" + data.member_relation_name
                }
                
                
                
            }
            
            
        }
        
        var emergencyContact_id = ""
        var person_name = ""
        var person_mobile = ""
        var relation = ""
        
        if emergency.count > 0 {
            
            for data in emergency {
                
                if data.emergencyContact_id == "" {
                    
                    if emergencyContact_id == "" {
                        
                        emergencyContact_id =  emergencyContact_id + "0"
                        
                    } else {
                        emergencyContact_id = emergencyContact_id + "~" + "0"
                    }
                    
                    
                } else {
                    
                    if emergencyContact_id == "" {
                        
                        emergencyContact_id =  emergencyContact_id + data.emergencyContact_id
                        
                    } else {
                         emergencyContact_id = emergencyContact_id + "~" + data.emergencyContact_id
                    }
                  
                }
                
                if person_name == "" {
                    person_name = person_name + data.person_name
                } else {
                    person_name = person_name + "~" + data.person_name
                }
                
                if person_mobile == "" {
                    person_mobile = person_mobile + data.person_mobile
                } else {
                    person_mobile = person_mobile + "~" + data.person_mobile
                }
                if relation == "" {
                    relation = relation + data.relation
                } else {
                    relation = relation + "~" + data.relation
                }
                
                
            }
            
        }
        
        
        
        var user_profile_pic = ""
        
        
        if ivProfile.image != nil {
             user_profile_pic = convertImageTobase64(imageView: ivProfile)
        }
        
        let fullname = tfName.text! + " " + tfLastName.text!
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "addUser":"update",
                      "user_id":doGetLocalDataUser().user_id!,
                      "society_id":doGetLocalDataUser().society_id!,
                      "block_id":doGetLocalDataUser().block_id!,
                      "floor_id":doGetLocalDataUser().floor_id!,
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "user_first_name":tfName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_full_name": fullname,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "user_password":UserDefaults.standard.string(forKey: StringConstants.KEY_PASSWORD)!,
                      "user_id_proof":"",
                      "member_family_id":member_family_id,
                      "member_name":member_name,
                      "member_age":member_age,
                      "member_relation":member_relation,
                      "emergencyContact_id":emergencyContact_id,
                      "person_name":person_name,
                      "person_mobile":person_mobile,
                      "relation":relation,
                      "user_profile_pic":user_profile_pic,
                      "owner_name":"",
                      "owner_email":"",
                      "owner_mobile":tfMobile.text!,
                      "user_type":doGetLocalDataUser().user_type!]
        
        
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseRegistration.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.doGetProfileData()
                       // Utils.setHomeRootLogin()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    
    func doGetProfileData() {
       /// showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "getProfileData":"getProfileData",
                      "user_id":doGetLocalDataUser().user_id!,
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentDataUpdateController, parameters: params) { (json, error) in
            
            if json != nil {
               // self.hideProgress()
                do {
                    let loginResponse = try JSONDecoder().decode(LoginResponse.self, from:json!)
                    
                    
                    if loginResponse.status == "200" {
                        if let encoded = try? JSONEncoder().encode(loginResponse) {
                            UserDefaults.standard.set(encoded, forKey: StringConstants.KEY_LOGIN_DATA)
                        }
                        self.initUI()
                       
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
    
    @IBAction func onClickEditPhoto(_ sender: Any) {
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
    
    @objc func onClickDeleteMemeber(seder:UIButton) {
        let index = seder.tag
        print("onClickDeleteMemeber" , index)
        
        doDeletrMember(user_family_id: member[index].user_family_id, index: index)
        
    }
    @objc func onClickDeleteEmergancy(seder:UIButton) {
        let index = seder.tag
         print("onClickDeleteEmergancy" , index)
        doDeletrNumber(emergencyContact_id: emergency[index].emergencyContact_id, index: index)
    }
    
    func doDeletrMember(user_family_id:String,index:Int) {
       // showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "deleteFamilyMember":"deleteFamilyMember",
                      "user_family_id":user_family_id]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            
            if json != nil {
               // self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                       
                        self.member.remove(at: index)
                        self.cvMember.reloadData()
                         self.doGetProfileData()
                        
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
    func doDeletrNumber(emergencyContact_id:String,index:Int) {
        // showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "deleteEmergencyContact":"deleteEmergencyContact",
                      "emergencyContact_id":emergencyContact_id]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            
            if json != nil {
                // self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.emergency.remove(at: index)
                        self.cvMember.reloadData()
                        self.doGetProfileData()
                        
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
    
    
    
    func doCallSwichApartment(unit_status:String) {
        // showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "switchClose":"switchClose",
                      "unit_status":unit_status,
                      "unit_id":doGetLocalDataUser().unit_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        requrest.requestPost(serviceName: ServiceNameConstants.switchController, parameters: params) { (json, error) in
            
            if json != nil {
                // self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                    self.doGetProfileData()
                        
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
    
    
    func doSwitchToOnwer() {
        showProgress()
        
       
      
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
    
          let  params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "switchUser":"switchUser",
                      "society_id":doGetLocalDataUser().society_id!,
                      "owner_name":doGetLocalDataUser().owner_name!,
                      "owner_email":doGetLocalDataUser().owner_email!,
                      "owner_mobile":doGetLocalDataUser().owner_mobile!,
                      "addUser":"0",
                      "user_id":doGetLocalDataUser().user_id!,
                      "unit_id":doGetLocalDataUser().unit_id!]
       
        
        
        
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
}

extension ProfileVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvNumber {
            return emergency.count
        }
        
        return member.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == cvNumber {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item, for: indexPath) as! InfoFamalyMemberCell
            cell.lbName.text = self.emergency[indexPath.row].person_name
            cell.lbMobile.text = emergency[indexPath.row].person_mobile
            cell.lbReletion.text = emergency[indexPath.row].relation
            cell.bDelete.isHidden = false
            cell.bDelete.tag = indexPath.row
            cell.bDelete.addTarget(self, action: #selector(onClickDeleteEmergancy(seder:)), for: .touchUpInside)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item, for: indexPath) as!InfoFamalyMemberCell
        cell.lbName.text = member[indexPath.row].member_name
        cell.lbMobile.text = member[indexPath.row].member_age
        cell.lbReletion.text = member[indexPath.row].member_relation_name
        cell.bDelete.isHidden = false
        cell.bDelete.tag = indexPath.row
        cell.bDelete.addTarget(self, action: #selector(onClickDeleteMemeber(seder:)), for: .touchUpInside)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth-4, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
