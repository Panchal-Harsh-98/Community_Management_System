//
//  SocietyVC.swift
//  Finca
//
//  Created by anjali on 24/05/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ResponseSociety : Codable{
    let message:String! //"message" : "Get Society success.",
    let status:String! //"status" : "200"
    let society:[ModelSociety]!
}

struct ModelSociety:Codable {
    let api_key:String!//" : "bmsapikey",
    let societyUserId:String!//" : "",
    let builder_name:String!//" : "Akki",
    let society_name:String!//" : "Silverwing Society",
    let builder_mobile:String!//" : "9157146041",
    let sub_domain:String!//" : "https:\/\/www.fincasys.com\/",
    let secretary_mobile:String!//" : "9157146041",
    let society_id:String!//" : "48",
    let builder_address:String!//" : "Naroda",
    let secretary_email:String!//" : "ankitrana1056@gmail.com",
    let society_address:String!//" : "1st Floor, Parshwa Tower,\r\nAbove Kotak Mahindra Bank,\r\nS.G
    let socieaty_status:String!//" : null,
    let socieaty_logo:String!//" : "1562061152.png"
}

class SocietyVC: BaseVC {
    
    @IBOutlet weak var cvData: UICollectionView!
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var bLogin: UIButton!
    
    @IBOutlet weak var tfSearch: UITextField!
    var societyArray = [ModelSociety]()
    var selectedSociety : ModelSociety!
       var filterSocietyArray = [ModelSociety]()
    let itemCell = "SocietyRegistrationCell"
    var city_id : String! // = ""
    var state_id : String! // = ""
    var country_id : String! // = ""
    var selectIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cvData.delegate = self
        cvData.dataSource = self
        let inb = UINib(nibName: itemCell, bundle: nil)
        cvData.register(inb, forCellWithReuseIdentifier: itemCell)
        
        bLogin.isEnabled = false
        doGetSocietes()
       // changeButtonImageColor(btn: bBack, image: "back",color: ColorConstant.primaryColor)
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        
            filterSocietyArray = textField.text!.isEmpty ? societyArray : societyArray.filter({ (item:ModelSociety) -> Bool in
                
                return item.society_name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
            })
            
            cvData.reloadData()
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    func doGetSocietes() {
        showProgress()
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":apiKey(),
                      "getSociety":"getSociety",
                      "country_id":country_id!,
                      "state_id":state_id!,
                      "city_id":city_id!]
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
       
        requrest.requestPostMain(serviceName: ServiceNameConstants.societyList, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseSociety.self, from:json!)
                    
                    
                    if response.status == "200" {
                       
                        self.societyArray.append(contentsOf: response.society)
                        self.filterSocietyArray = self.societyArray
                        self.cvData.reloadData()
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }

    }
    
    @IBAction func onClickContinew(_ sender: Any) {
       print("onclick")
    //    let vc = storyboard?.instantiateViewController(withIdentifier: "idOTPVerificationVC") as! OTPVerificationVC
       // vc.selectedSociety = selectedSociety
        let vc = storyboard?.instantiateViewController(withIdentifier: "idLoginVC") as! LoginVC
       vc.society_id = selectedSociety.society_id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func onClickBack(_ sender: Any) {
    doPopBAck()
    }
    
}

extension  SocietyVC :   UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCell, for: indexPath) as! SocietyRegistrationCell
        
        cell.lbTitle.text = filterSocietyArray[indexPath.row].society_name
        cell.lbDesc.text = filterSocietyArray[indexPath.row].society_address
        
        if  selectIndex == indexPath.row{
            cell.viewMain.backgroundColor = UIColor(named: "gray_40")
            
        } else {
             cell.viewMain.backgroundColor = UIColor.white
        }
        
      return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return self.filterSocietyArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width
        return CGSize(width: yourWidth-3, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
      //  print("didSelectItemAt")
       // let selectedCell = collectionView.cellForItem(at: indexPath) as! SocietyRegistrationCell
        
        
        selectIndex = indexPath.row
        collectionView.reloadData()
        bLogin.backgroundColor = UIColor(named: "gray_40")
        bLogin.isEnabled = true
        selectedSociety = societyArray[indexPath.row]
        
            UserDefaults.standard.set(self.societyArray[indexPath.row].sub_domain, forKey: StringConstants.KEY_BASE_URL)
            UserDefaults.standard.set(self.societyArray[indexPath.row].api_key, forKey: StringConstants.KEY_API_KEY)
       
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       // let selectedCell = collectionView.cellForItem(at: indexPath) as! SocietyRegistrationCell
      //  print("didDeselectItemAt")
       
    }
    
}

