//
//  PolicyVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 17/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//
import UIKit
import WebKit

class PolicyVC: UIViewController ,WKNavigationDelegate{

    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var webkitView: WKWebView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    
    var strURL: String = ""
    var strHeaderText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    self.vwHeader.setviewbottomShadow()
        self.lblHeader.text = strHeaderText
        if let url = URL(string: strURL) {

            let request = URLRequest(url: url)
            
            self.webkitView.navigationDelegate = self

            self.webkitView.load(request)
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    //MARK:- WKNavigationDelegate


        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        }
}


