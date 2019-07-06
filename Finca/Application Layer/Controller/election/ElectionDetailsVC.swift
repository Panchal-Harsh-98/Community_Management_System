//
//  ElectionDetailsVC.swift
//  Finca
//
//  Created by harsh panchal on 27/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import Toast_Swift
class ElectionDetailsVC: BaseVC {
    @IBOutlet weak var tbvWinnerDetailHeightResult: NSLayoutConstraint!
    @IBOutlet weak var tbvWInner: UITableView!
    @IBOutlet weak var lblElectionName: UILabel!
    @IBOutlet weak var lblElectionDescription: UILabel!
    @IBOutlet weak var btnHeightContraints: NSLayoutConstraint!
    @IBOutlet weak var btnElectionActions: UIButton!
    let itemCell = "ElectionWinnerCell"
    let voteCell = "VotingCell"
    var electionDetails : ElectionModel!
    var result_List = [ResultModel]()
    var voting_option_list = [OptionModel]()
    var selectedIndex : Int!
    var previousIndex : Int!
    @IBOutlet weak var viewThankYou: UIView!
    @IBOutlet weak var viewThanksHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTbvheading: UILabel!
    @IBOutlet weak var viewThankYouHeightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(electionDetails.electionStatus!)
        lblElectionName.text = electionDetails.electionName
        lblElectionDescription.text = electionDetails.electionDescription
        switch (electionDetails.electionStatus) {
        case "2":
            self.btnHeightContraints.constant = 0
            self.btnElectionActions.isHidden = true
            getResult(id: electionDetails.electionID)
            break;
        case "0":
            getStatus(electionId: electionDetails.electionID, userID: doGetLocalDataUser().user_id!)
            break;
        default:
            getStatus(electionId: electionDetails.electionID, userID: doGetLocalDataUser().user_id!)
            break;
        }
        self.viewThankYou.isHidden =  true
        self.viewThanksHeightConstraint.constant = 0
        
    }
    
    
    override func viewWillLayoutSubviews() {
        self.tbvWinnerDetailHeightResult.constant = self.tbvWInner.contentSize.height
    }
    
    @IBAction func btnElectionActionsTapped(_ sender: UIButton) {
        switch sender.titleLabel?.text {
        case "APPLY FOR NOMINATION":
            doCallApplyForNomination()
            break;
        case "VOTE":
            doCallRegisterVote()
        default:
            break;
        }
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func doCallRegisterVote(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "addElectionVote":"addElectionVote",
                      "election_id":electionDetails.electionID!,
                      "user_id":doGetLocalDataUser().user_id!,
                      "society_id":doGetLocalDataUser().society_id!,
                      "election_user_id":voting_option_list[selectedIndex].votingID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            if json != nil {
                do {
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.btnElectionActions.isHidden = true
                        self.btnHeightContraints.constant = 0
                        self.tbvWInner.isHidden = true
                        self.tbvWinnerDetailHeightResult.constant = 0
                        self.viewThankYou.isHidden =  false
                        self.viewThanksHeightConstraint.constant = 215
                        self.view.makeToast(response.message, duration: 2, position: .bottom, style: self.successStyle)
                    }else {
                        self.view.makeToast(response.message, duration: 2, position: .bottom, style: self.failureStyle)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func getResult(id : String!){
        
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getElectionResult":"getElectionResult",
                      "election_id":id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(ElectionResultResponse.self, from:json!)
                    if response.status == "200" {
                        let nib = UINib(nibName: self.itemCell, bundle: nil)
                        self.lblTbvheading.text = "Results"
                        self.lblTbvheading.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                        self.tbvWInner.register(nib, forCellReuseIdentifier: self.itemCell)
                        self.tbvWInner.delegate = self
                        self.tbvWInner.dataSource = self
                        self.tbvWInner.tag = 100
                        self.result_List.append(contentsOf: response.result)
                        self.tbvWInner.reloadData()
                        
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func doCallApplyForNomination(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "ApplyForNomination":"ApplyForNomination",
                      "election_id":electionDetails.electionID!,
                      "user_id":doGetLocalDataUser().user_id!,
                      "society_id":doGetLocalDataUser().society_id!,
                      "unit_id":doGetLocalDataUser().unit_id!,
                      "user_name":doGetLocalDataUser().user_full_name!]
        
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        self.btnElectionActions.titleLabel?.text = "VOTE"
                        self.btnElectionActions.isHidden = true
                        self.btnHeightContraints.constant = 0
                        self.view.makeToast(response.message,duration:2,position:.bottom,style:self.successStyle)
                    }else { self.view.makeToast(response.message,duration:2,position:.bottom,style:self.failureStyle)
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    func getStatus(electionId:String!,userID:String!){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "ApplyStatus":"ApplyStatus",
                      "election_id":electionId!,
                      "user_id":userID!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(CommonResponse.self, from:json!)
                    if response.status == "200" {
                        if self.electionDetails.electionStatus! == "1"{
                            self.btnElectionActions.isHidden = true
                            self.btnHeightContraints.constant = 0
                            self.doGetOptions()
                        }else{
                            self.btnElectionActions.isHidden = true
                            self.btnHeightContraints.constant = 0
                            self.view.makeToast("Waiting For Nomination Approval !!",duration:2,position:.bottom,style:self.successStyle)
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
    
    func doGetOptions(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getElectionOptionList":"getElectionOptionList",
                      "election_id":electionDetails.electionID!,
                      "user_id":doGetLocalDataUser().user_id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.electionController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(VotingOptionResponse.self, from:json!)
                    if response.status == "200" {
                        if response.votingSubmitted == "201"{
                            let nib = UINib(nibName: self.voteCell, bundle: nil)
                            self.tbvWInner.register(nib, forCellReuseIdentifier: self.voteCell)
                            self.voting_option_list.append(contentsOf: response.option)
                            self.tbvWInner.tag = 101
                            self.btnHeightContraints.constant = 45
                            self.btnElectionActions.isHidden = false
                            self.btnElectionActions.setTitle("VOTE", for: .normal)
                            self.tbvWInner.delegate = self
                            self.tbvWInner.dataSource = self
                            self.tbvWInner.reloadData()
                        }else{
                            self.view.makeToast("Your vote is already submitted!!..", duration: 2, position: .bottom, style: self.warningStyle)
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
}
extension ElectionDetailsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (tableView.tag) {
        case 100:
            return result_List.count
        case 101:
            return voting_option_list.count
        default:
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        
        if tableView.tag == 100{
           let cell = tbvWInner.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! ElectionWinnerCell
            cell.lblVoteCount.text = result_List[indexPath.row].givenVote
            cell.lblNomineeName.text = result_List[indexPath.row].optionName
            
            if indexPath.row == 0{
                
                cell.lblVoteCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                cell.imgWinnerBackground.image = UIImage(named: "winner")
            }else{
                cell.lblVoteCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
            cell.selectionStyle = .none
            return cell
        }else if tableView.tag == 101 {
            let cell = tbvWInner.dequeueReusableCell(withIdentifier: voteCell, for: indexPath)as! VotingCell
            cell.lblNomineeName.text = voting_option_list[indexPath.row].optionName
            if indexPath.row == selectedIndex{
                cell.ImageRadio.image = UIImage(named: "radio-select")
            }else{
                cell.ImageRadio.image = UIImage(named: "radio-blank")
            }
            cell.selectionStyle = .none
            return cell
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView.tag {
        case 100:
            
            break;
        case 101:
            selectedIndex = indexPath.row
            
            tbvWInner.reloadData()
            break;
        default:
            break
        }
    }
}
