//
//  TabMemberVC.swift
//  Finca
//
//  Created by anjali on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip



class TabMemberVC: BaseVC {
    let itemCell = "BlockMemberCell"
    var blocks = [BlockModelMember]()
    var  units = [UnitModelMember]()
    var isFirstTime = true
    @IBOutlet weak var cvBlock: UICollectionView!
    @IBOutlet weak var cvUnits: UICollectionView!
    
    let itemCellParkingMember = "MemberParkingCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cvBlock.delegate = self
        cvBlock.dataSource = self
        cvUnits.delegate = self
        cvUnits.dataSource = self
        
        
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvBlock.register(inb, forCellWithReuseIdentifier: itemCell)
        
        let inbUnit = UINib(nibName: itemCellParkingMember, bundle: nil)
        cvUnits.register(inbUnit, forCellWithReuseIdentifier: itemCellParkingMember)
        
        
        doGetMemberParking()
    }
    

    func setDataUtnit(blockModelMember:BlockModelMember) {
        
        if self.units.count > 0 {
            self.units.removeAll()
            cvUnits.reloadData()
        }
        
        for floor in blockModelMember.floors {
         //  print("flor blod id " , floor.block_id )
           //  print(" blod id " , blockModelMember.block_id )
            if floor.block_id == blockModelMember.block_id {
                
                for unit in floor.units {
                    
                    
                    //print("unit.unit_status" , unit.unit_status)
                    //print("unit.user_full_name" , unit.user_full_name)
                   //  print("unit.user_full_name" , floor.)
                    if unit.unit_status == "1" ||  unit.unit_status == "3" || unit.unit_status == "5" {
                        
                        units.append(unit)
                    }
                    //units.append(contentsOf: floor.units)
                }
                
            }
            
            
        }

        
        cvUnits.reloadData()
        
        
        
        
        
       // self.units.append(contentsOf: floors)
       // cvUnits.reloadData()
        
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
  
    func doGetMemberParking() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getMembers":"getMembers",
                      "my_id":doGetLocalDataUser().user_id!,
                      "society_id":doGetLocalDataUser().society_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPost(serviceName: NetworkAPI.blockList, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseMember.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                      //   self.cvVehicleNumner.reloadData()
                      //  self.cvParkingSlot.reloadData()
                        
                       
                        self.blocks.append(contentsOf: response.block)
                        self.cvBlock.reloadData()
                        
                        self.setDataUtnit(blockModelMember: self.blocks[0])
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
extension TabMemberVC : IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "MEMBERS")
    }
    
}
extension TabMemberVC :  UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == cvUnits {
            return  units.count
        }
        
        return  blocks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == cvUnits {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellParkingMember, for: indexPath) as! MemberParkingCell
            
            cell.lbName.text = units[indexPath.row].user_full_name
            cell.tvUnit.text = units[indexPath.row].unit_name
            cell.doSetData(myParking: units[indexPath.row].myParking)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! BlockMemberCell
        
      //  cell.viewMain.backgroundColor = ColorConstant.primaryColor
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
            return CGSize(width: yourWidth-4, height: 150)
        }
        
        return CGSize(width: 80, height: 60)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == cvBlock {
            //let selectedCell = collectionView.cellForItem(at: indexPath) as! BlockMemberCell
            
           /* selectedCell.viewTest.backgroundColor = ColorConstant.primaryColor
            selectedCell.lbTitle.textColor = UIColor.white
          //  self.setDataUtnit(floors: blocks[indexPath.row].floors)
            self.isFirstTime = false*/
            
            self.setDataUtnit(blockModelMember: blocks[indexPath.row])
            selectItem(index: indexPath.row)
        }
        
        
        
        
    }
    
    
   
    
}

