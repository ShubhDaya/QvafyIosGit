//
//  VerifyBankVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 17/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import WebKit

class VerifyBankVC: UIViewController ,WKNavigationDelegate{


    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var webkitView: WKWebView!

    @IBOutlet weak var lblVerifyBankDetail: UILabel!
    
    
    var strURL: String = ""
    var strHeaderText: String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.viewAdd.setButtonView(vwOuter : self.viewAdd , vwImage : self.viewImgAdd, btn: self.btnAdd)

        self.vwBack.setCornerRadius(radius: 8)
      //  self.viewHeader.isHidden = true
        
        if let url = URL(string: strURL) {

            let request = URLRequest(url: url)
            
            self.webkitView.navigationDelegate = self

            self.webkitView.load(request)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblVerifyBankDetail.text =  "Verified_Bank_Betails".localize
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

    //MARK:- WKNavigationDelegate


        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

            if let text = webView.url?.absoluteString {
                print(text)

                if (text == "https://dev.qvafy.com/payment/account-verify/success" || text == "https://dev.qvafy.com/payment/account-verify/fail") || (text == "https://www.qvafy.com/payment/account-verify/success" || text == "https://www.qvafy.com/payment/account-verify/fail")
                || (text.contains("success") || text.contains("fail")){
                self.navigationController?.popViewController(animated: true)

                }
            }
        }
}


