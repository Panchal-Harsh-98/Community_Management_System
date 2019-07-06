//
//  EventsVC.swift
//  Finca
//
//  Created by anjali on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseEvent : Codable{
    let message:String!//" : "Get event success.",
    let status:String!//" : "200"
    let event:[ModelEvent]!
}

struct ModelEvent : Codable {
    let event_end_date:String!//" : "2019-07-02 02:38 PM",
    let event_id:String!//" : "9",
    let event_description:String!//" : "aaaa1234",
    let event_start_date:String!//" : "2019-07-02 02:38 PM",
    let event_title:String!//" : "Event Test",
    let going_person:String!//" : "1"
    let notes_person:String! //"notes_person" : "noting",
    let numberof_person:String!// "numberof_person" : "5"
}

class EventsVC: BaseVC {
    

    @IBOutlet weak var bMenu: UIButton!
    
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    let itemCell = "EventCell"
    var eventList = [ModelEvent]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        doInintialRevelController(bMenu: bMenu)
        
        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
        doEvent()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func doEvent() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getEventList":"getEventList",
                      "user_id":doGetLocalDataUser().user_id!,
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.userEventController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseEvent.self, from:json!)
                    
                    
                    if response.status == "200" {
                        self.eventList.append(contentsOf: response.event)
                    
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
}


extension  EventsVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! EventCell
      //  cell.lbAttending.text = ""
        
       cell.lbTitle.text = eventList[indexPath.row].event_title
          cell.lbDesc.text = eventList[indexPath.row].event_description
          cell.lbDate.text = eventList[indexPath.row].event_start_date
        
        if eventList[indexPath.row].going_person == "0" {
            cell.lbAttending.text = "Yes"
             cell.lbAttending.textColor = UIColor(named: "green_a700")
        } else {
             cell.lbAttending.text = "NO"
             cell.lbAttending.textColor = UIColor(named: "red_a700")
            
        }
        
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return eventList.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth - 5, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idEventDetailsVC") as! EventDetailsVC
       vc.eventModeL = eventList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
   
    



