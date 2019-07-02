//
//  AddComplaintsVC.swift
//  Finca
//
//  Created by harsh panchal on 01/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class AddComplaintsVC: BaseVC {

    @IBOutlet weak var btnChooseImage: UIButton!
    @IBOutlet weak var imgComplaint: UIImageView!
    @IBOutlet weak var tfComplainTitle: UITextField!
    @IBOutlet weak var tfCompainDesc: UITextField!
    @IBOutlet weak var tfviewComplainTitle: UIView!
    @IBOutlet weak var tfviewComplainDescription: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    @IBAction func btnSaveComplain(_ sender: Any) {
        if doValidate(){
            doCallComplainRegisterApi()
        }
    }
    
    func doValidate()->Bool{
        if tfComplainTitle.text == ""{
            showAlertMessage(title: "", msg: "please mention a title for your complain")
            return false
        }
        if tfCompainDesc.text == ""{
            showAlertMessage(title: "", msg: "please mention a description for your complain")
            return false
        }
        if imgComplaint.image == UIImage(named: "no-image-available"){
            showAlertMessage(title: "", msg: "please select a image for your complain")
            return false
        }
        return true
    }
    func doCallComplainRegisterApi(){
    
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addComplain":"addComplain",
                      "society_id":doGetLocalDataUser().society_id!,
                      "compalain_title":tfComplainTitle.text!,
                      "complain_description":tfCompainDesc.text!,
                      "complain_date":"",
                      "complain_status":"0",
                      "complain_assing_to":doGetLocalDataUser().unit_name!,
                      "unit_id":doGetLocalDataUser().unit_id,
                      "user_name":doGetLocalDataUser().unit_name!,
                      "complain_photo":convertImageTobase64(imageView: imgComplaint)]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                    }else {
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
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
extension AddComplaintsVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        imgComplaint.image = selectedImage
    }
}
