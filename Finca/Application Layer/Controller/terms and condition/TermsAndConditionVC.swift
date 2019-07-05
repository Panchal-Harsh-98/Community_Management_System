//
//  TermsAndConditionVC.swift
//  Finca
//
//  Created by anjali on 03/07/19.
//  Copyright © 2019 anjali. All rights reserved.
//

import UIKit
import  WebKit
class TermsAndConditionVC: BaseVC , WKNavigationDelegate {

    @IBOutlet weak var viewWeb: UIView!
       var webView : WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let strUrl  =  "https://www.fincasys.com/TermsAndConditionsAndroid.php"
        
        let url = URL(string: strUrl)
        let myRequest = URLRequest(url: url!)
        
        webView = WKWebView(frame: self.view.frame)
        webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        webView.load(myRequest)
        self.viewWeb.addSubview(webView)
        self.viewWeb.sendSubviewToBack(webView)
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
   
    @IBAction func onClickBack(_ sender: Any) {
       doPopBAck()
    }

}
extension TermsAndConditionVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
