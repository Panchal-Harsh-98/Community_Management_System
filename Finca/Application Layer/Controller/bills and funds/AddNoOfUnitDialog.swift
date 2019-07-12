//
//  AddNoOfUnitDialog.swift
//  Finca
//
//  Created by harsh panchal on 11/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class AddNoOfUnitDialog: BaseVC {
    
    @IBOutlet weak var tfTextField: UITextField!
    var billDetail : Bill_Model!
    @IBOutlet weak var lblUnitPrice: UILabel!
    @IBOutlet weak var imgUnit: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblUnitPrice.text =  "Unit Price : "+StringConstants.RUPEE_SYMBOL+billDetail.unitPrice
        
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
    
    @IBAction func btnSubmit(_ sender: UIButton) {
        doCallAddunitApi()
    }
    func doCallAddunitApi(){
        self.showProgress()
     
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addBillUnit":"addBillUnit",
                      "receive_bill_id":billDetail.receiveBillID!,
                      "no_of_unit":billDetail.noOfUnit!,
                      "unit_photo":convertImageTobase64(imageView:imgUnit),
                      "society_id":doGetLocalDataUser().society_id!,
                      "user_name":doGetLocalDataUser().user_full_name!,
                      "bill_name":billDetail.billName!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.BILL_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
}
extension AddNoOfUnitDialog : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imgUnit.image = selectedImage
    }
}
