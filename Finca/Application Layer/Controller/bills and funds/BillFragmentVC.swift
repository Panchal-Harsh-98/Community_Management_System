//
//  BillFragmentVC.swift
//  Finca
//
//  Created by harsh panchal on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class BillFragmentVC: BaseVC{
 
    
    @IBOutlet weak var tbvBill: UITableView!
    let itemCell = "FundCell"
    var Bill_list = [Bill_Model]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvBill.register(nib, forCellReuseIdentifier: itemCell)
        tbvBill.delegate = self
        tbvBill.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData(_:)), name: Notification.Name(rawValue:StringConstants.NOTI_UPDATE_CONTENT), object: nil)
        
    }
    @objc func refreshData(_ notification: Notification) {

        let month =  notification.userInfo?["month"] as! String
        let year = notification.userInfo?["year"]!as! String
        Bill_list.removeAll()
        doCallBillApi(month: month,year: year)
        print(month)
        print(year)
    }
    
    func doCallBillApi(month:String,year:String) {
        showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getBill":"getBill",
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "month":month,
                      "year":year]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.BILL_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                        let response = try JSONDecoder().decode(BillResponse.self, from:json!)
                        if response.status == "200" {
                            self.Bill_list.append(contentsOf: response.bill)
                            self.tbvBill.reloadData()
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
extension BillFragmentVC : IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "BILL"
    }
}
extension BillFragmentVC : UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Bill_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvBill.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! FundCell
        cell.lblDate.text = Bill_list[indexPath.row].billGenrateDate
        cell.lblTitle.text = Bill_list[indexPath.row].billName
        cell.lblExpense.text = Bill_list[indexPath.row].billAmount
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
