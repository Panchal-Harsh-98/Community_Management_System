//
//  MemberVC.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//
import UIKit
struct ResponseMember : Codable {
    
    var population:Int! // "population" : 1,
    var message:String!  //"message" : "Get Member success.",
    var status:String! //"status" : "200"
    var block : [BlockModelMember]!
}
struct BlockModelMember : Codable {
    var block_status:String! //"block_status" : "0",
    var block_name:String!// "block_name" : "A",
    var block_id:String! //"block_id" : "126",
    var society_id:String!  //"society_id" : "48"
    var isSelect:Bool!  //"society_id" : "48"
    
    var  floors : [FloorModelMember]!
    
}
struct FloorModelMember : Codable {
    var floor_name:String! //"floor_name" : "1 Floor",
    var society_id:String! //"society_id" : "48",
    var floor_status:String! //"floor_status" : "0",
    var block_id:String!// "block_id" : "126",
    var floor_id:String!  //"floor_id" : "518"
    var  units : [UnitModelMember]!
    
}
struct UnitModelMember : Codable {
    var user_unit_id:String! //"user_unit_id" : null,
    var user_mobile:String! //"user_mobile" : null,
    var user_email:String! //"user_email" : null,
    var user_type:String! //"user_type" : null,
    var user_floor_id:String! //"user_floor_id" : null,
    var unit_name:String! //"unit_name" : "101",
    var user_last_name:String! //"user_last_name" : null,
    var user_status:String! //"user_status" : null,
    var user_block_id:String! //"user_block_id" : null,
    var user_id_proof:String! //"user_id_proof" : null,
    var user_full_name:String! //"user_full_name" : null,
    var floor_id:String! //"floor_id" : "518",
    var chat_status:String! //"chat_status" : "0",
    var unit_status:String!  //"unit_status" : "0",
    var unit_type:String!  //"unit_type" : null,
    var unit_id:String! //"unit_id" : "2118",
    var user_profile_pic:String! //"user_profile_pic" : ".com\/img\/users\/
    var society_id:String! //"society_id" : null,
    var family_count:String! //"family_count" : "1",
    var user_id:String!//"user_id" : null,
    var user_first_name:String! //"user_first_name" : null
    var myParking:[MyParkingModelMember]!
    
}
struct MyParkingModelMember : Codable {
    var sociaty_id:String! //"sociaty_id" : null,
    var parking_name:String! // "parking_name" : "C-1",
    var unit_id:String! //"unit_id" : "2119",
    var society_parking_id:String!  //"society_parking_id" : "49",
    var vehicle_no:String! // "vehicle_no" : "Ground1-C-1 - gj 01 hu 420",
    var parking_id:String! // "parking_id" : "1645",
    var block_id:String! // "block_id" : "126",
    var parking_type:String!// "parking_type" : "0",
    var floor_id:String!  //"floor_id" : "518",
    var parking_status:String! //"parking_status" : "1"
    
}
class MemberVC: BaseVC {
    @IBOutlet weak var cvBlock: UICollectionView!
    @IBOutlet weak var cvUnits: UICollectionView!
    @IBOutlet weak var lbBlock: UILabel!
    @IBOutlet weak var lbPopulation: UILabel!
    @IBOutlet weak var bMenu: UIButton!
    
    let itemCell = "BlockMemberCell"
    let itemCellFloor = "FloorSelectionCell"
    
    var blocks = [BlockModelMember]()
    var  floors = [FloorModelMember]()
    var isFirstTimeload = true
    
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cvBlock.delegate = self
        cvBlock.dataSource = self
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvBlock.register(inb, forCellWithReuseIdentifier: itemCell)
        
        cvUnits.delegate = self
        cvUnits.dataSource = self
        let inbFloor = UINib(nibName: itemCellFloor, bundle: nil)
        cvUnits.register(inbFloor, forCellWithReuseIdentifier: itemCellFloor)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clickFloor(_:)),
                                               name: NSNotification.Name(rawValue: "clickFloor"),
                                               object: nil)
        
        doGetSocietes()
        
        doInintialRevelController(bMenu: bMenu)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @IBAction func onClickNotification(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idNotificationVC") as! NotificationVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func onClickChat(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func clickFloor(_ notification: NSNotification) {
        
        let data =  notification.userInfo?["data"] as? UnitModelMember
        
        if data?.user_id != doGetLocalDataUser().user_id {
            if data?.unit_status == "1" || data?.unit_status == "3" || data?.unit_status == "5" {
                let vc = storyboard?.instantiateViewController(withIdentifier: "idMemberDetailVC") as! MemberDetailVC
                vc.unitModelMember = data
                self.navigationController?.pushViewController(vc, animated: true)
                
                //  revealViewController().pushFrontViewController(vc, animated: true)
           
              }
            
        }
        
        
    }
    
    func selectItem(index:Int) {
        
        //blocks
        
        for i in (0..<blocks.count).reversed() {
            if i == index {
                blocks[i].isSelect = true
            } else {
                blocks[i].isSelect = false
            }
            
        }
        
        cvBlock.reloadData()
        
    }
    
    
    func setDataUtnit(floors:[FloorModelMember]) {
        
        print("dhsdhshdg")
        
        if self.floors.count > 0 {
            self.floors.removeAll()
            cvUnits.reloadData()
        }
        
        self.floors.append(contentsOf: floors)
        cvUnits.reloadData()
        
    }
    
    func doGetSocietes() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMembers":"getMembers",
                      "society_id":doGetLocalDataUser().society_id!,
                      "my_id":doGetLocalDataUser().user_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: NetworkAPI.blockListController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        //   self.societyArray.append(contentsOf: response.society)
                        //  self.cvData.reloadData()
                        self.lbBlock.text = "Total Block: " + String(response.block.count)
                        self.lbPopulation.text = "Total Population: " + String(response.population)
                        
                        self.blocks.append(contentsOf: response.block)
                        self.cvBlock.reloadData()
                        self.setDataUtnit(floors: self.blocks[0].floors)
                        self.selectItem(index: 0)
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
extension MemberVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvUnits {
            return  floors.count
        }
        
        return  blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvUnits {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellFloor, for: indexPath) as! FloorSelectionCell
            
            cell.lbTitle.text = floors[indexPath.row].floor_name
            cell.doSetDataMember(units: floors[indexPath.row].units, isMember: true)
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! BlockMemberCell
        
        cell.lbTitle.text = blocks[indexPath.row].block_name
        
        
        
        if blocks[indexPath.row].isSelect {
            // cell.viewTest.backgroundColor = ColorConstant.primaryColor
            cell.viewTest.backgroundColor = UIColor(named: "ColorPrimary")
            cell.lbTitle.textColor = UIColor.white
        } else {
            
            cell.viewTest.backgroundColor = UIColor(named: "gray_20")
            cell.lbTitle.textColor = ColorConstant.colorGray90
        }
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cvUnits {
            let yourWidth = collectionView.bounds.width
            return CGSize(width: yourWidth-4, height: 80)
        }
        
        return CGSize(width: 80, height: 60)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cvBlock {
           /* let selectedCell = collectionView.cellForItem(at: indexPath) as! BlockMemberCell
            
            selectedCell.viewTest.backgroundColor = ColorConstant.primaryColor
            selectedCell.lbTitle.textColor = UIColor.white
           
            isFirstTimeload = false*/
             self.setDataUtnit(floors: blocks[indexPath.row].floors)
            selectItem(index: indexPath.row)
        }
        
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       /* if collectionView == cvBlock {
            let selectedCell = collectionView.cellForItem(at: indexPath) as! BlockMemberCell
            selectedCell.viewTest.backgroundColor = ColorConstant.colorGray10
            selectedCell.lbTitle.textColor = ColorConstant.colorGray90
            isFirstTimeload = false
        }*/
        
    }
    
}
