//
//  PollingVc.swift
//  Finca
//
//  Created by harsh panchal on 02/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class PollingVc: BaseVC {
    
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var tbvPoll: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
    }
    
    func doGetPollingQuestions(){
        print("delete success")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "deleteComplain":"deleteComplain",
                      "society_id":doGetLocalDataUser().society_id!,
                      "complain_id":ComplainList[index].complainID!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.ComplainList.removeAll()
                        self.doCallGetComplainApi()
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

