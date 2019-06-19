//
//  ResourcesVC.swift
//  Finca
//
//  Created by anjali on 18/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseEmployee : Codable {
    let status : String!// "status" : "200",
    let message : String!// "message" : "Get Employee Type success."
    let employee_Type : [ModelEmployeeType]!
    
}
struct ModelEmployeeType : Codable {
   
    let society_id : String! //"society_id" : "48",
    let emp_type_icon : String! //"emp_type_icon" : "emp_icon\/Maids_1560837068.png",
    let emp_type_status : String! //"emp_type_status" : "0",
    let emp_type_id : String! //"emp_type_id" : "74",
   let emp_type_name : String! // "emp_type_name" : "Maids"
}

class ResourcesVC: BaseVC {
    @IBOutlet weak var cvData: UICollectionView!
    let itemCell = "ResourceCell"
      var employee_Types = [ModelEmployeeType]()
    override func viewDidLoad() {
        super.viewDidLoad()

        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
        // Do any additional setup after loading the view.
        doGetEmployes()
    }
    
    func doGetEmployes() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "getEmployeeType":"getEmployeeType",
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.employeeTypeController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseEmployee.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.employee_Types.append(contentsOf: response.employee_Type)
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
extension  ResourcesVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! ResourceCell
        cell.lbTitle.text = employee_Types[indexPath.row].emp_type_name
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString: employee_Types[indexPath.row].emp_type_icon)
       // cell.lbNumber.text =  myParkings[indexPath.row].vehicle_no
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return employee_Types.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        //if
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "idResourceEmployeeListVC") as! ResourceEmployeeListVC
        vc.emp_type_id = employee_Types[indexPath.row].emp_type_id
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}
