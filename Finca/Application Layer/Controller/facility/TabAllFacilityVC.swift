//
//  TabAllFacilityVC.swift
//  Finca
//
//  Created by anjali on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

struct ResponseFacility : Codable {
    let message: String!//" : "Get Facility success.",
    let status: String!//" : "200"
    let facility:[ModelFacility]!
}

struct ModelFacility : Codable {
    let  facility_type : String!//" : "1",
    let  facility_id : String!//" : "60",
    let  society_id : String!//" : "48",
    let  facility_photo : String!//" : "https:\/\/www.fincasys.com\/\/img\/facility\/1562057990.jpg",
    let  facility_status : String!//" : "0",
    let  facility_name : String!//" : "Gym"
 }

class TabAllFacilityVC: BaseVC {

    @IBOutlet weak var cvData: UICollectionView!
    var facilites = [ModelFacility]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doGetData()
    }
    

    func doGetData() {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getFacility":"getFacility",
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getFacilityController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseFacility.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                      
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
        
    }

}
extension TabAllFacilityVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALL FACILITY")
    }
    
}
