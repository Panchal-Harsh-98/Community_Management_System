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
    var itemCell = "PollingCell"
    var pollingQuesList = [PollingModel]()
    var flagViewRefresh = false
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doGetPollingQuestions()
        addRefreshControlTo(tableView: tbvPoll)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvPoll.register(nib, forCellReuseIdentifier: itemCell)
        tbvPoll.delegate = self
        tbvPoll.dataSource = self
    }
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        pollingQuesList.removeAll()
        doGetPollingQuestions()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if flagViewRefresh{
            pollingQuesList.removeAll()
            doGetPollingQuestions()
        }
    }
    
    func doGetPollingQuestions(){
        print("delete success")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getVotingList":"getVotingList",
                      "society_id":doGetLocalDataUser().society_id!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(PollingResponse.self, from:json!)
                    if response.status == "200" {
                        self.pollingQuesList.append(contentsOf: response.voting)
                        self.tbvPoll.reloadData()
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

extension PollingVc : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pollingQuesList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvPoll.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! PollingCell
        cell.lblPollingQues.text = pollingQuesList[indexPath.row].votingQuestion
        switch (pollingQuesList[indexPath.row].votingStatus) {
        case "0":
            cell.lblPollingStatus.text = "Open"
            cell.lblPollingStatus.textColor = #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)
            break;
        case "1":
            cell.lblPollingStatus.text = "Close"
            cell.lblPollingStatus.textColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            break
        default:
            break;
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idPollingDetailsVC")as! PollingDetailsVC
        nextVC.pollingDetails = pollingQuesList[indexPath.row]
        flagViewRefresh = true
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
