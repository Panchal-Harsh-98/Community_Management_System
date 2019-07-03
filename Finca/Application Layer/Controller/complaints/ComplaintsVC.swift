//
//  ComplaintsVC.swift
//  Finca
//
//  Created by harsh panchal on 01/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ComplaintsVC: BaseVC {

    @IBOutlet weak var bMenu: UIButton!
    let flagViewVerification = false
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doCallGetComplainApi()
    }
    
    @IBAction func btnAddComplaint(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idAddComplaintsVC")as! AddComplaintsVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if flagViewVerification == true{
            doCallGetComplainApi()
        }
    }
    func doCallGetComplainApi(){
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getComplain":"getComplain",
                      "society_id":doGetLocalDataUser().society_id!,
                      "unit_id":doGetLocalDataUser().unit_id!]
        
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
}
