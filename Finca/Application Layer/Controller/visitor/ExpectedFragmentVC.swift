//
//  ExpectedFragmentVC.swift
//  Finca
//
//  Created by harsh panchal on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ExpectedFragmentVC: BaseVC {
    var exp_visitor_list = [Exp_Visitor_Model]()
    var itemCell = "ExpectedVisitorCell"
    @IBOutlet weak var tbvExpectedVisitor: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        doGetExpectedVisitorList()
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvExpectedVisitor.register(nib, forCellReuseIdentifier: itemCell)
        tbvExpectedVisitor.delegate = self
        tbvExpectedVisitor.dataSource = self
        
    }
    @IBAction func btnAddExpectedVisitor(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(StringConstants.KEY_NOTIFICATION_VISITOR), object: nil)
    }
    func doGetExpectedVisitorList()  {
        showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getExVisitorList":"getExVisitorList",
                      "society_id":doGetLocalDataUser().society_id!,
                      "user_id":doGetLocalDataUser().user_id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.VISITOR_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(ExpectedVisitorResponse.self, from:json!)
                    if response.status == "200" {
                        self.exp_visitor_list.append(contentsOf: response.visitor)
                        self.tbvExpectedVisitor.reloadData()
                        

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
extension ExpectedFragmentVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "EXPECTED"
    }
}
extension ExpectedFragmentVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exp_visitor_list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvExpectedVisitor.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ExpectedVisitorCell
        cell.visitorCount(Count: exp_visitor_list[indexPath.row].vistorNumber)
        cell.visitTime(time: exp_visitor_list[indexPath.row].visitTime)
        cell.lblVisitDate.text = exp_visitor_list[indexPath.row].visitDate
        cell.lblVisitorName.text = exp_visitor_list[indexPath.row].visitorName
        Utils.setImageFromUrl(imageView: cell.imgVisitorProfile, urlString: exp_visitor_list[indexPath.row].visitorProfile)
        switch exp_visitor_list[indexPath.row].visitorStatus {
        case "0":
            cell.lblStatus.text = " Arrived "
            cell.lblStatus.backgroundColor =  #colorLiteral(red: 1, green: 0.9215686275, blue: 0.231372549, alpha: 1)
            break;
        case "1":
            cell.lblStatus.text = " Entered.. "
            cell.lblStatus.backgroundColor =  #colorLiteral(red: 1, green: 0.7568627451, blue: 0.02745098039, alpha: 1)
            
            break;
        case "2":
            cell.lblStatus.text = " Exited.. "
            cell.lblStatus.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
            cell.lblExitTime.isHidden = false
            cell.lblExitDate.isHidden = false
            cell.visitorExitDate(extDate: exp_visitor_list[indexPath.row].exitDate)
            cell.visitorExitTime(extTime: exp_visitor_list[indexPath.row].exitTime)
            
            break;
        
        default:
            break
        }
        return cell
    }
}
//let destiController = self.storyboard?.instantiateViewController(withIdentifier: "idAddCategoryVC") as! AddCategoryVC
//destiController.CategoryType = "0"
//let popupVC = PopupViewController(contentController: destiController, popupWidth: screenwidth - 20, popupHeight: 150)
//popupVC.backgroundAlpha = 0.5
//popupVC.backgroundColor = .black
//popupVC.shadowEnabled = true
//popupVC.canTapOutsideToDismiss = true
//// show it by call present(_ , animated:) method from a current UIViewController
//present(popupVC, animated: true)
