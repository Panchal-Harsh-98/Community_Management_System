//
//  PollingDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class PollingDetailsVC: BaseVC {
    
    @IBOutlet weak var tbvPollingOptionList: UITableView!
    @IBOutlet weak var btnVoteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tbvHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblPollQuestion: UILabel!
    @IBOutlet weak var lblPollDescription: UILabel!
    
    @IBOutlet weak var btnVote: UIButton!
    @IBOutlet weak var viewThankYou: UIView!
    var selectedCell : Int!
    var pollingDetails : PollingModel!
    var itemCell = "VotingCell"
    var progressBarCell = "PollingProgressbarCell"
    var resultCell = "ElectionWinnerCell"
    var pollingResultList = [PollingResultModel]()
    var pollingOptionList = [PollingOptionModel]()
    @IBOutlet weak var viewThankYouHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        viewThankYou.isHidden = true
        lblPollQuestion.text = pollingDetails.votingQuestion
        lblPollDescription.text = pollingDetails.votingDescription
       
       
        tbvPollingOptionList.bounces = false
        btnVote.isEnabled = false
        if pollingDetails.votingStatus == "0"{
            doGetPollingOptions()
        }else{
            self.tbvHeightConstraint.constant = 0
            self.tbvPollingOptionList.isHidden = true
            self.btnVoteHeightConstraint.constant = 0
            self.btnVote.isHidden = true
            self.viewThankYou.isHidden = false
            doCallResultsApi()
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        tbvHeightConstraint.constant = tbvPollingOptionList.contentSize.height
    }
    
    @IBAction func btnBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddPoll(_ sender: Any) {
        doAddPoll()
    }
    func doAddPoll(){
        print("get polling options")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addVote":"addVote",
                      "voting_id":pollingDetails.votingID!,
                      "unit_id":doGetLocalDataUser().user_id!,
                      "society_id":doGetLocalDataUser().society_id!,
                      "voting_option_id":pollingOptionList[selectedCell].votingOptionID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse  .self, from:json!)
                    if response.status == "200" {
                        self.tbvHeightConstraint.constant = 0
                        self.tbvPollingOptionList.isHidden = false
                        self.btnVoteHeightConstraint.constant = 0
                        self.btnVote.isHidden = true
                        self.viewThankYou.isHidden = false
                        self.toast(message: response.message, type: 0)
                    }else {
                        self.toast(message: response.message, type: 1)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doGetPollingOptions(){
        print("get polling options")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getVotingOptionList":"getVotingOptionList",
                      "voting_id":pollingDetails.votingID!,
                      "unit_id":doGetLocalDataUser().user_id!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(PollingOptionResponse.self, from:json!)
                    if response.status == "200" {
                        
                        if response.votingSubmitted == "201"{
                            self.pollingOptionList.append(contentsOf: response.option)
                            let nib1 = UINib(nibName: self.itemCell, bundle: nil)
                            self.tbvPollingOptionList.register(nib1, forCellReuseIdentifier: self.itemCell)
                            self.tbvPollingOptionList.delegate = self
                            self.tbvPollingOptionList.dataSource = self
                            self.tbvPollingOptionList.tag = 1
                            self.tbvPollingOptionList.reloadData()
                        }else{
                            self.pollingOptionList.append(contentsOf: response.option)
                            self.btnVoteHeightConstraint.constant = 0
                            self.btnVote.isHidden = true
                            self.viewThankYou.isHidden = false
                            let nib2 = UINib(nibName: self.progressBarCell, bundle: nil)
                            self.tbvPollingOptionList.register(nib2, forCellReuseIdentifier: self.progressBarCell)
                            self.tbvPollingOptionList.delegate = self
                            self.tbvPollingOptionList.dataSource = self
                            self.tbvPollingOptionList.tag = 2
                            self.tbvPollingOptionList.reloadData()
                            self.toast(message: "your vote is already submitted!!..", type:2)
                        }
                    }else {
                        self.toast(message: response.message, type: 1)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doCallResultsApi(){
        print("get polling results")
        self.showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getVotingResult":"getVotingResult",
                      "voting_id":pollingDetails.votingID!]
        print("param" , params)
        let request = AlamofireSingleTon.sharedInstance
        request.requestPost(serviceName: ServiceNameConstants.pollingController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(PollingResultResponse.self, from:json!)
                    if response.status == "200" {
                        self.pollingResultList.append(contentsOf: response.result)
                        let nib = UINib(nibName: self.resultCell, bundle: nil)
                        self.tbvPollingOptionList.register(nib, forCellReuseIdentifier: self.resultCell)
                        self.tbvPollingOptionList.delegate = self
                        self.tbvPollingOptionList.dataSource = self
                        self.tbvPollingOptionList.isHidden = false
                        self.tbvPollingOptionList.tag = 3
                        self.tbvPollingOptionList.reloadData()
                        self.viewThankYou.isHidden = true
                        self.viewThankYouHeightConstraint.constant = 0
                    }else {
                        self.toast(message: response.message, type: 1)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
}

extension PollingDetailsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch (tableView.tag) {
        case 1:
            return pollingOptionList.count
            
        case 2:
            return pollingOptionList.count
        case 3:
            return pollingResultList.count
        default:
            return 0
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch (tableView.tag) {
            
        case 1:
            let cell = tbvPollingOptionList.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! VotingCell
            cell.lblNomineeName.text = pollingOptionList[indexPath.row].optionName
            if indexPath.row == selectedCell{
                cell.ImageRadio.image = UIImage(named: "radio-select")
            }else{
                cell.ImageRadio.image = UIImage(named: "radio-blank")
            }
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tbvPollingOptionList.dequeueReusableCell(withIdentifier: progressBarCell, for: indexPath)as! PollingProgressbarCell
            cell.lblOptionName.text = pollingOptionList[indexPath.row].optionName
            
            cell.progressBar.setProgress(Float(pollingOptionList[indexPath.row].votingPer)!/100, animated: false)
            cell.lblPercentageProgress.text = pollingOptionList[indexPath.row].votingPer + " %"
            cell.selectionStyle = .none
            return cell
            
        case 3:
            let cell = tbvPollingOptionList.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)as! ElectionWinnerCell
            cell.lblVoteCount.text = pollingResultList[indexPath.row].givenVote
            cell.lblNomineeName.text = pollingResultList[indexPath.row].optionName
            if indexPath.row == 0{
                
                cell.lblVoteCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.imgWinnerBackground.image = UIImage(named: "winner")
            }else{
                cell.lblVoteCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            cell.selectionStyle = .none
            return cell
            
        default:
            var cell : UITableViewCell!
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (tableView.tag) {
        case 1:
            return 50
        case 2:
            return 40
        case 3:
            return 50
        default:
            return 0
           
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = indexPath.row
        tbvPollingOptionList.reloadData()
        btnVote.isEnabled = true
        
        switch (tableView.tag) {
        case 1:
            selectedCell = indexPath.row
            tbvPollingOptionList.reloadData()
            btnVote.isEnabled = true
            break;
            
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }
}
