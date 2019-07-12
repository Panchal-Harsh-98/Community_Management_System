//
//  BillFragmentVC.swift
//  Finca
//
//  Created by harsh panchal on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EzPopup


class BillFragmentVC: BaseVC{
    
    
    @IBOutlet weak var tbvBill: UITableView!
    let itemCell = "FundCell"
    var billList = [Bill_Model]()
    var month : String!
    var year : String!
    var due = 0.0
    var paid = 0.0
    @IBOutlet weak var lblPaidAmt: UILabel!
    @IBOutlet weak var lblDueAmt: UILabel!
    
    let date = Date()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let date = Date()
        let calendar = Calendar.current
        
        year = String(calendar.component(.year, from: date))
        month = "All"
        
        addRefreshControlTo(tableView: tbvBill)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvBill.register(nib, forCellReuseIdentifier: itemCell)
        tbvBill.delegate = self
        tbvBill.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshData(_:)), name: Notification.Name(rawValue:StringConstants.NOTI_UPDATE_CONTENT), object: nil)
        
        
    }
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        billList.removeAll()
        doCallBillApi(month: month, year: year)
        paid = 0.0
        due = 0.0
        refreshControl.endRefreshing()
    }
    
    @objc func refreshData(_ notification: Notification) {
        
        let month =  notification.userInfo?["month"] as! String
        let year = notification.userInfo?["year"]!as! String
        billList.removeAll()
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
                        self.billList.append(contentsOf: response.bill)
                        self.tbvBill.reloadData()
                        self.setDueAndPaidLabels()
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
        for item in billList{
            let strAmount = Double(item.billAmount!)!
            print(strAmount)
            
            if item.receiveBillStatus == "0"{
                
                self.due = self.due + strAmount
                
            }else if item.receiveBillStatus == "1"{
                
                self.paid = self.paid + strAmount
                
            }else if item.receiveBillStatus == "2"{
                
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
extension BillFragmentVC : IndicatorInfoProvider{
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "BILL"
    }
}
extension BillFragmentVC : UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvBill.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! FundCell
        cell.lblDate.text = billList[indexPath.row].billGenrateDate
        cell.lblTitle.text = billList[indexPath.row].billName
        
        if billList[indexPath.row].receiveBillStatus == "0"{
            cell.lblExpense.textColor = ColorConstant.red400
            cell.lblExpense.text = "Add Bill Units"
            cell.lblExpense.minimumScaleFactor = 0.5
            cell.lblExpense.adjustsFontSizeToFitWidth = true;
        }else if billList[indexPath.row].receiveBillStatus == "1"{
            cell.lblExpense.textColor = ColorConstant.yellow400
            cell.lblExpense.text = "pending"
        }else if billList[indexPath.row].receiveBillStatus == "2" {
            cell.lblExpense.textColor = ColorConstant.red400
            cell.lblExpense.text = StringConstants.RUPEE_SYMBOL + billList[indexPath.row].billAmount
        }else{
            cell.lblExpense.textColor = ColorConstant.yellow400
            cell.lblExpense.text = "Paid"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if billList[indexPath.row].receiveBillStatus == "0"{
            
            let screenwidth = UIScreen.main.bounds.width
            let screenheight = UIScreen.main.bounds.height
            let destiController = self.storyboard?.instantiateViewController(withIdentifier: "idAddNoOfUnitDialog") as! AddNoOfUnitDialog
            
            destiController.billDetail = billList[indexPath.row]
            
            let popupVC = PopupViewController(contentController: destiController, popupWidth: screenwidth - 50, popupHeight: screenheight-300)
            popupVC.backgroundAlpha = 0.5
            popupVC.backgroundColor = .black
            popupVC.shadowEnabled = true
            popupVC.canTapOutsideToDismiss = true
            present(popupVC, animated: true)
            
        }
        else if billList[indexPath.row].receiveBillStatus == "2"{
            let nextVc = self.storyboard?.instantiateViewController(withIdentifier: "idBillAndFundDetailsVC") as! BillAndFundDetailsVC
            nextVc.isBillList = true
            nextVc.billList = billList[indexPath.row]
            self.navigationController?.pushViewController(nextVc, animated: true)
        }
    }
    
}
