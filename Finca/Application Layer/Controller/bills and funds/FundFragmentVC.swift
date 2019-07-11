//
//  FundFragmentVC.swift
//  Finca
//
//  Created by harsh panchal on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class FundFragmentVC: BaseVC {
    
    @IBOutlet weak var tbvFunds: UITableView!
    let itemCell = "FundCell"
    var maintainance_list = [Maintenance_Model]()
    var month: String!
    var year : String!
    var due  = 0.0
    var paid = 0.0
    @IBOutlet weak var lblDueAmt: UILabel!
    @IBOutlet weak var lblPaidAmt: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addRefreshControlTo(tableView: tbvFunds)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvFunds.register(nib, forCellReuseIdentifier: itemCell)
        tbvFunds.dataSource = self
        tbvFunds.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData(_:)), name: Notification.Name(rawValue:StringConstants.NOTI_UPDATE_CONTENT), object: nil)
    }
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        maintainance_list.removeAll()
        doCallmaintainanceApi(month: month, year: year)
        due = 0
        paid = 0
        refreshControl.endRefreshing()
    }
    
    @objc func refreshData(_ notification: Notification) {
        
        month =  notification.userInfo?["month"] as! String
        year = notification.userInfo?["year"]!as! String
        maintainance_list.removeAll()
        doCallmaintainanceApi(month: month,year: year)
        print(month)
        print(year)
    }
    

    func doCallmaintainanceApi(month:String,year:String) {
        showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getMaintenance":"getMaintenance",
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "month":month,
                      "year":year]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.MAINTAINANCE_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(MaintainanceResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.maintainance_list.append(contentsOf: response.maintenance)
                        self.setDueAndPaidLabels()
                        self.tbvFunds.reloadData()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func setDueAndPaidLabels(){
        for item in maintainance_list{
            let strAmount = Double(item.maintenceAmount!)!
            print(strAmount)
            
            if item.receiveMaintenanceStatus == "0"{

                self.due = self.due + strAmount

            }else{
                self.paid = self.paid + strAmount
            }
        }
        
        self.lblPaidAmt.text = "Paid : "+StringConstants.RUPEE_SYMBOL+"\(String(describing: paid))"
        self.lblPaidAmt.textColor = ColorConstant.green600
        self.lblDueAmt.textColor = ColorConstant.red500
        self.lblDueAmt.text = "Due : "+StringConstants.RUPEE_SYMBOL+"\(String(describing: due))"
        
    }
}
extension FundFragmentVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "Funds"
    }
    
}
extension FundFragmentVC : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maintainance_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvFunds.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! FundCell
        cell.selectionStyle = .none
        cell.lblTitle.text = maintainance_list[indexPath.row].maintenanceName
        cell.lblDate.text = maintainance_list[indexPath.row].endDate
        cell.lblExpense.text = StringConstants.RUPEE_SYMBOL+" "+maintainance_list[indexPath.row].maintenceAmount
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "idBillAndFundDetailsVC")as! BillAndFundDetailsVC
        nextVc.maintainanceList = self.maintainance_list[indexPath.row]
        self.navigationController?.pushViewController(nextVc, animated: true)
    }
}
