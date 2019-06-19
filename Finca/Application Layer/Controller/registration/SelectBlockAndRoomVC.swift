//
//  SelectBlockAndRoomVC.swift
//  Finca
//
//  Created by anjali on 01/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit


struct BlockResponse : Codable{
    let message:String!// "message" : "Get Block success.",
    let status:String! //"status" : "200"
    let block : [BlockModel]!
}

struct BlockModel : Codable{
   let block_name:String! //"block_name" : "A",
   let block_id:String! //"block_id" : "65",
   let society_id:String!// "society_id" : "17",
   let block_status:String!// "block_status" : "0"
}


struct FloorResponse : Codable{
    let message:String!// "message" : "Get Block success.",
    let status:String! //"status" : "200"
    let floors:[FloorModel]!
}

struct FloorModel:Codable {
    let floor_name:String! //"floor_name" : "1 Floor",
   let floor_status:String! // "floor_status" : "0",
    let floor_id:String! //"floor_id" : "284",
    let block_id:String! //"block_id" : "65",
    let society_id:String! //"society_id" : "17"
    let units:[UnitModel]!
}
struct UnitModel : Codable {
   let unit_type:String! //"unit_type" : null,
   let society_id:String! //"/society_id" : "17",
   let floor_id:String!// "floor_id" : "284",
   let unit_status:String! //"unit_status" : "1",
  let unit_name:String!  //"unit_name" : "101",
   let unit_id:String! //"unit_id" : "1266"
}

class SelectBlockAndRoomVC: BaseVC {
    @IBOutlet weak var cvBlock: UICollectionView!
    var society_id:String!
   
    @IBOutlet weak var viewFloors: UIView!
    @IBOutlet weak var cvFloors: UICollectionView!
    var blocks = [BlockModel]()
    var floors = [FloorModel]()
    
     let itemCell = "SelectBlockCell"
    let itemCellFloor = "FloorSelectionCell"
    
    var unitModel:UnitModel!
    var blockModel:BlockModel!
    var ownedDataSelectVC:OwnedDataSelectVC!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cvBlock.delegate = self
        cvBlock.dataSource = self
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvBlock.register(inb, forCellWithReuseIdentifier: itemCell)
        
        cvFloors.delegate = self
        cvFloors.dataSource = self
        let inbFloor = UINib(nibName: itemCellFloor, bundle: nil)
        cvFloors.register(inbFloor, forCellWithReuseIdentifier: itemCellFloor)
        viewFloors.isHidden = true
        doGetBlock()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clickFloor(_:)),
                                               name: NSNotification.Name(rawValue: "clickFloor"),
                                               object: nil)
        
    }
    
    @objc func clickFloor(_ notification: NSNotification) {
      
        let data =  notification.userInfo?["data"] as? UnitModel
        
        if data?.unit_status == "0" {
            ownedDataSelectVC.unitModel = data!
            ownedDataSelectVC.blockModel = blockModel!
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    func doGetBlock() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "getBlocks":"getBlocks",
                      "society_id":society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(BlockResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.blocks.append(contentsOf: response.block)
                        self.cvBlock.reloadData()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func doGetFlorUnit(block_id:String) {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "getFloorandUnit":"getFloorandUnit",
                      "society_id":society_id!,
                      "block_id":block_id]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: ServiceNameConstants.blockList, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(FloorResponse.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.viewFloors.isHidden = false
                        self.cvBlock.isHidden = true
                        self.floors.append(contentsOf: response.floors)
                        self.cvFloors.reloadData()
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                    
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    
    @IBAction func onClickBack(_ sender: Any) {
        doGetBlock()
      //  dismiss(animated: true, completion: nil)
    }
    
}
extension SelectBlockAndRoomVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvFloors {
            return floors.count
        }
        
        return blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvFloors {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellFloor, for: indexPath) as! FloorSelectionCell
            
            cell.lbTitle.text = floors[indexPath.row].floor_name
            cell.doSetData(units: floors[indexPath.row].units, isMember: false)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! SelectBlockCell
        
        cell.lbTitle.text = blocks[indexPath.row].block_name
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvFloors {
            let yourWidth = collectionView.bounds.width
            return CGSize(width: yourWidth-4, height: 100)
        }
        let yourWidth = collectionView.bounds.width  / 2
        return CGSize(width: yourWidth-4, height: 100)
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cvBlock {
            
            
            doGetFlorUnit(block_id: blocks[indexPath.row].block_id)
       
            blockModel = blocks[indexPath.row]
        }
      
        
        
        
    }
}
