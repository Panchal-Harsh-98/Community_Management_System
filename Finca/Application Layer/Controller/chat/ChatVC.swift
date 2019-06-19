//
//  ChatVC.swift
//  Finca
//
//  Created by anjali on 13/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit


struct ResponseChat : Codable {
    let status:String!// "status" : "200",
    let message:String!// "message" : "Get chat success."
    let chat:[ChatModel]!
}

struct ChatModel : Codable {
    let msg_for:String!  //"msg_for" : "410",
     let my_msg:String! //"my_msg" : "0",
    let msg_date:String! // "msg_date" : "2 hours ago",
     let society_id:String! //"society_id" : "48",
    let msg_status:String! // "msg_status" : "0",
    let msg_by:String!  //"msg_by" : "411",
     let chat_id:String! //"chat_id" : "110",
     let msg_data:String!// "msg_data" : "hi",
     let msg_delete:String!// "msg_delete" : "0"
    
}


struct ResponseCommonMessage:Codable {
      let message:String!//"message" : "chat added success.",
     let status:String!// "status" : "200"
}

class ChatVC: BaseVC {
    @IBOutlet weak var bBack: UIButton!
    @IBOutlet weak var tbvData: UITableView!
    
    @IBOutlet weak var ivProfile: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    
    @IBOutlet weak var tfMessage: UITextField!
    var itemCellRecieved = "RecievedCell"
    var itemCellSend = "SendChatCell"
     var unitModelMember:UnitModelMember!
     var chats = [ChatModel]()
     var isFirsttime = true
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    changeButtonImageColor(btn: bBack, image: "back", color: UIColor.white)
        
        tbvData.delegate = self
        tbvData.dataSource = self
        tbvData.separatorStyle = .none
        tbvData.estimatedRowHeight = 110
        tbvData.rowHeight = UITableView.automaticDimension
        
        tbvData.sectionIndexBackgroundColor = UIColor.clear
        let inb = UINib(nibName: itemCellSend, bundle: nil)
        tbvData.register(inb, forCellReuseIdentifier: itemCellSend)
        let inbRecieved = UINib(nibName: itemCellRecieved, bundle: nil)
        tbvData.register(inbRecieved, forCellReuseIdentifier: itemCellRecieved)
        
        Utils.setImageFromUrl(imageView: ivProfile, urlString: unitModelMember.user_profile_pic)
        Utils.setRoundImage(imageView: ivProfile)
        lbUserName.text = unitModelMember.user_full_name
        doGetChat(isRefresh: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
       
        
          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        hideKeyBoardHideOutSideTouch()
        tfMessage.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControl.Event.valueChanged)
        tbvData.addSubview(refreshControl)
        
    }
    
    @objc func refresh(sender:AnyObject) {
           self.doGetChat(isRefresh: true)
    }
    
    @IBAction func onClickSendMesage(_ sender: Any) {
        
        if tfMessage.text != "" {
            doSendMessage()
        }
        
    }
    
    func doGetChat(isRefresh:Bool) {
        if isFirsttime {
            showProgress()
        }
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "getPrvChat":"getPrvChat",
                      "user_id":doGetLocalDataUser().user_id!,
                      "userId":unitModelMember.user_id!,
                      "society_id":unitModelMember.society_id!,
                      "sentTo":"0"]
        
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chatController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                
                if isRefresh {
                    self.refreshControl.endRefreshing()
                }
                do {
                    let response = try JSONDecoder().decode(ResponseChat.self, from:json!)
                    
                    
                    if response.status == "200" {
                        
                        if self.chats.count > 0 {
                            self.chats.removeAll()
                            self.tbvData.reloadData()
                        }
                        
                        self.chats.append(contentsOf: response.chat)
                        self.tbvData.reloadData()
                        self.scrollToBottom()
                        self.isFirsttime = false
                       
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }
    
    func doSendMessage() {
        
        //let device_token = UserDefaults.standard.string(forKey: ConstantString.KEY_DEVICE_TOKEN)
        let params = ["key":AlamofireSingleTon.sharedInstance.key,
                      "addChat":"addChat",
                      "msg_by":doGetLocalDataUser().user_id!,
                      "msg_for":unitModelMember.user_id!,
                      "msg_data":tfMessage.text!,
                      "unit_name":doGetLocalDataUser().unit_name!,
                      "society_id":unitModelMember.society_id!,
                      "sentTo":"0"]
        
        
        print("param" , params)
        let requrest = AlamofireSingleTon.sharedInstance
        requrest.requestPost(serviceName: ServiceNameConstants.chatController, parameters: params) { (json, error) in
            
            if json != nil {
                self.hideProgress()
                do {
                    let response = try JSONDecoder().decode(ResponseCommonMessage.self, from:json!)
                    
                    
                    if response.status == "200" {
                       /* self.chats.append(ChatModel(msg_for: "",my_msg: "1",msg_date: "",society_id: "",msg_status: "",msg_by: "",chat_id: "",msg_data: self.tfMessage.text!,msg_delete: ""))
                        self.tbvData.reloadData()
                        self.tfMessage.text = ""
                        self.scrollToBottom()*/
                        self.tfMessage.text = ""
                        self.doGetChat(isRefresh: false)
                        
                    }else {
                        self.showAlertMessage(title: "Alert", msg: response.message)
                    }
                } catch {
                    print("parse error")
                }
            }
        }
        
    }

    @IBAction func onClickBack(_ sender: Any) {
        doPopBAck()
    }
    
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return view.endEditing(true)
    }
    
    @objc  func keyboardWillShow(sender: NSNotification) {
        let userInfo:NSDictionary = sender.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.view.frame.origin.y = -keyboardHeight // Move view 150 points upward
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    

}
extension ChatVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if chats[indexPath.row].my_msg == "0" {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellRecieved, for: indexPath) as! RecievedCell
            cell.backgroundColor = UIColor.clear
            
            cell.lbMessage.text = chats[indexPath.row].msg_data
            cell.lbTime.text = chats[indexPath.row].msg_date
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: self.itemCellSend, for: indexPath) as! SendChatCell
        cell.backgroundColor = UIColor.clear
        cell.lbMessage.text = chats[indexPath.row].msg_data
        cell.lbTime.text = chats[indexPath.row].msg_date
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.chats.count-1, section: 0)
            self.tbvData.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
}
