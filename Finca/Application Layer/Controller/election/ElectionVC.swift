//
//  ElectionVC.swift
//  Finca
//
//  Created by harsh panchal on 26/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ElectionVC: BaseVC {
    
    @IBOutlet weak var tbvElection: UITableView!
    let itemCell = "ElectionCell"
    var election_list = [ElectionModel]()
    var viewWillAppearFlag = false
    
    @IBOutlet weak var bMenu: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvElection.register(nib, forCellReuseIdentifier: itemCell)
        tbvElection.delegate = self
        tbvElection.dataSource = self
        doGetElectionData()
        doInintialRevelController(bMenu: bMenu)
    }
    override func viewWillAppear(_ animated: Bool) {
        if viewWillAppearFlag == true{
            election_list.removeAll()
            doGetElectionData()
        }
    }
    
    func doGetElectionData(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getElectionList":"getElectionList",
                      "society_id":doGetLocalDataUser().society_id!,
                      "userType":doGetLocalDataUser().user_type!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(ElectionResponse.self, from:json!)
                    if response.status == "200" {
                      self.election_list.append(contentsOf: response.election)
                      self.tbvElection.reloadData()
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
extension ElectionVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return election_list.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvElection.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ElectionCell
        switch election_list[indexPath.row].electionStatus {
        case "3":
            cell.lblstatus.text = "Voting Close"
            cell.lblstatus.textColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            break;
        case "0":
            cell.lblstatus.text = "Nomination Open"
            cell.lblstatus.textColor = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)
            break;
        case "1":
            cell.lblstatus.text = "Voting Open"
            cell.lblstatus.textColor = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)
            break;
        case "2":
            cell.lblstatus.text = "Result publish"
            cell.lblstatus.textColor = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)
            break;
        default:
            break;
        }
        
        cell.lblElectionName.text = election_list[indexPath.row].electionName
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idElectionDetailsVC")as! ElectionDetailsVC
        nextVC.electionDetails = election_list[indexPath.row]
        viewWillAppearFlag = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
