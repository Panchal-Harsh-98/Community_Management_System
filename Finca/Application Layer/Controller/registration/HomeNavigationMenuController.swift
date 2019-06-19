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

class HomeNavigationMenuController: UIViewController {
    @IBOutlet weak var tbvMenuListHeighConstrint: NSLayoutConstraint!
    @IBOutlet weak var tbvMenuList: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    var itemCell = "NavigationMenuCell"
    var menuData = [menuCell]()
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        imgProfile.layer.cornerRadius = imgProfile.frame.height/2
        
        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvMenuList.register(inb, forCellReuseIdentifier: itemCell)
        tbvMenuList.delegate = self
        tbvMenuList.dataSource = self
        loadMenuData()
        
    }
    
    override func viewWillLayoutSubviews() {
         self.tbvMenuListHeighConstrint?.constant = self.tbvMenuList.contentSize.height
    }
    func loadMenuData() {
        menuData.append(menuCell(title: StringConstants.MENU_DASHBOARD,image: "profile",isSelectd: true))
        menuData.append(menuCell(title: StringConstants.MENU_FUNDBILL,image: "Categories",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_MEMBERS,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_VEHICALS,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_VISITORS,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_STAFF,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_EVENT,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_NOTICE_BOARD,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_FACILITY,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_COMPLAINTS,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_POLL,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_ELECTION,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_BUILDING_DETAILS,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_PROFILE,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_NOTIFICATION,image: "sampleProduct",isSelectd: false))
        menuData.append(menuCell(title: StringConstants.MENU_CONTACT_US,image: "sampleProduct",isSelectd: false))
        tbvMenuList.reloadData()
    }
    
    func doSelectMenu(index:Int) {
        print("select menu" , index)
        let storyBoard = HomeNavigationMenuController.getStoryboard()
        
        if menuData[index].title == StringConstants.MENU_DASHBOARD {
            let destiController = storyBoard.instantiateViewController(withIdentifier: "idHomeVC") as! HomeVC
            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
            newFrontViewController.isNavigationBarHidden = true
            self.navigationController?.pushViewController(destiController, animated: true)
        }
//        else if menuData[index].title == ConstantStrings.MENU_CATEGORIES {
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idCategoriesVC") as! CategoriesVC
//            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(destiController, animated: true)
//
//        }
//        else if menuData[index].title == ConstantStrings.MENU_MY_SAMPLE_PRODUCTS {
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idSampleProductsVC") as! SampleProductsVC
//            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(destiController, animated: true)
//        }  else if menuData[index].title == ConstantStrings.MENU_MY_ORDERS {
//            let destiController = storyBoard.instantiateViewController(withIdentifier: "idMyOrdersVC") as! MyOrdersVC
//            let newFrontViewController = UINavigationController.init(rootViewController: destiController)
//            newFrontViewController.isNavigationBarHidden = true
//            self.navigationController?.pushViewController(destiController, animated: true)
//        } else if menuData[index].title == ConstantStrings.REQUEST_QUOTATION {
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
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
}
