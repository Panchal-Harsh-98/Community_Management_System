//
//  BalanceSheetVc.swift
//  Finca
//
//  Created by harsh panchal on 08/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class BalanceSheetVc: BaseVC {
    
    
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    
    @IBOutlet weak var lblBalanceSheetTotal: UILabel!
    
    @IBOutlet weak var tbvbalanceSheet: UITableView!
    
    var balanceList = [BalancesheetModel]()
    
    let itemCell = "BalanceSheetCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doGetBalanceSheetData()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvbalanceSheet.register(nib, forCellReuseIdentifier: itemCell)
        tbvbalanceSheet.delegate = self
        tbvbalanceSheet.dataSource = self
        addRefreshControlTo(tableView: tbvbalanceSheet)
        doInintialRevelController(bMenu: bMenu)
    }
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        balanceList.removeAll()
        doGetBalanceSheetData()
        refreshControl.endRefreshing()
    }
    
    func doGetBalanceSheetData(){
        print("get emergency contact")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "balancesheet_master":"balancesheet_master",
                      "society_id":doGetLocalDataUser().society_id!]
        
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.balanceSheetController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(BalanceSheetResponse.self, from:json!)
                    if response.status == "200" {
                        self.balanceList.append(contentsOf: response.balancesheet)
                        self.lblBalanceSheetTotal.text = StringConstants.RUPEE_SYMBOL + " " + response.cashOnHand
                        self.tbvbalanceSheet.reloadData()
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
    
    override func viewWillAppear(_ animated: Bool) {
        loadNoti()
    }
    func loadNoti() {
        
        if getChatCount() !=  "0" {
            self.viewChatCount.isHidden =  false
            self.lbChatCount.text = getChatCount()
            
        } else {
            self.viewChatCount.isHidden =  true
        }
        if getNotiCount() !=  "0" {
            self.viewNotiCount.isHidden =  false
            self.lbNotiCount.text = getNotiCount()
            
        } else {
            self.viewNotiCount.isHidden =  true
        }
    }
    
    @IBAction func onClickNotification(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension BalanceSheetVc : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return balanceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvbalanceSheet.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! BalanceSheetCell
        cell.lblBalanceAmount.text =  StringConstants.RUPEE_SYMBOL + " " +  balanceList[indexPath.row].currentBalance
        cell.lblSheetName.text = balanceList[indexPath.row].balancesheetName
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
