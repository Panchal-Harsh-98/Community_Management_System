//
//  TabMyFacilityVC.swift
//  Finca
//
//  Created by anjali on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

struct ResponseMyFacilily : Codable {
    let  status : String//" : "200",
    let  message : String//" : "Get Booking  success."
    let booking:[FacilityBookingModel]!
}

struct FacilityBookingModel : Codable {
    let book_request_date:String!//" : "",
    let payment_type:String!//" : "0",
    let facility_name:String!//" : "Gym",
    let booking_expire_date:String!//" : "2019-11-06",
    let unit_id:String!//" : "2121",
    let book_status:String!//" : "1",
    let society_id:String!//" : "48",
    let booking_id:String!//" : "65",
    let payment_received_date:String!//" : "2019-07-06 03:38:19pm",
    let facility_amount:String!//" : "100",
    let receive_amount:String!//" : "800.00",
    let no_of_person:String!//" : "2",
    let booked_date:String!//" : "2019-07-06",
    let payment_status:String!//" : "0",
    let facility_id:String!//" : "60",
    let facility_photo:String!//" : "https:\/\/www.fincasys.com\/\/img\/facility\/1562057990.jpg",
    let balancesheet_id:String!//" : "117",
    let unit_name:String!//" : "A-104"
    
}

class TabMyFacilityVC: BaseVC {

    @IBOutlet weak var cvData: UICollectionView!
     var booking = [FacilityBookingModel]()
     let itemCell = "MyFacilityCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        // Do any additional setup after loading the view.
        doGetData()
    }
    
    func doGetData() {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getFacility":"getFacility",
                      "society_id":doGetLocalDataUser().society_id!,
                      "unit_id":doGetLocalDataUser().unit_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getMyFacilityController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseMyFacilily.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.booking.append(contentsOf: response.booking)
                        self.cvData.reloadData()
                        
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
extension TabMyFacilityVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MY FACILITY")
    }
    
}
extension  TabMyFacilityVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! MyFacilityCell
        cell.lbTitle.text = booking[indexPath.row].facility_name
         cell.lbStartDate.text = "Start Date :"  + booking[indexPath.row].booked_date
        cell.lbEndDate.text = "End Date :"  + booking[indexPath.row].booking_expire_date
        cell.lbTotalPerson.text = "Total Person:" + booking[indexPath.row].no_of_person
        cell.lbAmount.text = StringConstants.RUPEE_SYMBOL + " " + booking[indexPath.row].receive_amount
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString:  booking[indexPath.row].facility_photo)
        cell.lbStatus.text = "Paid"
         return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return booking.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
   
    
}
