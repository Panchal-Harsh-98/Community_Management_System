//
//  ArrivedFragmentVC.swift
//  Finca
//
//  Created by harsh panchal on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class ArrivedFragmentVC:BaseVC {
    var visitor_List = [Visitor_Model]()
    @IBOutlet weak var tbvVisitorList: UITableView!
    var itemCell = "VisitorArrivedCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        doCallVisitorApi()
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvVisitorList.register(nib, forCellReuseIdentifier: itemCell)
        tbvVisitorList.delegate = self
        tbvVisitorList.dataSource = self
        
        addRefreshControlTo(tableView: tbvVisitorList)
    }
    
    override func fetchNewDataOnRefresh() {
        visitor_List.removeAll()
        doCallVisitorApi()
        refreshControl.endRefreshing()
    }
    
    func doCallVisitorApi() {
        showProgress()

        let params = ["key":apiKey(),
                      "getNewVisitorList":"getNewVisitorList",
                      "society_id":doGetLocalDataUser().society_id!,
                      "user_id":doGetLocalDataUser().user_id!]

        print("param" , params)

        let request = AlamofireSingleTon.sharedInstance

        request.requestPost(serviceName: ServiceNameConstants.VISITOR_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()

            if json != nil {

                do {

                    let response = try JSONDecoder().decode(VisitorResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.visitor_List.append(contentsOf: response.visitor)
                        self.tbvVisitorList.reloadData()
                        
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
extension ArrivedFragmentVC : IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return "ARRIVED"
    }
}
extension ArrivedFragmentVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visitor_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvVisitorList.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! VisitorArrivedCell
        Utils.setImageFromUrl(imageView: cell.lblVisitorImage, urlString: visitor_List[indexPath.row].visitorProfile)
        cell.lblVisitorName.text = visitor_List[indexPath.row].visitorName
        cell.lblPaxWithVisitor.text = visitor_List[indexPath.row].vistorNumber
        cell.lblVisitorStatus.text = visitor_List[indexPath.row].visitorStatus
        if visitor_List[indexPath.row].visitorStatus == "1" {
            cell.ViewBtnPanel.isHidden = true
            cell.btnPanelHeightConstraint.constant = 0
        }else{
            cell.ViewBtnPanel.isHidden = false
            cell.btnPanelHeightConstraint.constant = 50
        }
//        if indexPath.row == 1 {
//            cell.ViewBtnPanel.isHidden = true
//            cell.btnPanelHeightConstraint.constant = 0
//        }else{
//            cell.ViewBtnPanel.isHidden = false
//            cell.btnPanelHeightConstraint.constant = 40
//        }
        switch visitor_List[indexPath.row].visitorStatus {
        case "0":
            cell.lblVisitorStatus.text = " Arrived "
            cell.lblVisitorStatus.backgroundColor =  #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
            break;
        case "1":
            cell.lblVisitorStatus.text = " Accepted "
            cell.lblVisitorStatus.backgroundColor =  #colorLiteral(red: 0.2980392157, green: 0.6862745098, blue: 0.3137254902, alpha: 1)

            break;
        case "2":
            cell.lblVisitorStatus.text = " Entered "
            cell.lblVisitorStatus.backgroundColor =  #colorLiteral(red: 1, green: 0.7568627451, blue: 0.02745098039, alpha: 1)

            break;
        case "3":
            cell.lblVisitorStatus.text = " Exited "
            cell.lblVisitorStatus.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)

            break;
        case "4":
            cell.lblVisitorStatus.text = " Rejected "
            cell.lblVisitorStatus.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)

            break;
        case "5":
            cell.lblVisitorStatus.text = " Delete "
           cell.lblVisitorStatus.backgroundColor =  #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)

            break;
        case "6":
            cell.lblVisitorStatus.text = " Hold "
            cell.lblVisitorStatus.backgroundColor =  #colorLiteral(red: 0.5843137255, green: 0.4588235294, blue: 0.8039215686, alpha: 1)

            break;
        default:
            break
        }
        return cell
        
//        if (exVisitorResponce.getVisitor().get(i).getVisitorStatus().equalsIgnoreCase("0")) {
//            h.tv_visitor_status.setText("Arrived");
//            h.tv_visitor_status.setBackgroundColor(ContextCompat.getColor(ctx,R.color.Arrived));
//        } else if (exVisitorResponce.getVisitor().get(i).getVisitorStatus().equalsIgnoreCase("1")) {
//            h.tv_visitor_status.setText("Accepted");
//            h.tv_visitor_status.setBackgroundColor(ContextCompat.getColor(ctx, R.color.Accepted));
//        } else if (exVisitorResponce.getVisitor().get(i).getVisitorStatus().equalsIgnoreCase("2")) {
//            h.tv_visitor_status.setText("Entered");
//            h.tv_visitor_status.setBackgroundColor(ContextCompat.getColor(ctx, R.color.Entered));
//        } else if (exVisitorResponce.getVisitor().get(i).getVisitorStatus().equalsIgnoreCase("3")) {
//            h.tv_visitor_status.setText("Exited");
//            h.tv_visitor_status.setBackgroundColor(ContextCompat.getColor(ctx, R.color.Exited));
//        } else if (exVisitorResponce.getVisitor().get(i).getVisitorStatus().equalsIgnoreCase("4")) {
//            h.tv_visitor_status.setText("Rejected");
//            h.tv_visitor_status.setBackgroundColor(ContextCompat.getColor(ctx, R.color.rejected));
//        } else if (exVisitorResponce.getVisitor().get(i).getVisitorStatus().equalsIgnoreCase("5")) {
//            h.tv_visitor_status.setText("Delete");
//            h.tv_visitor_status.setBackgroundColor(ContextCompat.getColor(ctx,R.color.Delete));
//        } else if (exVisitorResponce.getVisitor().get(i).getVisitorStatus().equalsIgnoreCase("6")) {
//            h.tv_visitor_status.setText("Hold");
//            h.tv_visitor_status.setBackgroundColor(ContextCompat.getColor(ctx, R.color.Hold));
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
