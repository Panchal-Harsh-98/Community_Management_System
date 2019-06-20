//
//  AddExpMemberDialogVC.swift
//  Finca
//
//  Created by harsh panchal on 19/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class AddExpMemberDialogVC: BaseVC {
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfMobileNo: UITextField!
    @IBOutlet weak var tfNoOfVisitor: UITextField!
    @IBOutlet weak var tfVisitingDate: UITextField!
    @IBOutlet weak var tfVisitingTime: UITextField!
    @IBOutlet weak var tfVisitingReason: UITextField!
    @IBOutlet weak var lblMainView: UIView!
    @IBOutlet weak var viewChooseImage: UIView!
    @IBOutlet weak var imgVisitor: UIImageView!
    let toolBar = UIToolbar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMainView.layer.cornerRadius = 10
        imgVisitor.layer.borderColor = #colorLiteral(red: 0.9556098902, green: 0, blue: 0, alpha: 1)
        imgVisitor.layer.cornerRadius =  imgVisitor.frame.height/2
        imgVisitor.layer.borderWidth = 2
        viewChooseImage.layer.borderWidth = 0.5
        viewChooseImage.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        dp(tfVisitingDate)
        dp(tfVisitingTime)
    }
    
    func dp(_ sender: UITextField) {
        switch sender {
        case tfVisitingDate:
            let datePickerView = UIDatePicker()
            datePickerView.datePickerMode = .date
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker(sender: )))
            doneButton.tag = 1
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker(sender: )))
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            tfVisitingDate.inputAccessoryView = toolBar
            sender.inputView = datePickerView
            
            datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
            break;
            
        case tfVisitingTime:
            let timePickerView = UIDatePicker()
            timePickerView.datePickerMode = .time
            toolBar.barStyle = UIBarStyle.default
            toolBar.isTranslucent = true
            toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            toolBar.sizeToFit()
             
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker(sender: )))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePicker(sender: )))
            
            toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
            toolBar.isUserInteractionEnabled = true
            tfVisitingTime.inputAccessoryView = toolBar
            
            sender.inputView = timePickerView
           
            timePickerView.addTarget(self, action: #selector(handleTimePicker(sender:)), for: .valueChanged)
            break;
            
        default:
            break;
        }
        
        
    }
    
    @objc func donePicker(sender : UIBarButtonItem) {
        switch sender.tag {
        case 1:
            print ("date")
        case 2:
            print("time")
        default:
            break;
        }
//        toolBar.removeFromSuperview()
//        datePickerView.removeFromSuperview()
    }
    
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        tfVisitingDate.text = dateFormatter.string(from: sender.date)
        
    }
    @objc func handleTimePicker(sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        tfVisitingTime.text = formatter.string(from: sender.date)
        
    }
    @IBAction func btnChooseImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        
        //        let params = ["key":ServiceNameConstants.API_KEY,
        //                      "addExVisitor":"addExVisitor",
        //                      "society_id":doGetLocalDataUser().society_id!,
        //                      "floor_id":doGetLocalDataUser().floor_id!,
        //                      "block_id":doGetLocalDataUser().block_id!,
        //                      "unit_id":doGetLocalDataUser().unit_id!,
        //                      "user_id":doGetLocalDataUser().user_id!,
        //                      "visitor_name":,
        //                      "visitor_mobile":"",
        //                      "number_of_visitor":"",
        //                      "visiting_reason":"",
        //                      "visitor_profile_photo":"",
        //                      "visit_date":"",
        //                      "visit_time":"",
        //                      "user_name":"",
        //                      "update":"",
        //                      "visitor_id":""]
        //
        //        print("param" , params)
        //
        //        let request = AlamofireSingleTon.sharedInstance
        //
        //        request.requestPost(serviceName: ServiceNameConstants.VISITOR_CONTROLLER, parameters: params) { (json, error) in
        //            self.hideProgress()
        //
        //            if json != nil {
        //
        //                do {
        //
        //                    let response = try JSONDecoder().decode(ExpectedVisitorResponse.self, from:json!)
        //                    if response.status == "200" {
        //                        self.exp_visitor_list.append(contentsOf: response.visitor)
        //                        self.tbvExpectedVisitor.reloadData()
        //
        //
        //                    }else {
        //
        //                    }
        //                    print(json as Any)
        //                } catch {
        //                    print("parse error")
        //                }
        //            }
        //        }
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
extension AddExpMemberDialogVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imgVisitor.image = selectedImage
    }
}
