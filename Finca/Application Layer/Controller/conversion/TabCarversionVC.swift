//
//  TabCarversionVC.swift
//  Finca
//
//  Created by anjali on 19/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class TabCarversionVC: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        loadDesing()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
        
        
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTabMemberConversionVC")
        
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idTabGateKeeperVC")
        
        return [child_1, child_2]
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
}
