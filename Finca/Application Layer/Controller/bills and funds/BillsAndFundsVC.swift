//
//  BillsAndFunds.swift
//  Finca
//
//  Created by harsh panchal on 12/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class BillsAndFundsVC:ButtonBarPagerTabStripViewController, UIGestureRecognizerDelegate,SWRevealViewControllerDelegate {
    
    let selectedColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var month : [String] = []
    var year_arr : [String] = []
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var PickerViewContainer: UIView!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    var selected_index = 0
     let overlyView = UIView ()
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    override func viewDidLoad() {
        
        
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
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
        
        loadSlideMenu()
        month = ["All","January","February","March","April","May","June","July","August","September","October","November","December"]
        let date = Date()
        let calender = Calendar.current
        var year = calender.component(.year,from: date)
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            newCell?.label.textColor = self?.selectedColor
        }
        
        for i in 0...4{
            if i == 0 {
                year_arr.append(String(year))
            }else{
                year = year-1
                year_arr.append(String(year))
            }
        }
        pickerView.delegate = self
        pickerView.dataSource = self
        
        lblYear.text = year_arr[selected_index]
        lblMonth.text = month[selected_index]
         NotificationCenter.default.post(name: NSNotification.Name(StringConstants.NOTI_UPDATE_CONTENT), object: nil, userInfo:["month":lblMonth.text!,"year":lblYear.text!])
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = self.storyboard?.instantiateViewController(withIdentifier: "idFundFragmentVC")as! FundFragmentVC
//        child_1.loadView()
        let child_2 = self.storyboard?.instantiateViewController(withIdentifier: "idBillFragmentVC")as! BillFragmentVC
//        child_2.loadView()
        return [child_1, child_2]
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @IBAction func btnbackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnHidePicker(_ sender: UIButton) {
        PickerViewContainer.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name(StringConstants.NOTI_UPDATE_CONTENT), object: nil, userInfo:["month":lblMonth.text!,"year":lblYear.text!])
        
    }
    
    @IBAction func btnMonthSelect(_ sender: UIButton) {
        
        pickerView.tag = 0
        pickerView.reloadAllComponents()
        PickerViewContainer.isHidden = false
    }
    
    @IBAction func btnYearSelect(_ sender: UIButton) {
        pickerView.tag = 1
        pickerView.reloadAllComponents()
        PickerViewContainer.isHidden = false
    }
    func  loadSlideMenu() {
        self.revealViewController().delegate = self
        if self.revealViewController() != nil {
            bMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            
        }
    }
    
    func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        
        if revealController.frontViewPosition == FrontViewPosition.left
        {
            overlyView.frame = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(overlyView)
        }
        else
        {
            overlyView.removeFromSuperview()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadNoti()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
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
    @IBAction func onClickChar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
extension BillsAndFundsVC : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView.tag {
        case 0:
            return month.count
          
        case 1:
            return year_arr.count
           
        default:
            break;
            
            
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return month[row]
           
        case 1:
            return year_arr[row]
           
        default:
            break;
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            lblMonth.text = month[row]
            break;
        case 1:
            lblYear.text = year_arr[row]
            break;
        default:
            break;
        }
    }
    
    
}
