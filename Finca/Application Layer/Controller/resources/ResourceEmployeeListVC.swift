//
//  ResourceEmployeeListVC.swift
//  Finca
//
//  Created by anjali on 18/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseEmployeeList : Codable {
    let status : String!// "status" : "200",
    let message : String!// "message" : "Get Employee Type success."
    let employee:[ModelEmployeeList]!
    
}
struct ModelEmployeeList : Codable {
    let emp_status : String!//  "emp_status" : "1",
    let emp_address : String!// "emp_address" : "Test Addsres",
    let emp_type_id : String!// "emp_type_id" : "74",
    let emp_id : String!// "emp_id" : "131",
    let emp_sallary : String!// "emp_sallary" : "120000",
    let emp_name : String!// "emp_name" : "Test Bhai",
    let emp_id_proof : String!//  "emp_id_proof" : "",
    let entry_status : String!//  "entry_status" : "0",
    let emp_date_of_joing : String!// "emp_date_of_joing" : "",
    let emp_mobile : String!// "emp_mobile" : "9823998234",
    let emp_email : String!//  "emp_email" : "",
    let society_id : String!//  "society_id" : "48",
    let emp_profile : String!// "emp_profile" : "http:\/\/www.fincasys.com\/img\/emp\/user.png"
}
class ResourceEmployeeListVC: BaseVC {
    
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var tfSearch: UITextField!
    
    let itemCell = "EmployeeListCell"
    var emp_type_id:String!
    var employees = [ModelEmployeeList]()
    var filteredArray = [ModelEmployeeList]()
    
    @IBOutlet weak var bBack: UIButton!
    var shouldShowSearchResults = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvData.delegate = self
        cvData.dataSource = self
        changeButtonImageColor(btn: bBack, image: "back", color: UIColor.white)
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
        // Do any additional setup after loading the view.
        tfSearch.delegate = self
        doGetEmployes()
    }
    
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        shouldShowSearchResults = true
        
        didChangeSearchText(searchText: tfSearch.text!)
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        shouldShowSearchResults = false
        cvData.reloadData()
        return view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        shouldShowSearchResults = false
    }
    
    func doGetEmployes() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getEmployee":"getEmployee",
                      "emp_type_id":emp_type_id!,
                      "society_id":doGetLocalDataUser().society_id!,
                      "unit_id":doGetLocalDataUser().unit_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.employeeListController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseEmployeeList.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.employees.append(contentsOf: response.employee)
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
    
    @objc func onClickOnCall(sender:UIButton) {
        
        let index = sender.tag
        
        print("clcicl" , index)
        
        let phone = employees[index].emp_mobile!
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    func didChangeSearchText(searchText: String) {
        
        filteredArray = employees.filter({ (modelEmployeeList) -> Bool in
            // let searchChar = modelEmployeeList.emp_name
            
            return modelEmployeeList.emp_name.lowercased().contains(searchText.lowercased())
            
        })
        cvData.reloadData()
    }
    
}
extension  ResourceEmployeeListVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! EmployeeListCell
        
        if shouldShowSearchResults {
            cell.lbName.text = filteredArray[indexPath.row].emp_name
            
            Utils.setImageFromUrl(imageView: cell.ivImage, urlString: filteredArray[indexPath.row].emp_profile)
            // cell.lbNumber.text =  myParkings[indexPath.row].vehicle_no
            
            if filteredArray[indexPath.row].emp_status == "1" {
                // avilabe
                cell.lbStatus.text = "Available"
                cell.viewStatus.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7803921569, blue: 0.5176470588, alpha: 1)
            }else {
                // not
                cell.lbStatus.text = "Not Available"
                cell.viewStatus.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
            }
        } else {
            cell.lbName.text = employees[indexPath.row].emp_name
            
            Utils.setImageFromUrl(imageView: cell.ivImage, urlString: employees[indexPath.row].emp_profile)
            // cell.lbNumber.text =  myParkings[indexPath.row].vehicle_no
            
            if employees[indexPath.row].emp_status == "1" {
                // avilabe
                cell.lbStatus.text = "Available"
                cell.viewStatus.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.7803921569, blue: 0.5176470588, alpha: 1)
            }else {
                // not
                cell.lbStatus.text = "Not Available"
                cell.viewStatus.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.4509803922, blue: 0.4509803922, alpha: 1)
            }
        }
        
        
        
        
        cell.bCall.tag = indexPath.row
        cell.bCall.addTarget(self, action: #selector(onClickOnCall(sender:)), for: .touchUpInside)
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return filteredArray.count
        } else {
            return employees.count
        }
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        //if
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
}
