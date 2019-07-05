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
    
    @IBOutlet weak var lbCity: UILabel!
    @IBOutlet weak var lbState: UILabel!
    @IBOutlet weak var lbCoutry: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    var selectView = ""
   var city_id = ""
   var state_id = ""
   var country_id = ""
    var isclick = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        mainPickerView.isHidden = true
        doLocation()
    }
    
    @IBAction func onClickCountry(_ sender: Any) {
        if isclick {
           isclick = false
            selectView = "country"
            lbTitle.text = "Country"
            mainPickerView.isHidden = false
              pickerView.selectRow(0, inComponent: 0, animated: true)
             pickerView.reloadAllComponents()
        }
       
    }
    
    @IBAction func onClickState(_ sender: Any) {
        if isclick {
            isclick = false
            selectView = "state"
            lbTitle.text = "State"
            mainPickerView.isHidden = false
              pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.reloadAllComponents()
        }
       
    }
    
    @IBAction func onClickCity(_ sender: Any) {
        if isclick {
            isclick = false
            selectView = "city"
            lbTitle.text = "Cities"
            mainPickerView.isHidden = false
            pickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView.reloadAllComponents()
        }
       
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
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ReposneLocation.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                     self.countries.append(contentsOf: response.countries)
                     self.lbCoutry.text = self.countries[0].name
                     self.country_id = self.countries[0].country_id
                     
                    self.states.append(contentsOf: response.countries[0].states)
                    self.lbState.text = self.countries[0].states[0].name
                    self.state_id = self.countries[0].states[0].state_id
                        
                       self.cities.append(contentsOf: response.countries[0].states[0].cities)
                        self.lbCity.text = self.countries[0].states[0].cities[0].name
                        self.city_id = self.countries[0].states[0].cities[0].city_id
                        
                        
                    self.pickerView.reloadAllComponents()
                    
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }

    @IBAction func onClickNext(_ sender: Any) {
   let vc  = self.storyboard?.instantiateViewController(withIdentifier: "idSocietyVC") as! SocietyVC
         vc.city_id = city_id
         vc.state_id = state_id
         vc.country_id = country_id
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }
    
}

extension SelectLocationVC: UIPickerViewDelegate, UIPickerViewDataSource  {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectView == "state" {
         return  states.count
        }
        if selectView == "city" {
             return  cities.count
        }
        
       return countries.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectView == "state" {
             return states[row].name
        }
        
       if selectView == "city" {
            return cities[row].name
        }
        
        return countries[row].name
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectView == "country" {
            country_id = countries[row].country_id
            lbCoutry.text = countries[row].name
            if self.states.count > 0 {
                self.states.removeAll()
            }
            self.states.append(contentsOf: countries[row].states)
            self.lbState.text = self.countries[row].states[0].name
            self.state_id = self.countries[row].states[0].state_id
            
            
        } else if selectView == "state" {
            self.lbState.text = self.states[row].name
            self.state_id = self.states[row].state_id
            
            if self.cities.count > 0 {
                self.cities.removeAll()
            }
            self.cities.append(contentsOf: self.states[row].cities)
             self.lbCity.text = self.states[row].cities[0].name
            self.city_id = self.states[row].cities[0].city_id
            
        } else if selectView == "city"{
            
            self.lbCity.text = self.cities[row].name
            self.city_id = self.cities[row].city_id
        }
        
        
    }
    
   
}
