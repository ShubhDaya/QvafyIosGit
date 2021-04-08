//
//  GuideVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 11/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import WebKit

class GuideVC: UIViewController ,WKNavigationDelegate{

    
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var viewImgAdd: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var webkitView: WKWebView!

    //Loclization
    @IBOutlet weak var lblGuideHowWork: UILabel!
    
   // var strURL: String = "http://design.mindiii.com/gourav/terms/bang/"
    var strURL: String = ""
    var strHeaderText: String = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        self.viewAdd.layer.cornerRadius = 17.5
        self.viewAdd.layer.masksToBounds = true;
        self.viewAdd.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewAdd.layer.shadowOpacity = 0.8
        self.viewAdd.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.viewAdd.layer.shadowRadius = 6.0
        self.viewAdd.layer.masksToBounds = false
         self.btnAdd.layer.cornerRadius = 15
        
        self.callWsForGetContent()
     //   self.vwBack.setCornerRadius(radius: 8)
      //  self.viewHeader.isHidden = true
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lblGuideHowWork.text = "Guide_How_Work".localize
        self.btnAdd.setTitle("Next".localize, for: .normal)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddAction(_ sender: Any) {
        
       // let role = UserDefaults.standard.string(forKey:UserDefaults.KeysDefault.kRole)
        if objAppShareData.UserDetail.strRole == "1"{
           objAppDelegate.showCustomerTabbar()
        } else if objAppShareData.UserDetail.strRole == "2"{
            objAppDelegate.showTexiDriverTabbar()
        }else{
            objAppDelegate.showFoodDeliveryTabbar()
        }
    
    }
    
    
    //MARK:- WKNavigationDelegate


        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        }
}


extension GuideVC {
    // TODO: Webservice For Get Content
    func callWsForGetContent(){
        
        if !objWebServiceManager.isNetworkAvailable(){
             objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        objWebServiceManager.requestGet(strURL: WsUrl.content ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            objWebServiceManager.StopIndicator()
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                if let content = dict?["content_url"] as? [String:Any]{
                    
                    if let faq = content["how_to_work_url"]as? String{
                        self.strURL = faq
                            if let url = URL(string: faq) {
                            let request = URLRequest(url: url)
                            
                            self.webkitView.navigationDelegate = self

                            self.webkitView.load(request)
                        }
                        
                    }
                }
                
                
            }else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
             objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
}
