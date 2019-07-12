//
//  AllFacilityDetailsVC.swift
//  Finca
//
//  Created by anjali on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseFacilityDetails : Codable {
    let person_count : String!//" : "5",
    let booked_date : String!//" : "",
    let facility_status : String!//" : "0",
    let person_limit : String!//" : "50",
    let facility_amount : String!//" : "100",
    let facility_type : String!//" : "1",
    let facility_photo : String!//" : "https:\/\/www.fincasys.com\/img\/facility\/1562057990.jpg",
    let facility_name : String!//" : "Gym",
    let status : String!//" : "200",
    let balancesheet_id : String!//" : "117",
    let message : String!//" : "Get Facility success.",
    let society_id : String!//" : "48",
    let facility_id : String!//" : "60"
    let facilitybookDate : [FacilityBookDateModel]!
    
}
struct FacilityBookDateModel : Codable {
    let unit_name : String!//" : "A-101",
    let booked_date : String!//" : "2019-07-06",
    let book_status : String!//" : "1"
    
}


class AllFacilityDetailsVC: BaseVC {
    
    var modelFacility:ModelFacility!

    @IBOutlet weak var lbName: UILabel!
    
    @IBOutlet weak var lbAmount: UILabel!
    @IBOutlet weak var lbLimit: UILabel!
    @IBOutlet weak var lbCount: UILabel!
    
    @IBOutlet weak var ivImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        doDetails()
    }
    
    func doDetails() {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getFullFacilityDetails":"getFullFacilityDetails",
                      "facility_id":modelFacility.facility_id!,
                      "unit_name":doGetLocalDataUser().unit_name!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getFacilityController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseFacilityDetails.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        
                        Utils.setImageFromUrl(imageView: self.ivImage, urlString: response.facility_photo)
                        self.lbName.text = "Facility Name : " + response.facility_name
                        self.lbAmount.text = "Facility Amount : " + StringConstants.RUPEE_SYMBOL + response.facility_amount + " / Per Person/Per Month"
                         self.lbLimit.text = "Person Limit : " + response.person_limit
                         self.lbCount.text = "Person Limit : " + response.person_limit
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
        
    }

    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
}
