//
//  SplashVC.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class SplashVC: BaseVC {
    
    @IBOutlet weak var progressBar: NVActivityIndicatorView!
    @IBOutlet weak var ivSWLogo: UIImageView!
    @IBOutlet weak var ivLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ivLogo.setImageColor(color: UIColor.white)
        ivSWLogo.setImageColor(color: UIColor.white)
        
        progressBar.color = UIColor.white
        progressBar.startAnimating()
        
       
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(callback), userInfo: nil, repeats: false)
        
    }
    
    @objc func callback() {
        if !isKeyPresentInUserDefaults(key: StringConstants.KEY_LOGIN) {
            
           // let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idLoginVC")as! LoginVC
            let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "idNavLocation")as! UINavigationController
            self.present(loginVc, animated: true, completion: nil)
            
        } else {
        let homeVC = self.storyboard?.instantiateViewController(withIdentifier: StringConstants.HOME_NAV_CONTROLLER)as! SWRevealViewController
            
          ///  let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idNavMainHome")as! UINavigationController
            
            
             //  let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "idNavMain")as! UINavigationController
            
           /// self.present(homeVC, animated: true, completion: nil)
            
          self.self.navigationController?.pushViewController(homeVC, animated: true)
        }
        
    }
   
}
