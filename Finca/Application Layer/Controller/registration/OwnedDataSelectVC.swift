//
//  OwnedDataSelectVC.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseRegistration : Codable {
    var user_id:String!//"user_id" : "408",
   var message:String! //"message" : "Registration success.",
   var status:String!// "status" : "200"
}

class OwnedDataSelectVC: BaseVC,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var tfOwnerName: ACFloatingTextfield!
    @IBOutlet weak var tfOwnerEmail: ACFloatingTextfield!
    @IBOutlet weak var tfOwnerMobile: ACFloatingTextfield!
    
     @IBOutlet weak var tfFirstName: ACFloatingTextfield!
     @IBOutlet weak var tfLastName: ACFloatingTextfield!
    @IBOutlet weak var tfHouseNo: ACFloatingTextfield!
    @IBOutlet weak var tfEmail: ACFloatingTextfield!
    @IBOutlet weak var tfMobile: ACFloatingTextfield!
    @IBOutlet weak var tfPassword: ACFloatingTextfield!
    @IBOutlet weak var tfPermanentAddress: ACFloatingTextfield!
    
    
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var ivImage: UIImageView!
    @IBOutlet weak var lbUsetType: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewOwner: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    
    var userType : String!
    var unitModel : UnitModel!
    var blockModel:BlockModel!
    var modelInfoMember:ModelInfoMember!
    var society_id:String!
    var mobileNumber:String!
    var dataFamelyMember = [ModelInfoMember]()
    var dataEmergancy = [ModelInfoMember]()
    var isImagePick = false
    @IBOutlet weak var cvFamily: UICollectionView!
    @IBOutlet weak var cvEmergancy: UICollectionView!
    @IBOutlet weak var heightConCVFamily: NSLayoutConstraint!
    @IBOutlet weak var heightConCVEmergancy: NSLayoutConstraint!
    @IBOutlet weak var bPassword: UIButton!
    
    var item = "InfoFamalyMemberCell"
 
    var  heightCVFamily = 0.0
    var  heightCVEmergancy = 0.0
     var iconClick = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        changeButtonImageColor(btn: bBack, image: "back", color: UIColor.white)
        
       Utils.setRoundImageWithBorder(imageView: ivImage, color: ColorConstant.colorRed)
        
        if userType == "1" {
            // owner
            lbUsetType.text = "Owned"
            viewOwner.isHidden = true
            heightConstraint.constant = 8.0
        } else {
            // 3 renter
             lbUsetType.text = "Rented"
            
        }
        
        cvFamily.delegate = self
        cvFamily.dataSource = self
        let inbFloor = UINib(nibName: item, bundle: nil)
        cvFamily.register(inbFloor, forCellWithReuseIdentifier: item)
        
        cvEmergancy.delegate = self
        cvEmergancy.dataSource = self
        cvEmergancy.register(inbFloor, forCellWithReuseIdentifier: item)
        
        heightConCVFamily.constant = CGFloat(heightCVFamily)
        heightConCVEmergancy.constant = CGFloat(heightCVEmergancy)
        
        
        
         tfOwnerName.delegate = self
         tfOwnerEmail.delegate = self
         tfOwnerMobile.delegate = self
         tfFirstName.delegate = self
         tfLastName.delegate = self
         tfHouseNo.delegate = self
         tfEmail.delegate = self
         tfMobile.delegate = self
         tfPassword.delegate = self
         tfPermanentAddress.delegate = self
        
        tfMobile.isEnabled = false
        tfMobile.text = mobileNumber
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden), name: UIResponder.keyboardDidHideNotification, object: nil)
        
           addInputAccessoryForTextFields(textFields: [tfOwnerName,tfOwnerEmail,tfOwnerMobile,tfFirstName,tfLastName,tfEmail,tfPassword,tfPermanentAddress], dismissable: true, previousNextable: true)

        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    
    @IBAction func onClickPasswordVisible(_ sender: Any) {
        if(iconClick == true) {
            tfPassword.isSecureTextEntry = false
            bPassword.setImage(UIImage(named: "visibility_black"), for: .normal)
        } else {
            tfPassword.isSecureTextEntry = true
            bPassword.setImage(UIImage(named: "visibility_off"), for: .normal)
        }
        iconClick = !iconClick
    }
    
    
    func isValidate() -> Bool {
        var isValidate = true
        
        if tfFirstName.text == "" {
            isValidate = false
            tfFirstName.showErrorWithText(errorText: "Enter Your First Name")
        }
        if tfLastName.text == "" {
            isValidate = false
            tfLastName.showErrorWithText(errorText: "Enter Your Last Name")
        }
        if tfHouseNo.text == "" {
            isValidate = false
            tfHouseNo.showErrorWithText(errorText: "Select House Number")
        }
        
        if tfEmail.text != "" {
            if !isValidEmail(email: tfEmail.text!) {
                isValidate = false
                tfEmail.showErrorWithText(errorText: "Enter Valid Email Address")
            }
        }
        if tfPassword.text == "" {
            isValidate = false
            tfPassword.showErrorWithText(errorText: "Enter  password")
        }
        return isValidate
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    @IBAction func onClickChoosePhoto(_ sender: Any) {
        
        openPhotoSelecter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("djgfsjgdfjgjsf")
        
        if unitModel != nil {
            
            tfHouseNo.text = blockModel.block_name  + "-" + unitModel.unit_name!
          //  print("tetset " , unitModel.unit_name!)
        }
        
    }
    
    @IBAction func onClickSelectHouse(_ sender: Any) {
        let vc  = storyboard?.instantiateViewController(withIdentifier: "idSelectBlockAndRoomVC") as! SelectBlockAndRoomVC
        vc.society_id = society_id
        vc.ownedDataSelectVC = self
      //  vc.society_id = "17"
        self.navigationController?.pushViewController(vc, animated: true)
        
   // present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews ")
        if modelInfoMember != nil {
            if modelInfoMember.isEmergancy {
                dataEmergancy.append(modelInfoMember)
                modelInfoMember = nil
                cvEmergancy.reloadData()
                heightCVEmergancy =  heightCVEmergancy + 50.0
                heightConCVEmergancy.constant = CGFloat(heightCVEmergancy)
                print("Emergancy " , dataEmergancy.count)
            } else {
                 dataFamelyMember.append(modelInfoMember)
                modelInfoMember = nil
                cvFamily.reloadData()
                 heightCVFamily =  heightCVFamily + 50.0
                 print("family " , dataFamelyMember.count)
                heightConCVFamily.constant = CGFloat(heightCVFamily)
                 }
            
        }
    }
    
    @IBAction func onClickAddMember(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.isEmergancy = false
        vc.ownedDataSelectVC = self
        vc.isProfile = false
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        
    }
    @IBAction func onClickEmergancy(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogFamilyMember") as! DailogFamilyMember
        vc.isEmergancy = true
        vc.isProfile = false
         vc.ownedDataSelectVC = self
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
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
         self.ivImage.image = selectedImage
        self.isImagePick = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func onClickSubmit(_ sender: Any) {
        if isValidate() {
            doSubmitData()
        }
        
    }
    
    
    func doSubmitData() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        var member_family_id = ""
        var member_name = ""
        var member_age = ""
        var member_relation = ""
        
        
       
        
        
        
        if dataFamelyMember.count > 0 {
            
            for data in dataFamelyMember {
               
                if member_family_id == "" {
                    member_family_id =  member_family_id + "0"
                } else {
                     member_family_id = member_family_id + "~" + "0"
                }
                
                if member_name == "" {
                    member_name = member_name + data.name
                } else {
                    member_name = member_name + "~" + data.name
                }
               
                if member_age == "" {
                    member_age = member_age + data.number
                } else {
                    member_age = member_age + "~" + data.number
                }
                if member_relation == "" {
                    member_relation = member_relation + data.relation
                } else {
                    member_relation = member_relation + "~" + data.relation
                }
                
                
                
            }
            
            
        }
        
        var emergencyContact_id = ""
        var person_name = ""
        var person_mobile = ""
        var relation = ""
        
        if dataEmergancy.count > 0 {
            
            for data in dataEmergancy {
                
                if emergencyContact_id == "" {
                    emergencyContact_id =  emergencyContact_id + "0"
                } else {
                    emergencyContact_id = emergencyContact_id + "~" + "0"
                }
                
                if person_name == "" {
                    person_name = person_name + data.name
                } else {
                    person_name = person_name + "~" + data.name
                }
                
                if person_mobile == "" {
                    person_mobile = person_mobile + data.number
                } else {
                    person_mobile = person_mobile + "~" + data.number
                }
                if relation == "" {
                    relation = relation + data.relation
                } else {
                    relation = relation + "~" + data.relation
                }
                
                
            }
            
        }
        
       
        
        var user_profile_pic = ""
        
        
        if isImagePick {
            user_profile_pic = convertImageTobase64(imageView: ivImage)
        }
        
        
        let fullname = tfFirstName.text! + " " + tfLastName.text!
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "addUser":"insert",
                      "user_id":"0",
                      "society_id":society_id!,
                      "block_id":blockModel.block_id!,
                      "floor_id":unitModel.floor_id!,
                      "unit_id":unitModel.unit_id!,
                      "user_first_name":tfFirstName.text!,
                      "user_last_name":tfLastName.text!,
                      "user_full_name": fullname,
                      "user_mobile":tfMobile.text!,
                      "user_email":tfEmail.text!,
                      "user_password":tfPassword.text!,
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
                      "owner_name":tfOwnerName.text!,
                      "owner_email":tfOwnerEmail.text!,
                      "owner_mobile":tfMobile.text!,
                      "user_type":userType!]
        
        
        
     
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.residentRegisterController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseRegistration.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                     
                        Utils.setHomeRootLogin()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func addInputAccessoryForTextFields(textFields: [UITextField], dismissable: Bool = true, previousNextable: Bool = false) {
        for (index, textField) in textFields.enumerated() {
            let toolbar: UIToolbar = UIToolbar()
            toolbar.sizeToFit()
            
            var items = [UIBarButtonItem]()
            if previousNextable {
                let previousButton = UIBarButtonItem(image: UIImage(named: "up-arrow"), style: .plain, target: nil, action: nil)
                previousButton.width = 30
                if textField == textFields.first {
                    previousButton.isEnabled = false
                } else {
                    previousButton.target = textFields[index - 1]
                    previousButton.action = #selector(UITextField.becomeFirstResponder)
                }
                
                let nextButton = UIBarButtonItem(image: UIImage(named: "down-arrow"), style: .plain, target: nil, action: nil)
                nextButton.width = 30
                if textField == textFields.last {
                    nextButton.isEnabled = false
                } else {
                    nextButton.target = textFields[index + 1]
                    nextButton.action = #selector(UITextField.becomeFirstResponder)
                }
                items.append(contentsOf: [previousButton, nextButton])
            }
            
            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing))
            items.append(contentsOf: [spacer, doneButton])
            
            
            toolbar.setItems(items, animated: false)
            textField.inputAccessoryView = toolbar
        }
    }
    
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
      
        
        let contentInsets: UIEdgeInsets = UIEdgeInsets.zero
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
    }
    
    private func textFieldDidBeginEditing(textField: UITextField) {
        tfFirstName = (textField as! ACFloatingTextfield)
    }
    
    private func textFieldDidEndEditing(textField: UITextField) {
        tfFirstName = nil
    }
    @objc  func keyboardWillShow(notification: NSNotification) {
        //Need to calculate keyboard exact size due to Apple suggestions
     
        
        self.scrollview.isScrollEnabled = true
        let keyboardSize = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        self.scrollview.contentInset = contentInsets
        self.scrollview.scrollIndicatorInsets = contentInsets
        //viewHieght.constant = contentInsets.bottom
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize.height
        if tfFirstName != nil
        {
            if (!aRect.contains(tfFirstName!.frame.origin))
            {
                self.scrollview.scrollRectToVisible(tfFirstName!.frame, animated: true)
            }
        }
    }

}

extension OwnedDataSelectVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvEmergancy {
            return dataEmergancy.count
        }
        
        return dataFamelyMember.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == cvEmergancy {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item, for: indexPath) as! InfoFamalyMemberCell
            cell.lbName.text = dataEmergancy[indexPath.row].name
            cell.lbMobile.text = dataEmergancy[indexPath.row].number
            cell.lbReletion.text = dataEmergancy[indexPath.row].relation
        
            return cell
        }
        
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item, for: indexPath) as!InfoFamalyMemberCell
        cell.lbName.text = dataFamelyMember[indexPath.row].name
        cell.lbMobile.text = dataFamelyMember[indexPath.row].number
        cell.lbReletion.text = dataFamelyMember[indexPath.row].relation
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
