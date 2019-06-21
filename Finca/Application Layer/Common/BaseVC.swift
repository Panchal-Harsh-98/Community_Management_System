//
//  BaseVC.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BaseVC: UIViewController , UITextFieldDelegate , SWRevealViewControllerDelegate{
    var PView : NVActivityIndicatorView!
    var viewSub : UIView!
    var overlyView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
//        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    func doInintialRevelController(bMenu:UIButton) {
        revealViewController().delegate = self
        if self.revealViewController() != nil {
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if revealController.frontViewPosition == FrontViewPosition.left     // if it not statisfy try this --> if
        {
            overlyView.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height)
            //overlyView.backgroundColor = UIColor.red
            self.view.addSubview(overlyView)
            //self.view.isUserInteractionEnabled = false
        }
        else
        {
            overlyView.removeFromSuperview()
            //self.view.isUserInteractionEnabled = true
        }
    }
    
    func hideKeyBoardHideOutSideTouch() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    // strrt done button keyborad
    func doneButtonOnKeyboard(textField: UITextField){
        let kb = UIToolbar()
        kb.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClickKeyboard))
        kb.items = [doneButton]
        textField.inputAccessoryView = kb
    }
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    @objc func doneClickKeyboard(){
        view.endEditing(true)
    }

    //end
    
    func doGetLocalDataUser()->LoginResponse{
        var userLocalData : LoginResponse? = nil
        if let data = UserDefaults.standard.data(forKey: StringConstants.KEY_LOGIN_DATA), let decoded = try? JSONDecoder().decode(LoginResponse.self, from: data){
            userLocalData = decoded
        }
        return userLocalData!
    }
    
    func closeKeyboard() {
        view.endEditing(true)
    }
    
    //star
    
    //Todo show alert for messsage only
    func showAlertMessage(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            // self.onClickDone()
        }))
        self.present(alert, animated: true)
    }
    
    //Todo show alert for messsage only with click
    func showAlertMessageWithClick(title:String, msg:String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.onClickDone()
        }))
        
        
        self.present(alert, animated: true)
    }
    func onClickDone() {
        
    }
    //end
    
    
    func showProgress() {
        viewSub = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        viewSub.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        //    myView.frame.height/2
        viewSub.layer.cornerRadius = 20
        viewSub.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        //    myView.frame.height/2
        let frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        PView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType(rawValue: 32), color: ColorConstant.colorAccent,  padding: 15)
        PView.center = viewSub.center
        PView.backgroundColor = UIColor.white
        PView.layer.cornerRadius = 10
        PView.layer.shadowOpacity = 0.5
        PView.layer.masksToBounds = false
        PView.layer.shadowOffset = CGSize.zero
        viewSub.addSubview(PView)
        PView.startAnimating()
        self.view.addSubview(viewSub)
        
    }
    func hideProgress() {
        PView.stopAnimating()
        viewSub.removeFromSuperview()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    
    func doPopBAck(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func changeButtonImageColor(btn:UIButton , image:String,color:UIColor) {
        
        let origImage = UIImage(named: image)
        let tintedImage = origImage?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = color
    }
    
    func convertImageTobase64(imageView:UIImageView) -> String {
        let imageData = imageView.image?.jpegData(compressionQuality: 0.25)
       // let imageData = UIImageJPEGRepresentation(imageView.image!,0.25)
        let strBase64 = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
   
    
    func getChatCount() -> String{
        return UserDefaults.standard.string(forKey: StringConstants.CHAT_STATUS)!
    }
    func getNotiCount() -> String{
        return UserDefaults.standard.string(forKey: StringConstants.READ_STATUS)!
    }
}
