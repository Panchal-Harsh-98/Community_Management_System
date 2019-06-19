//
//  Utils.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class Utils: NSObject {
    
   static func setRoundImageWithBorder(imageView:UIImageView , color:UIColor){
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = color.cgColor
        imageView.layer.borderWidth = 2
    }
    static func setImageFromUrl(imageView:UIImageView , urlString:String ) {
        // print("utils kf string : ==== "+urlString)
        imageView.kf.setImage(
            with: URL(string: urlString),
            placeholder: UIImage(named: "placeholder"),
            options: [])
        {
            result in
            switch result {
            case .success( _):
                // print("Task done for: \(value.source.url?.absoluteString ?? "")")
                
                break
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
                
                break
            }
        }
    }
    static func setHomeRootLogin() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let gotoDashboardVC = storyBoard.instantiateViewController(withIdentifier: "idLoginVC") as! LoginVC
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let nav : UINavigationController = UINavigationController()
        nav.viewControllers  = [gotoDashboardVC]
        nav.isNavigationBarHidden = true
        appdelegate.viewC = gotoDashboardVC
        appdelegate.window!.rootViewController = nav
        
    }
   
    static func setRoundImage(imageView:UIImageView ){
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        
    }
    
}
