//
//  NotificationVC.swift
//  Finca
//
//  Created by anjali on 06/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit


class NotificationVC: BaseVC {
    @IBOutlet weak var cvData: UICollectionView!
    let itemCell = "NotificationCell"
      var notifications  =  [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
        // Do any additional setup after loading the view.
        doGetData()
    }
    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    func doGetData() {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getNotification":"getNotification",
                      "user_id" :doGetLocalDataUser().user_id!,
                      "read" : "1",
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.user_notification_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseNotification.self, from:json!)
                    
                    
                    if response.status == "200" {
                        if self.notifications.count > 0 {
                            self.notifications.removeAll()
                             self.cvData.reloadData()
                        }
                        self.notifications.append(contentsOf: response.notification)
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
    @objc func onclickDelet(sender:UIButton) {
        print("delet", sender.tag)
        
        doDelettNotification(user_notification_id: notifications[sender.tag].user_notification_id)
    }
    func doDelettNotification(user_notification_id:String) {
        
        
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "DeleteUserNotification":"DeleteUserNotification",
                      "user_notification_id" :user_notification_id]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.user_notification_controller, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseNotification.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                     self.doGetData()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
        
    }
}
extension  NotificationVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! NotificationCell
        cell.lbTitle.text = notifications[indexPath.row].notification_title
        cell.lbDesc.text = notifications[indexPath.row].notification_desc
        cell.lbDate.text = notifications[indexPath.row].notification_date
        cell.bDelete.tag = indexPath.row
        cell.bDelete.addTarget(self, action: #selector(onclickDelet(sender:)), for: .touchUpInside)
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return notifications.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
    
}
