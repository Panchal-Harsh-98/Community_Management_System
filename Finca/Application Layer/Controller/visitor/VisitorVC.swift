//
//  VisitorVC.swift
//  Finca
//
//  Created by harsh panchal on 17/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import EzPopup
class VisitorVC: ButtonBarPagerTabStripViewController,SWRevealViewControllerDelegate {
    
    @IBOutlet weak var bMenu: UIButton!
    var selectedColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = selectedColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        super.viewDidLoad()
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            newCell?.label.textColor = self?.selectedColor
        }
        NotificationCenter.default.addObserver(self, selector: #selector(loadDialog(_:)), name: Notification.Name(rawValue:StringConstants.KEY_NOTIFICATION_VISITOR), object: nil)
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "idArrivedFragmentVC")as! ArrivedFragmentVC
        //        child_1.loadView()
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "idExpectedFragmentVC")as! ExpectedFragmentVC
        //        child_2.loadView()
        return [child_1, child_2]
    }
    @objc func loadDialog(_ notification: Notification) {
        let screenwidth = UIScreen.main.bounds.width
        let screenheight = UIScreen.main.bounds.height
        let destiController = self.storyboard?.instantiateViewController(withIdentifier: "idAddExpMemberDialogVC") as! AddExpMemberDialogVC
        
        let popupVC = PopupViewController(contentController: destiController, popupWidth: screenwidth - 50, popupHeight: screenheight-80
        )
        
        popupVC.backgroundAlpha = 0.5
        popupVC.backgroundColor = .black
        popupVC.shadowEnabled = true
        popupVC.canTapOutsideToDismiss = true
        present(popupVC, animated: true)

    }
}
