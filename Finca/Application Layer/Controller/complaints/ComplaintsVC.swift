//
//  ComplaintsVC.swift
//  Finca
//
//  Created by harsh panchal on 01/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class ComplaintsVC: BaseVC {

    @IBOutlet weak var FloatingButtonView: UIView!
    @IBOutlet weak var bMenu: UIButton!
    var flagViewVerification = false
    @IBOutlet weak var tbvComplain: UITableView!
    let itemCell = "ComplainCell"
    var ComplainList = [ComplainModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        doCallGetComplainApi()
        FloatingButtonView.layer.shadowRadius = 6
        FloatingButtonView.layer.shadowOffset = CGSize.zero
        FloatingButtonView.layer.shadowOpacity = 0.7
        FloatingButtonView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        FloatingButtonView.layer.masksToBounds = false
        
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvComplain.register(nib, forCellReuseIdentifier: itemCell)
        tbvComplain.delegate = self
        tbvComplain.dataSource = self
        addRefreshControlTo(tableView: tbvComplain)
        
    }
    
    
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    func loadNoti() {
        let vc = BaseVC()
        if vc.getChatCount() !=  "0" {
            self.viewChatCount.isHidden =  false
            self.lbChatCount.text = vc.getChatCount()
            
        } else {
            self.viewChatCount.isHidden =  true
        }
        if vc.getNotiCount() !=  "0" {
            self.viewNotiCount.isHidden =  false
            self.lbNotiCount.text = vc.getNotiCount()
            
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
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        ComplainList.removeAll()
        doCallGetComplainApi()
        refreshControl.endRefreshing()
    }
    
    @IBAction func btnAddComplaint(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idAddComplaintsVC")as! AddComplaintsVC
        self.flagViewVerification = true
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if flagViewVerification == true{
            ComplainList.removeAll()
            doCallGetComplainApi()
        }
    }
    
    func doCallGetComplainApi(){
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getComplain":"getComplain",
                      "society_id":doGetLocalDataUser().society_id!,
                      "unit_id":doGetLocalDataUser().unit_id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(ComplainResponse.self, from:json!)
                    if response.status == "200" {
                        self.ComplainList.append(contentsOf: response.complain)
                        self.tbvComplain.reloadData()
                    }else {
                        self.tbvComplain.reloadData()
                        self.toast(message: response.message, type: 1)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    @objc func btnDeleteTapped(sender:UIButton){
        let index = sender.tag
        let alert = UIAlertController(title: "", message:"Are you sure you want to delete", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "yes", style: .destructive, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.onClickDelete(index: index)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    func onClickDelete(index:Int) {
        print("delete success")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "deleteComplain":"deleteComplain",
                      "society_id":doGetLocalDataUser().society_id!,
                      "complain_id":ComplainList[index].complainID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.complainController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                       self.ComplainList.removeAll()
                        self.doCallGetComplainApi()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    @objc func btnEditTapped(sender:UIButton){
        let index = sender.tag
        let alert = UIAlertController(title: "", message:"Are you sure you want to edit", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            
            alert.dismiss(animated: true, completion: nil)
            self.onClickEdit(index: index)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
    func onClickEdit(index : Int){
        print("edit")
        let editComplain = self.storyboard?.instantiateViewController(withIdentifier: "idAddComplaintsVC")as! AddComplaintsVC
        editComplain.flagForEditing = true
        editComplain.complainDetails = ComplainList[index]
        self.flagViewVerification = true
        self.navigationController?.pushViewController(editComplain, animated: true)
    }
}
extension ComplaintsVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ComplainList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvComplain.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ComplainCell
        cell.lblCmpTitle.text = ComplainList[indexPath.row].compalainTitle
        cell.lblCmpDesc.text = ComplainList[indexPath.row].complainDescription
        switch (ComplainList[indexPath.row].complainStatus) {
        case "0":
            cell.lblCmpStatus.text = "Open"
            cell.viewBtnEdit.isHidden = true
            break;
        case "1":
            cell.lblCmpStatus.text = "Close"
            cell.viewBtnEdit.isHidden = false
            break;
        case "2":
            cell.lblCmpStatus.text = "Re-Open"
            cell.viewBtnEdit.isHidden = true
            break;
        case "3":
            cell.lblCmpStatus.text = "InProgress.."
            cell.viewBtnEdit.isHidden = true
            break;
            
        default:
            break;
        }
        cell.selectionStyle = .none
        cell.lblCmpDate.text = ComplainList[indexPath.row].complainDate
        cell.lblCmpAdminMsg.text = ComplainList[indexPath.row].complainReviewMsg
        cell.editBtn.tag = indexPath.row
        cell.deleteBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(btnEditTapped(sender:)), for: .touchUpInside)
        cell.deleteBtn.addTarget(self, action: #selector(btnDeleteTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
}


//if (sat.equalsIgnoreCase("0")){
//    textView.setText("Open");
//    imageView.setVisibility(View.GONE);
//
//
//}else if (sat.equalsIgnoreCase("1"))
//{
//    textView.setText("Close");
//    imageView.setVisibility(View.VISIBLE);
//
//}else if (sat.equalsIgnoreCase("2"))
//{
//    textView.setText("Re-Open");
//    imageView.setVisibility(View.GONE);
//
//}else if (sat.equalsIgnoreCase("3"))
//{
//    textView.setText("Inprogress..");
//    imageView.setVisibility(View.GONE);
//
//}
