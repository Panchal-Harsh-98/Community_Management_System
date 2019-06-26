//
//  GallerySliderVC.swift
//  Finca
//
//  Created by harsh panchal on 24/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Toast_Swift
class GallerySliderVC: BaseVC {
    
    var event_Image_Array = [GalleryModel]()
    let itemCell = "GallerySliderCell"
    var index = 0
    @IBOutlet weak var cvImageSlider: UICollectionView!
    @IBOutlet weak var pager: iCarousel!
    
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        let nib = UINib(nibName: itemCell, bundle: nil)
        cvImageSlider.register(nib, forCellWithReuseIdentifier: itemCell)
        cvImageSlider.delegate = self
        cvImageSlider.dataSource = self
        loadPager()
    }
    func loadPager() {
        pager.isPagingEnabled = true
        pager.isScrollEnabled = true
        pager.bounces = true
        pager.delegate = self
        pager.dataSource = self
        pager.reloadData()
    }
    func scrollPagerTo(index : Int!) {
        pager.currentItemIndex = index
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnDownloadClicked(_ sender: UIButton) {
        let imagestring =  String(event_Image_Array[index].galleryPhoto!)
        if let url = URL(string: imagestring),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.view.makeToast("Image Saved to Gallery", duration: 2.0, position: .bottom, style: successStyle)
        }
        else{
             self.view.makeToast("Download Failed", duration: 3.0, position: .bottom, style: failureStyle)
        }
    }
}

extension GallerySliderVC : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return event_Image_Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cvImageSlider.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath)as! GallerySliderCell
        
        Utils.setImageFromUrl(imageView: cell.imgEvent, urlString: event_Image_Array[indexPath.row].galleryPhoto)
        
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
        scrollPagerTo(index: indexPath.row)
    }
}
extension GallerySliderVC : iCarouselDelegate,iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        return event_Image_Array.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let viewCard = (Bundle.main.loadNibNamed("GallerySlider", owner: self, options: nil)![0] as? UIView)! as! GallerySlider
        
        
        Utils.setImageFromUrl(imageView: viewCard.imgGallerySlider, urlString: event_Image_Array[index].galleryPhoto)
        viewCard.frame = pager.frame
        
        viewCard.imgGallerySlider.layer.cornerRadius = 10
        
        viewCard.imgGallerySlider.clipsToBounds = true
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
