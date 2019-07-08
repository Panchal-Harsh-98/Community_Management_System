//
//  VehicleMainTabVC.swift
//  Finca
//
//  Created by anjali on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class VehicleMainTabVC: ButtonBarPagerTabStripViewController , SWRevealViewControllerDelegate {

    var overlyView = UIView()
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    @IBOutlet weak var bMenu: UIButton!
    
     override func viewDidLoad() {
        loadDesing()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealViewController().delegate = self
        if self.revealViewController() != nil {
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if revealController.frontViewPosition == FrontViewPosition.left     // if it not statisfy try this --> if
        {
            overlyView.frame = CGRect(x: 0, y: 60, width: self.view.frame.size.width, height: self.view.frame.size.height)
            //overlyView.backgroundColor = UIColor.red
            self.view.addSubview(overlyView)
            //self.view.isUserInteractionEnabled = false
        }
        else
        {
            overlyView.removeFromSuperview()
            //self.view.isUserInteractionEnabled = true
        }
    }
    func loadDesing () {
        settings.style.selectedBarHeight=1
        //   settings.style.buttonBarBackgroundColor = UIColor(red: 50/255.0, green: 81/255.0, blue: 101/255.0, alpha: 1.0)
        settings.style.buttonBarBackgroundColor = UIColor(named: "ColorPrimary")
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = UIColor.white
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor.blue
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarHeight = 20
        
        
        
        changeCurrentIndexProgressive = {(oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor =  ColorConstant.colorGray10
            newCell?.label.textColor = UIColor.white
            
        }
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTabMyVC")
        
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTabMemberVC")
        
        return [child_1, child_2]
        
    }
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadNoti()
    }
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
}
