//
//  DocumentsVC.swift
//  Finca
//
//  Created by harsh panchal on 25/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit

class DocumentsVC: BaseVC {
    
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var tbvDocuments: UITableView!
    let itemCell = "DocumentCell"
    var Document_List = [DocumentModel]()
    
    let documentInteractionController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doInintialRevelController(bMenu: bMenu)
        let nib = UINib(nibName: itemCell, bundle: nil)
        tbvDocuments.register(nib, forCellReuseIdentifier: itemCell)
        tbvDocuments.delegate = self
        tbvDocuments.dataSource = self
        documentInteractionController.delegate = self
        doGetDocumentData()
    }
    
    func doGetDocumentData(){
        showProgress()
        let params = ["key":ServiceNameConstants.API_KEY,
                      "getDoc":"getDoc",
                      "society_id":doGetLocalDataUser().society_id!,
                      "user_id":doGetLocalDataUser().user_id!]
        
        print("param" , params)
        
        let request = AlamofireSingleTon.sharedInstance
        
        request.requestPost(serviceName: ServiceNameConstants.documentController, parameters: params) { (json, error) in
            self.hideProgress()
            
            if json != nil {
                
                do {
                    
                    let response = try JSONDecoder().decode(DocumentResponse.self, from:json!)
                    if response.status == "200" {
                        
                        self.Document_List.append(contentsOf: response.list)
                        self.tbvDocuments.reloadData()
                    }else {
                        
                    }
                    print(json as Any)
                } catch {
                    print("parse error")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    func storeAndShare(withURLString: String) {
        
        
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        self.showProgress()
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.hideProgress()
                self.share(url: tmpURL)
            }
            }.resume()
        
        
    }
    
    
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
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
extension DocumentsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Document_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbvDocuments.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)as! DocumentCell
        cell.lblDocumentName.text = Document_List[indexPath.row].ducumentName
        cell.mainView.layer.shadowRadius = 5
        cell.mainView.layer.shadowOpacity = 0.4
        cell.mainView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = String(Document_List[indexPath.row].documentFile)
        storeAndShare(withURLString: url)
    }
    
}
extension DocumentsVC: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}
extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
