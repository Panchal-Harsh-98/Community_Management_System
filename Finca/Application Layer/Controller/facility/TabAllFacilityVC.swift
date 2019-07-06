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
     let itemCell = "AllFacilityCell"
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
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.getFacilityController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseFacility.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                      self.facilites.append(contentsOf: response.facility)
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
extension TabAllFacilityVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "ALL FACILITY")
    }
    
}


extension  TabAllFacilityVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! AllFacilityCell
        
        cell.lbTitle.text =  facilites[indexPath.row].facility_name
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString: facilites[indexPath.row].facility_photo)
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return facilites.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idAllFacilityDetailsVC") as! AllFacilityDetailsVC
        
        vc.modelFacility = facilites[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
