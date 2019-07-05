//
//  TabMyVC.swift
//  Finca
//
//  Created by anjali on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
struct ResponseMyParking : Codable {
    let  message : String!//  "message" : "Get Parking Detail success.",
    let  status : String!//"status" : "200"
    let myParking:[MyParkingModel]!
}
struct MyParkingModel : Codable {
   let  parking_type : String! //"parking_type" : "0",
   let  parking_id : String! //"parking_id" : "1645",
   let  block_id : String! //"block_id" : "126",
   let  floor_id : String! //"floor_id" : "518",
   let  unit_id : String! //"unit_id" : "2119",
   let  parking_name : String! //"parking_name" : "C-1",
   let  vehicle_no : String! //"vehicle_no" : "gj 01 hu 420",
   let  socieaty_parking_name : String! //"socieaty_parking_name" : "Ground1",
   let  parking_status : String! //"parking_status" : "1",
   let  sociaty_id : String! //"sociaty_id" : null,
   let  society_parking_id : String! //"society_parking_id" : "49"
}
class TabMyVC: BaseVC {

    @IBOutlet weak var heightConstVehicle: NSLayoutConstraint!
    @IBOutlet weak var lbParking: UILabel!
    @IBOutlet weak var lbVehicles: UILabel!
    @IBOutlet weak var cvParkingSlot: UICollectionView!
    @IBOutlet weak var cvVehicleNumner: UICollectionView!
    let itemCell = "MyVehicleNumberCell"
    let itemCellParking = "ParkingSlotCell"
     var myParkings = [MyParkingModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        cvVehicleNumner.delegate = self
        cvVehicleNumner.dataSource = self
        cvParkingSlot.delegate = self
        cvParkingSlot.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvVehicleNumner.register(inb, forCellWithReuseIdentifier: itemCell)
        
         // Do any additional setup after loading the view.
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: cvParkingSlot.bounds.width/3, height: 100)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        cvParkingSlot!.collectionViewLayout = layout
        
        
        let inbPark = UINib(nibName: itemCellParking, bundle: nil)
        cvParkingSlot.register(inbPark, forCellWithReuseIdentifier: itemCellParking)
        
        heightConstVehicle.constant = 0.0
        doGetParking()
        
    }
    
    
    
    func doGetParking() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMyParking":"getMyParking",
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getParkingDetailController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseMyParking.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.myParkings.append(contentsOf: response.myParking)
                        self.cvVehicleNumner.reloadData()
                        self.cvParkingSlot.reloadData()
                        
                        
                        self.lbParking.text = "Parking :" + String(response.myParking.count)
                         self.lbVehicles.text = "Vehicles :" + String(response.myParking.count)
                        
                        let count = response.myParking.count
                       
                        if   count % 2 == 0 {
                            self.heightConstVehicle.constant = CGFloat(count/2) * 35.0
                        } else {
                            
                            self.heightConstVehicle.constant = CGFloat(count/2) * 35.0 + 30
                            
                        }
                        
                        
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
extension TabMyVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MY")
    }
    
}

extension  TabMyVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvParkingSlot {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellParking, for: indexPath) as! ParkingSlotCell
            
            cell.lbAllocate.text = myParkings[indexPath.row].parking_name +  "  " + myParkings[indexPath.row].socieaty_parking_name
            
            
            return  cell
            
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! MyVehicleNumberCell
        
        cell.lbNumber.text =  myParkings[indexPath.row].vehicle_no
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
       
        return myParkings.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == cvParkingSlot {
            let yourWidth = collectionView.bounds.width / 2
            return CGSize(width: yourWidth - 2, height: 200)
        }
        
        //if
        let yourWidth = collectionView.bounds.width / 2
        return CGSize(width: yourWidth - 5, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cvVehicleNumner {
             return 4
        }
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == cvParkingSlot {
            return 10
        }
        return 4
    }
   
}
