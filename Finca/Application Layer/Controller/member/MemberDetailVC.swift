//
//  MemberDetailVC.swift
//  Finca
//
//  Created by anjali on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class MemberDetailVC: BaseVC {

    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var ivBuilding: UIImageView!
    @IBOutlet weak var ivMultiuser: UIImageView!
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var lbFamiylCount: UILabel!
     @IBOutlet weak var lbStatus: UILabel!
    
    @IBOutlet weak var ivProfile: UIImageView!
    
    var unitModelMember:UnitModelMember!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        changeButtonImageColor(btn: bBack, image: "back", color: UIColor.white)
        ivBuilding.setImageColor(color: ColorConstant.primaryColor)
        ivMultiuser.setImageColor(color: ColorConstant.primaryColor)
        
        
        lbFamiylCount.text =  unitModelMember.family_count
       
        
        lbName.text = unitModelMember.user_full_name
        if unitModelMember.unit_status == "3" {
          lbStatus.text = "Tenant"
        }else if unitModelMember.unit_status == "1" {
             lbStatus.text = "Owner"
        }
        
        Utils.setRoundImageWithBorder(imageView: ivProfile, color: UIColor.red)
        Utils.setImageFromUrl(imageView: ivProfile, urlString: unitModelMember.user_profile_pic)
        //Utils.setU
        
        //ivProfile
    }
    
    @IBAction func onClickChat(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "idChatVC") as! ChatVC
        vc.unitModelMember =  unitModelMember
         vc.isGateKeeper = false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
}
