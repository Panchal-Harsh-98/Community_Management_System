//
//  GalleryVC.swift
//  Finca
//
//  Created by harsh panchal on 24/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Toast_Swift
class GalleryVC: BaseVC,UIGestureRecognizerDelegate {
    @IBOutlet weak var cvGallery: UICollectionView!
    var itemCell = "GalleryCell"
    var gallery_List = [EventModel]()
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doGetGalleryImages()
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvGallery.register(nib, forCellWithReuseIdentifier: itemCell)
        cvGallery.delegate = self
        cvGallery.dataSource = self
        doInintialRevelController(bMenu: bMenu)
        setupLongPressGesture()
        
        addRefreshControlTo(collectionView: cvGallery)
    }
    
    override func fetchNewDataOnRefresh() {
        refreshControl.beginRefreshing()
        gallery_List.removeAll()
        doGetGalleryImages()
        refreshControl.endRefreshing()
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 0.5 // 1 second press
        longPressGesture.delegate = self
        self.cvGallery.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.cvGallery)
            self.view.makeToastActivity(.center)
            if let indexPath = cvGallery.indexPathForItem(at: touchPoint) {
                let count = gallery_List[indexPath.row].gallery.count
                var Image_Array = [GalleryModel]()
                Image_Array.append(contentsOf:gallery_List[indexPath.row].gallery )
                for i in 0...count-1{
                    let imagestring =  String(Image_Array[i].galleryPhoto!)
                    if let url = URL(string: imagestring),
                        let data = try? Data(contentsOf: url),
                        let image = UIImage(data: data) {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                    else{
                    }
                }
                self.view.hideAllToasts()
                 self.view.makeToast("Image Saved to Gallery", duration: 2.0, position: .bottom, style: successStyle)
            }
        }
    }
    
    func doGetGalleryImages() {
        showProgress()
        
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getGallery":"getGallery",
                      "society_id":doGetLocalDataUser().society_id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.galleryController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(GalleryResponse.self, from:json!)
                    if response.status == "200" {
                        self.gallery_List.append(contentsOf: response.event)
                        self.cvGallery.reloadData()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
extension GalleryVC : UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gallery_List.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvGallery.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! GalleryCell
        
       
        let count =  gallery_List[indexPath.row].gallery.count
        cell.lblCount.text  = String(count)
        cell.lblFolderName.text = gallery_List[indexPath.row].eventTitle
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let yourWidth = collectionView.bounds.width/3.0
        
        return CGSize(width: yourWidth-6, height: yourWidth-20 )
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let nextVC =  self.storyboard?.instantiateViewController(withIdentifier: "idGallerySliderVC")as! GallerySliderVC
        nextVC.event_Image_Array.append(contentsOf: gallery_List[indexPath.row].gallery)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
