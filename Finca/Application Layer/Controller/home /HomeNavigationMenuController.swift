//
//  HomeNavigationMenuController.swift
//  Finca
//
//  Created by harsh panchal on 29/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
struct menuCell {
    var title : String!
    var image : String!
    var isSelectd : Bool!
}

class HomeNavigationMenuController: BaseVC {
    @IBOutlet weak var tbvMenuListHeighConstrint: NSLayoutConstraint!
    @IBOutlet weak var tbvMenuList: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    var itemCell = "NavigationMenuCell"
    var menuData = [menuCell]()
    
    @IBOutlet weak var lbUserName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //    imgProfile.layer.borderWidth = 2
    //    imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    //    imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        
        Utils.setRoundImageWithBorder(imageView: imgProfile, color: UIColor.white)
      
        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvMenuList.register(inb, forCellReuseIdentifier: itemCell)
        tbvMenuList.delegate = self
        tbvMenuList.dataSource = self
        tbvMenuList.separatorStyle = .none
        loadMenuData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Utils.setImageFromUrl(imageView: imgProfile, urlString: doGetLocalDataUser().user_profile_pic!)
        lbUserName.text = doGetLocalDataUser().user_full_name
    }
    
    override func viewWillLayoutSubviews() {
         self.tbvMenuListHeighConstrint?.constant = self.tbvMenuList.contentSize.height
    }
    func loadMenuData() {
        menuData.append(menuCell(title: StringConstants.MENU_DASHBOARD,image: "dashboard",isSelectd: true))
        menuData.append(menuCell(title: StringConstants.MENU_FUNDBILL,image: "paper-bill",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_MEMBERS,image: "multiple-users-silhouette",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_VEHICALS,image: "car-front",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_VISITORS,image: "visitors",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_STAFF,image: "staff",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_EVENT,image: "planning",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_NOTICE_BOARD,image: "megaphone-1",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_FACILITY,image: "fitness-facilities",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_COMPLAINTS,image: "complaint",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_POLL,image: "checklist",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_ELECTION,image: "vote",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_BUILDING_DETAILS,image: "building",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_PROFILE,image: "user",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_EMERGANCY,image: "ambulance-1",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_SOS,image: "sos-menu",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_GALLRY,image: "gallery-2",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_DOCUMENT,image: "documnet",isSelectd: false))
        
        menuData.append(menuCell(title: StringConstants.MENU_BALANCE_SHEET,image: "wallet",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_CHANGE_PASSWORD,image: "lock",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_LOGUT,image: "logout",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_CONTACT_US,image: "mail",isSelectd: false))
        tbvMenuList.reloadData()
        
    }
    
    func doSelectMenu(index:Int) {
        print("select menu" , index)
//        let storyBoard = HomeNavigationMenuController.getStoryboard()
        
        if menuData[index].title == StringConstants.MENU_DASHBOARD {
            
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
          //  self.navigationController?.pushViewController(destiController, animated: true)
           revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        }
        else if menuData[index].title == StringConstants.MENU_VISITORS {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idVisitorVC") as! VisitorVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(destiController, animated: true)

        }
        else if menuData[index].title == StringConstants.MENU_FUNDBILL {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idBillsAndFundsVC") as! BillsAndFundsVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(destiController, animated: true)
        
        }
        else if menuData[index].title == StringConstants.MENU_EVENT {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idEventsVC") as! EventsVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(destiController, animated: true)
            
        }
        else if menuData[index].title == StringConstants.MENU_NOTICE_BOARD {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idNoticeVC") as! NoticeVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(destiController, animated: true)
            
        }  else if menuData[index].title == StringConstants.MENU_COMPLAINTS {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idComplaintsVC") as! ComplaintsVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(destiController, animated: true)
            
        }else if menuData[index].title == StringConstants.MENU_ELECTION {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idElectionVC") as! ElectionVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(destiController, animated: true)
            
        }
        else if menuData[index].title == StringConstants.MENU_PROFILE {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idProfileVC") as! ProfileVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(destiController, animated: true)
            
        }
        else if menuData[index].title == StringConstants.MENU_MEMBERS {
            let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idMemberVC") as! MemberVC
         //   let destiController = self.storyboard!.instantiateViewController(withIdentifier: "idNavMember") as! UINavigationController
            
        //    let newFrontViewController = UINavigationController.init(rootViewController: destiController)
          //  newFrontViewController.isNavigationBarHidden = true
      //  present(destiController, animated: true, completion: nil)
          revealViewController().pushFrontViewController(destiController, animated: true)
      //  self.navigationController?.pushViewController(destiController, animated: true)
        }
        
        
        
        
        
        
//        else if menuData[index].title == StringConstants. {
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idMyOrdersVC") as! MyOrdersVC
//            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(destiController, animated: true)
//        }
//        else if menuData[index].title == ConstantStrings.REQUEST_QUOTATION {
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idCartVC") as! CartVC
//            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(destiController, animated: true)
//        } else if menuData[index].title == ConstantStrings.FEEDBACK {
//
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idFeedbackVC") as! FeedbackVC
//            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(destiController, animated: true)
//
//        }else if menuData[index].title == ConstantStrings.CHANGE_PASSWORD {
//
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idChangePasswordVC") as! ChangePasswordVC
//            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(destiController, animated: true)
//
//        }else if menuData[index].title == ConstantStrings.LOGOUT {
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idLogoutDialogVC") as! LogoutDialogVC
//            let popupVC = PopupViewController(contentController: destiController, popupWidth: 400, popupHeight: 160)
//            popupVC.backgroundAlpha = 0.5
//            popupVC.backgroundColor = .black
//            popupVC.shadowEnabled = true
//            popupVC.canTapOutsideToDismiss = true
//            // show it by call present(_ , animated:) method from a current UIViewController
//            present(popupVC, animated: true)
//        }
//
        //   else if menuData[index].title == ConstantStrings.MENU_PROFILE {
        //            let destiController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        //            newFrontViewController.isNavigationBarHidden = true
        //            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        //        } else if menuData[index].title == ConstantStrings.MENU_PROFILE {
        //            let destiController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        //            newFrontViewController.isNavigationBarHidden = true
        //            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        //        }else if menuData[index].title == ConstantStrings.MENU_PROFILE {
        //            let destiController = storyBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
        //            newFrontViewController.isNavigationBarHidden = true
        //            revealViewController().pushFrontViewController(newFrontViewController, animated: true)
        //        }
    }
    static func getStoryboard() -> UIStoryboard
    {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard
    }
}

extension HomeNavigationMenuController : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvMenuList.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! NavigationMenuCell
        cell.lblMenuItemName.text = menuData[indexPath.row].title
        cell.imgMenuItem.image = UIImage(named: menuData[indexPath.row].image)
        //print("dddd" , indexPath.row)
       // print("dddd" ,  menuData[indexPath.row].isSelectd)
        
        if menuData[indexPath.row].isSelectd {
          cell.lblMenuItemName.textColor = UIColor(named: "ColorPrimary")
          cell.imgMenuItem.setImageColor(color: UIColor(named: "ColorPrimary")!)
            cell.viewSelect.isHidden = false
        } else {
            cell.lblMenuItemName.textColor = UIColor(named: "grey_60")
            cell.imgMenuItem.setImageColor(color: UIColor(named: "grey_60")!)
             cell.viewSelect.isHidden = true
        }
      
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doSelectMenu(index: indexPath.row)
       
        doReset(index: indexPath.row)
        
    }
    func doReset(index:Int) {
       
        
        for i in (0..<menuData.count).reversed() {
           if i == index {
                  menuData[i].isSelectd = true
            } else {
                  menuData[i].isSelectd = false
            }
          
        }
        
     tbvMenuList.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("sdjsbdjvsjdv")
       // menuData[indexPath.row].isSelectd = false
       // tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         self.viewWillLayoutSubviews()
    }
    
}
