//
//  MemberParkingCell.swift
//  Finca
//
//  Created by anjali on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class MemberParkingCell: UICollectionViewCell {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var tvUnit: UILabel!
    @IBOutlet weak var cvData: UICollectionView!
    let itemCell = "MyVehicleNumberCell"
    var myParking = [MyParkingModelMember]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        cvData.delegate = self
        cvData.dataSource = self
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
    }
    
    func doSetData(myParking : [MyParkingModelMember]) {
        
        if self.myParking.count > 0 {
            self.myParking.removeAll()
            cvData.reloadData()
        }
        self.myParking.append(contentsOf: myParking)
        cvData.reloadData()
        
    }

}
extension  MemberParkingCell :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! MyVehicleNumberCell
        
        cell.lbNumber.text =  myParking[indexPath.row].vehicle_no
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myParking.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let yourWidth = collectionView.bounds.width - 90
        return CGSize(width: yourWidth - 5, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
    }
    
}

