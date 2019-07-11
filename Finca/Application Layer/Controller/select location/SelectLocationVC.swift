//
//  SelectLocationVC.swift
//  Finca
//
//  Created by anjali on 02/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

struct ReposneLocation : Codable {
    
     let  message : String! //"message" : "Get countries success.",
     let  status : String!// "status" : "200"
    let countries : [CountriModel]!
    
}

struct CountriModel : Codable {
    let capital:String! //" : "New Delhi",
    let country_id:String! //" : "101",
    let currency:String! //" : "India",
    let iso2:String! //" : "91",
    let iso3:String! //" : "IND"//
    let name:String! //" : "Uttarakhand"
    let phonecode:String! //" : "1585",
    let states:[StateModel]!
}
struct StateModel : Codable {
    let country_id : String!//" : "101",
    let name : String!//" : "Andaman and Nicobar Islands",
    let state_id : String!//" : "1547",
    let cities : [CityModel]!
    
}
struct CityModel : Codable {
    let city_id : String!//" : "14717",
    let country_id : String!//" : "101",
    let name : String!//" : "Bombuflat",
    let state_id : String!//" : "1547"
   
}

class SelectLocationVC: BaseVC {
    
    @IBOutlet weak var mainPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
     var countries = [CountriModel]()
     var states = [StateModel]()
    
     var cities = [CityModel]()
    @IBOutlet weak var ivBackground: UIImageView!
    
    
    @IBOutlet weak var lbTitle: UILabel!
    
    @IBOutlet weak var lbCountry: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbCity: UILabel!
    
    var selectView = ""
    var city_id = ""
    var state_id = ""
    var country_id = ""
    var isclick = true
    
    var type = ""
    var city = ""
    var state = ""
    var country = ""
    
    var filterCity = [CityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      //  self.pickerView.delegate = self
       // self.pickerView.dataSource = self//
      //  mainPickerView.isHidden = true
        Utils.setImageFromUrl(imageView: ivBackground, urlString: UserDefaults.standard.string(forKey: StringConstants.KEY_BACKGROUND_IMAGE)!)
        doLocation()
     }
    
    @IBAction func onClickCountry(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
       type =  "country"
        vc.type = type
        vc.countries = countries
        vc.selectLocationVC = self
      //  vc.isEmergancy = false
       // vc.ownedDataSelectVC = self
     //   vc.isProfile = false//
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
       
    }
    
    @IBAction func onClickState(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
        type =  "state"
        vc.type = type
        vc.states = states
         vc.selectLocationVC = self
        //  vc.isEmergancy = false
        // vc.ownedDataSelectVC = self
        //   vc.isProfile = false//
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
       
    }
    
    @IBAction func onClickCity(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idDailogLocationVC") as! DailogLocationVC
       type =  "city"
        vc.type = type
        
        if state_id == "" {
            vc.cities = cities
        } else {
           vc.cities = filterCity
        }
        
         vc.selectLocationVC = self
        vc.state_id = state_id
        //  vc.isEmergancy = false
        // vc.ownedDataSelectVC = self
        //   vc.isProfile = false//
        vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.addChild(vc)
        self.view.addSubview(vc.view)
       
       
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        isclick = true
        mainPickerView.isHidden = true
    }
    func doLocation() {
        showProgress()
       
        let params = ["key":apiKey(),
                      "getCountries":"getCountries"]
        
        
        
        
        print("param" , params)
        
        let requrest = AlamofireSingleTon.sharedInstance
        
        
        requrest.requestPostMain(serviceName: ServiceNameConstants.LOCATION_CONTROLLER, parameters: params) { (json, error) in
              self.hideProgress()
            if json != nil {
              
                do {
                    let response = try JSONDecoder().decode(ReposneLocation.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        self.doSetArrayData(reposneLocation: response)
                        
                       
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                    
                    
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
   func doSetArrayData(reposneLocation:ReposneLocation) {
    
    
    if reposneLocation.countries != nil {
        self.countries.append(contentsOf: reposneLocation.countries!)
        
        for country in (0..<reposneLocation.countries.count) {
            
            if reposneLocation.countries[country].states != nil {
                self.states.append(contentsOf: reposneLocation.countries[country].states)
                
                for state in (0..<reposneLocation.countries[country].states.count) {
                    
                    
                    if reposneLocation.countries[country].states[state].cities != nil {
                        self.cities.append(contentsOf: reposneLocation.countries[country].states[state].cities)
                    }
                    
                }
            }
            
        }
        
    }
   
    
    
    
    }

    @IBAction func onClickNext(_ sender: Any) {
        if isValide() {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
            vc.city_id = city_id
            vc.state_id = state_id
            vc.country_id = country_id
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
    func isValide() -> Bool {
        var isValid = true
        
        if country_id == "" {
            showAlertMessage(title: "", msg: "Select Country")
            isValid  = false
        }
        if state_id == "" {
            showAlertMessage(title: "", msg: "Select State")
            isValid  = false
        }
        if city_id == "" {
            showAlertMessage(title: "", msg: "Select City")
            isValid  = false
        }
        return isValid
    }
    
    override func viewDidLayoutSubviews() {
        
        //print(country_id)
       // print(city_id)
      //  print(state_id)
        if type == "country" {
             lbCountry.text = country
        } else if type == "city" {
            lbCity.text = city
        } else if type == "state" {
            lbState.text = state
            doFilterCity()
        }

        
    }
   func doFilterCity() {
    
    if filterCity.count > 0 {
        filterCity.removeAll()
    }
    
    for i in (0..<cities.count) {
        
        if cities[i].state_id == state_id {
            filterCity.append(cities[i])
        }
        
    }
   
  // let sortedNames = filterCity.sorted(by: )
   // print(sortedNames)
    
 // filterCity =   filterCity.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
    
    }
    
}

