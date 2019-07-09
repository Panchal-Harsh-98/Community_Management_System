//
//  NoticeVC.swift
//  Finca
//
//  Created by anjali on 20/06/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import WebKit
class NoticeVC: BaseVC ,WKNavigationDelegate {
    @IBOutlet weak var viewWebview: UIView!
    var webView : WKWebView!
    
    @IBOutlet weak var bMenu: UIButton!
    @IBOutlet weak var viewChatCount: UIView!
    @IBOutlet weak var lbChatCount: UILabel!
    @IBOutlet weak var viewNotiCount: UIView!
    @IBOutlet weak var lbNotiCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        doInintialRevelController(bMenu: bMenu)
        
        let strUrl = doGetLocalDataUser().base_url + "apAdmin/noticeForAndroid.php?society_id=" + doGetLocalDataUser().society_id
        let url = URL(string: strUrl)
        let myRequest = URLRequest(url: url!)
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        webView.load(myRequest)
        self.viewWebview.addSubview(webView)
        self.viewWebview.sendSubviewToBack(webView)
        
      
        
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgress()
        print(error)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgress()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgress()
        
    }
 

}
extension NoticeVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}

