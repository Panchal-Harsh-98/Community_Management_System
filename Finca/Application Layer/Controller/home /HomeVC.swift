//
//  HomeVC.swift
//  Finca
//
//  Created by harsh panchal on 29/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit


struct ResponseNotification : Codable {
    let read_status:String!// "read_status" : "9",
    let status:String!//"status" : "200",
    let message:String!// "message" : "Get Notification success.",
    let chat_status:String!// "chat_status" : "0"
    let notification : [NotificationModel]!
    
}
struct NotificationModel : Codable {
 let notification_title:String!   //"notification_title" : "Parking Allocated",
  let notification_action:String!  //"notification_action" : "myparking",
  let read_status:String! // "read_status" : "0",
  let notification_date:String!  //"notification_date" : "2019-06-12 01:03:00",
  let user_id:String! // "user_id" : "410",
  let notification_status:String! // "notification_status" : "0",
  let user_notification_id:String! // "user_notification_id" : "1435",
  let notification_desc:String!  // "notification_desc" : "by Admin"
    
    
}



class HomeVC: BaseVC {
    struct menuData {
        var itemId : Int!
        var itemName : String!
        var itemImage : String!
    }
    
    
    var index = 0
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var cvHomeMenu: UICollectionView!
    @IBOutlet weak var cvHeighConstraint: NSLayoutConstraint!
    var itemCell = "HomeScreenCvCell"
    var homeCellData = [menuData]()
    
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    
    @IBOutlet weak var pager: iCarousel!
    var  slider = [Slider]()
    
     override func viewDidLoad() {
        super.viewDidLoad()
         loadMenuData()
        doLoadSliderData()
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvHomeMenu.register(nib, forCellWithReuseIdentifier: itemCell)
        cvHomeMenu.delegate = self
        cvHomeMenu.dataSource = self
        cvHomeMenu.alwaysBounceVertical = false
        Timer.scheduledTimer(timeInterval: 6.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)
         self.viewChatCount.isHidden =  true
        self.viewNotiCount.isHidden =  true
        
        pager.isPagingEnabled = true
        pager.isScrollEnabled = true
        pager.bounces = true
        pager.delegate = self
        pager.dataSource = self
        pager.reloadData()
        // Do any additional setup after loading the view.
        doInintialRevelController(bMenu: bMenu)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getNotificationCount()
    }
    
   func getNotificationCount() {
    // "read":"0" mean is unread massage
    let params = ["key":ServiceNameConstants.API_KEY,
                  "getNotification":"getNotification",
                  "society_id":doGetLocalDataUser().society_id!,
                  "read":"0",
                  "user_id" : doGetLocalDataUser().user_id!]
    
    print("param" , params)
    
    let request = AlamofireSingleTon.sharedInstance
    
    request.requestPost(serviceName: ServiceNameConstants.userNotificationController, parameters: params) { (json, error) in
        
        if json != nil {
            
            do {
                let response = try JSONDecoder().decode(ResponseNotification.self, from:json!)
                if response.status == "200" {
                    
                    
                    
                    UserDefaults.standard.set(response.chat_status, forKey: StringConstants.CHAT_STATUS)
                    UserDefaults.standard.set(response.read_status, forKey: StringConstants.READ_STATUS)
                    
                    
                    if response.chat_status !=  "0" {
                        self.viewChatCount.isHidden =  false
                        self.lbChatCount.text = response.chat_status
                        
                    } else {
                        self.viewChatCount.isHidden =  true
                    }
                    if response.read_status !=  "0" {
                        self.viewNotiCount.isHidden =  false
                        self.lbNotiCount.text = response.read_status
                        
                    } else {
                        self.viewNotiCount.isHidden =  true
                    }
                    
                }else {
                    
                }
                print(json as Any)
            } catch {
                print("parse error")
            }
        }
    }
    }
    override func viewWillLayoutSubviews() {
        cvHeighConstraint.constant = cvHomeMenu.contentSize.height
    }
    @objc func fire(){
        if slider.count > 0{
            if index == slider.count {
                index = 0
            } else {
                pager.currentItemIndex = index
            }
        }
    }
    
    @IBAction func onClickConversion(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idTabCarversionVC") as! TabCarversionVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func loadMenuData() {
        homeCellData.append(menuData(itemId: 0, itemName: "Funds & Bills", itemImage: "cash"))
        homeCellData.append(menuData(itemId: 1, itemName: "Members", itemImage: "network"))
        homeCellData.append(menuData(itemId: 2, itemName: "Vehicals", itemImage: "car"))
        
        homeCellData.append(menuData(itemId: 3, itemName: "Visitors", itemImage: "visitors"))
        homeCellData.append(menuData(itemId: 4, itemName: "Resources", itemImage: "id_card"))
        homeCellData.append(menuData(itemId: 5, itemName: "Events", itemImage: "event"))
        
        homeCellData.append(menuData(itemId: 7, itemName: "Notice Board", itemImage: "advertisements"))
        homeCellData.append(menuData(itemId: 8, itemName: "Facility", itemImage: "flags"))
        homeCellData.append(menuData(itemId: 9, itemName: "Complains", itemImage: "error"))
        
        homeCellData.append(menuData(itemId: 10, itemName: "Poll", itemImage: "vote"))
        homeCellData.append(menuData(itemId: 11, itemName: "Election", itemImage: "election"))
        homeCellData.append(menuData(itemId: 12, itemName: "Building Details", itemImage: "buildings"))
        
        homeCellData.append(menuData(itemId: 13, itemName: "Emergency Number", itemImage: "ambulance"))
        homeCellData.append(menuData(itemId: 14, itemName: "Profile", itemImage: "bussinessman"))
        homeCellData.append(menuData(itemId: 15, itemName: "SOS", itemImage: "SOS"))
        
        homeCellData.append(menuData(itemId: 16, itemName: "Gallery", itemImage: "graphic"))
        homeCellData.append(menuData(itemId: 17, itemName: "Documents", itemImage: "assignment"))
        homeCellData.append(menuData(itemId: 18, itemName: "Balance Sheet", itemImage: "wallet"))
        cvHomeMenu.reloadData()
    }
    
    func doLoadSliderData() {
        showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getSlider":"getSlider",
                      "society_id":doGetLocalDataUser().society_id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.SLIDER_CONTROLLER, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    let response = try JSONDecoder().decode(SliderResponse.self, from:json!)
                    if response.status == "200" {
                        self.slider.append(contentsOf: response.slider)
                        self.pager.reloadData()
                        
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
}

extension HomeVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeCellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvHomeMenu.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! HomeScreenCvCell
        cell.lblHomeCell.text = homeCellData[indexPath.row].itemName
        cell.imgHomeCell.image = UIImage(named: homeCellData[indexPath.row].itemImage)
        setCardView(view: cell.viewMain)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width/3.0
        
        return CGSize(width: yourWidth, height: yourWidth-2 )
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! HomeScreenCvCell
        UIView.animate(withDuration: 0.2, delay: 0.4, options: .curveEaseInOut, animations: {
            cell.backgroundColor = UIColor.red
        }, completion: { _ in
            // here the animation is done
        })
        doActionOnSelectedItem(SelectedItemId: homeCellData[indexPath.row].itemId)
    }
    
    func setCardView(view : UIView){
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    func doActionOnSelectedItem(SelectedItemId : Int) {
        switch (SelectedItemId) {
        case 0:
            print("funds and bills")
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idBillsAndFundsVC")as! BillsAndFundsVC
            self.navigationController?.pushViewController(nextVC, animated: true)
            break;
        case 1:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idMemberVC")as! MemberVC
            self.navigationController?.pushViewController(nextVC, animated: true)
            break;
        case 2:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idVehicleMainTabVC")as! VehicleMainTabVC
           // self.present(nextVC, animated: true, completion: nil)
            
            let newFrontViewController = UINavigationController.init(rootViewController: nextVC)
            newFrontViewController.isNavigationBarHidden = true
            revealViewController().pushFrontViewController(nextVC, animated: true)
            
            break;
        case 3:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idVisitorVC")as! VisitorVC
            self.present(nextVC, animated: true, completion: nil)
            break
        case 4:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idResourcesVC")as! ResourcesVC
            self.navigationController?.pushViewController(nextVC, animated: true )
            break;
        case 5:
            
           
            break;
        case 6:
            break;
        case 7:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idNoticeVC")as! NoticeVC
            self.navigationController?.pushViewController(nextVC, animated: true )
            
            // NoticeVC
            break;
        case 8:
            break;
        case 9:
            break;
        case 10:
            break;
        case 11:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idElectionVC")as! ElectionVC
            self.navigationController?.pushViewController(nextVC, animated: true)
            break;
        case 12:
            break;
        case 13:
            break;
        case 14:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idProfileVC")as! ProfileVC
            self.navigationController?.pushViewController(nextVC, animated: true )
            break;
        case 15:
            break;
        case 16:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idGalleryVC")as! GalleryVC
            self.navigationController?.pushViewController(nextVC, animated: true)
            break;
        case 17:
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "idDocumentsVC")as! DocumentsVC
            self.navigationController?.pushViewController(nextVC, animated: true)
            break;
        case 18:
            break;
        default:
            break;
        }
        
    }
   
}
extension HomeVC : iCarouselDelegate,iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return slider.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let viewCard = (Bundle.main.loadNibNamed("HomeSliderCell", owner: self, options: nil)![0] as? UIView)! as! HomeSliderCell
        
        
        Utils.setImageFromUrl(imageView: viewCard.ivImage, urlString: slider[index].sliderImageName)
        viewCard.frame = pager.frame
        viewCard.viewMain.layer.cornerRadius = 10
        viewCard.viewMain.backgroundColor = UIColor.gray
        viewCard.ivImage.layer.cornerRadius = 10
        
        viewCard.ivImage.clipsToBounds = true
        viewCard.layer.masksToBounds = false
        viewCard.layer.shadowColor = UIColor.black.cgColor
        viewCard.layer.shadowOpacity = 0.5
        viewCard.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewCard.layer.shadowRadius = 1
        return viewCard
    }
    
    //For spacing of two items
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        if (option == .spacing) {
            return value * 1.1
        }
        return value
        
    }
    
    //scrolling started
    func carouselDidScroll(_ carousel: iCarousel) {
        index = carousel.currentItemIndex + 1
        ////   print("index:\(index)")
        
    }
}
