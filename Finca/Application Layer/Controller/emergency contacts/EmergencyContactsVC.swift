//
//  EmergencyContactsVC.swift
//  Finca
//
//  Created by harsh panchal on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class EmergencyContactsVC: BaseVC {
    @IBOutlet weak var tbvEmergencyContacts: UITableView!
    @IBOutlet weak var bMenu: UIButton!
    let itemCell = "EmergencyContactCell"
    var EmergencyNumberList = [EmergencyNumberModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doGetEmergencyNumber()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvEmergencyContacts.register(nib, forCellReuseIdentifier: itemCell)
        tbvEmergencyContacts.delegate = self
        tbvEmergencyContacts.dataSource = self
        
        addRefreshControlTo(tableView: tbvEmergencyContacts)
        
    }
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        EmergencyNumberList.removeAll()
        doGetEmergencyNumber()
        refreshControl.endRefreshing()
    }
    
    func doGetEmergencyNumber(){
        print("get emergency contact")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getEmergencyNumber":"getEmergencyNumber",
                      "society_id":doGetLocalDataUser().society_id!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.emergencyNumberController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(EmergencyResponse.self, from:json!)
                    if response.status == "200" {
                      self.EmergencyNumberList.append(contentsOf: response.emergencyNumber)
                        self.tbvEmergencyContacts.reloadData()
                    }else {
                        
                        self.toast(message: response.message, type: 1)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
}

extension EmergencyContactsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EmergencyNumberList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvEmergencyContacts.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as!  EmergencyContactCell
        cell.lblOccupation.text = EmergencyNumberList[indexPath.row].designation
        cell.lblPersonName.text = EmergencyNumberList[indexPath.row].name
     
        if EmergencyNumberList[indexPath.row].image == "https://www.fincasys.com/apAdmin/img/"{
            
            cell.imgProfile.image = UIImage(named: "user_default") 
            
        }else{
            Utils.setImageFromUrl(imageView: cell.imgProfile, urlString: EmergencyNumberList[indexPath.row].image)
            
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let phone_number = EmergencyNumberList[indexPath.row].mobile!
        print(phone_number)
        if let phoneCallURL = URL(string: "telprompt://\(phone_number)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    application.openURL(phoneCallURL as URL)
                    
                }
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
