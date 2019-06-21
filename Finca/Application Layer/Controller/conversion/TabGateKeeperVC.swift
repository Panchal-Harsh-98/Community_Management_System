//
//  TabGateKeeperVC.swift
//  Finca
//
//  Created by anjali on 19/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip


struct ResponseGatekeeper : Codable{
    let status:String!//  "status" : "200",
    let message:String!//  "message" : "Gatekeeper Infromation Get success."
    let gatekeeper:[GatekeeperModel]!
  
}

struct GatekeeperModel : Codable {
   let chat_status:String!// "chat_status" : "0",
   let emp_id:String!// "emp_id" : "127",
  let emp_profile:String!//  "emp_profile" : "http:\/\/www.fincasys.com\/img\/emp\/8401565883_1560445089.png",
  let emp_name:String!//  "emp_name" : "Ajit Guard"
}
class TabGateKeeperVC: BaseVC {
    @IBOutlet weak var cvData: UICollectionView!
    
    let itemCell = "GateKeeperCell"
    
      var gatekeepers = [GatekeeperModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        doGetSecurity()
    }
    
    func doGetSecurity() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "getekeeperList":"getekeeperList",
                      "society_id":doGetLocalDataUser().society_id!,
                      "user_id":doGetLocalDataUser().user_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: NetworkAPI.chatListController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseGatekeeper.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.gatekeepers.append(contentsOf: response.gatekeeper)
                        self.cvData.reloadData()
                     }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
  
    @objc func onClickOnCall(sender:UIButton) {
        
    //    let index = sender.tag
        
        //print("clcicl" , index)
        
     //   let phone = employees[index].emp_mobile!
        let phone = "198"
        
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

}
extension TabGateKeeperVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "GateKeeper")
    }
    
}


extension TabGateKeeperVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return  gatekeepers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! GateKeeperCell
            
            Utils.setRoundImage(imageView: cell.ivImage)
        Utils.setImageFromUrl(imageView: cell.ivImage, urlString: gatekeepers[indexPath.row].emp_profile)
        
        cell.lbName.text = gatekeepers[indexPath.row].emp_name
        cell.lbUnreadMessage.text = "Unread Messages: " +  gatekeepers[indexPath.row].chat_status
        
        cell.bCall.tag = indexPath.row
        cell.bCall.addTarget(self, action: #selector(onClickOnCall(sender:)), for: .touchUpInside)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth, height: 80)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        vc.isGateKeeper =  true
        vc.userid =  gatekeepers[indexPath.row].emp_id
          vc.name =  gatekeepers[indexPath.row].emp_name
        vc.profile =  gatekeepers[indexPath.row].emp_profile
        
        self.navigationController?.pushViewController(vc, animated: true)
       }
  
    
    
    
}
