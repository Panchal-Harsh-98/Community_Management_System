//
//  DailogLocationVC.swift
//  Finca
//
//  Created by anjali on 11/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DailogLocationVC: BaseVC {
    
    
    
    
    var type:String!
    var state_id:String!
    
    var itemCell = "LocationCell"
    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var tbvData: UITableView!
    var selectedIndex : String!
   
    
    var countries = [CountriModel]()
    var filterCountries = [CountriModel]()
    
    var selectLocationVC:SelectLocationVC!
    
    
    var states = [StateModel]()
    var filterStates = [StateModel]()
    
    var cities = [CityModel]()
    var filterCities = [CityModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let inb = UINib(nibName: itemCell, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCell)
        
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        
        
        if type == "state" {
             filterStates = states
        } else if type == "country"  {
            filterCountries = countries
        } else if type == "city" {
            filterCities = cities
            //doFilerCity()
        }
            
       
        
       // hideKeyBoardHideOutSideTouch()
        tfSearch.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        tfSearch.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
   
    
   @objc func textFieldDidChange(textField: UITextField) {
    
        //your code
    if type == "state" {
       
     
        filterStates = textField.text!.isEmpty ? states : states.filter({ (item:StateModel) -> Bool in
            
            return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
         tbvData.reloadData()
    } else if type == "country" {
        filterCountries = textField.text!.isEmpty ? countries : countries.filter({ (item:CountriModel) -> Bool in
            
            return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        tbvData.reloadData()
    }else if type == "city" {
        filterCities = textField.text!.isEmpty ? cities : cities.filter({ (item:CityModel) -> Bool in
            
            return item.name.range(of: textField.text!, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        tbvData.reloadData()
    }
   
   
    }
    

    @IBAction func onClickDone(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        self.removeFromParent()
        self.view.removeFromSuperview()

    }
    
    
}

extension DailogLocationVC : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == "state" {
            return  self.filterStates.count
        } else if type == "country"  {
            return self.filterCountries.count
        } else if type == "city" {
            return self.filterCities.count
        }
        
       
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCell, for: indexPath) as! LocationCell
        cell.selectionStyle = .none
        
        
        if type == "state" {
            if selectedIndex == filterStates[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterStates[indexPath.row].name
            
        } else  if type == "country" {
            if selectedIndex == filterCountries[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterCountries[indexPath.row].name
            
        }else  if type == "city" {
            if selectedIndex == filterCities[indexPath.row].name {
                cell.ivImage.image = UIImage(named: "radio-selected")
            } else {
                cell.ivImage.image = UIImage(named: "radio-blank")
            }
            cell.lbTitle.text = filterCities[indexPath.row].name
            
        }
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 30.0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == "state" {
            selectedIndex = filterStates[indexPath.row].name
            selectLocationVC.state_id = filterStates[indexPath.row].state_id
            selectLocationVC.state = filterStates[indexPath.row].name
             //selectItemState(index: indexPath.row, isFirstTime: false)
        } else if type == "country" {
             selectedIndex = filterCountries[indexPath.row].name
             selectLocationVC.country_id = filterCountries[indexPath.row].country_id
              selectLocationVC.country = filterCountries[indexPath.row].name
        }else if type == "city" {
            selectedIndex = filterCities[indexPath.row].name
             selectLocationVC.city_id = filterCities[indexPath.row].city_id
            selectLocationVC.city = filterCities[indexPath.row].name
        }
       
        tableView.reloadData()
        
    }
    
  
}








