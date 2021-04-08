//
//  ChangeStatusVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 19/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class ChangeStatusVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwGoing: UIView!
    @IBOutlet weak var vwFoodDelivered: UIView!
    @IBOutlet weak var vwFoodReceived: UIView!
    @IBOutlet weak var vwInRoute: UIView!
    @IBOutlet weak var vwDone: UIView!

    @IBOutlet weak var lblGoing: UILabel!
    @IBOutlet weak var lblFoodReceived: UILabel!
    @IBOutlet weak var lblInRoute: UILabel!

    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var imgGoing: UIImageView!
    @IBOutlet weak var imgFoodReceived: UIImageView!
    @IBOutlet weak var imgFoodInRoute: UIImageView!
    @IBOutlet weak var imgFoodDelivered: UIImageView!

    
    @IBOutlet weak var btnGoing: UIButton!
    @IBOutlet weak var btnFoodReceived: UIButton!
    @IBOutlet weak var btnFoodInRoute: UIButton!
    @IBOutlet weak var btnFoodDelivered: UIButton!
    
    // Localization OUtlets -
    
    @IBOutlet weak var lblChangeStatus: UILabel!
    @IBOutlet weak var lblLOGoingToRestorent: UILabel!
    @IBOutlet weak var lblLOFoodRecived: UILabel!
    @IBOutlet weak var lblLORoute: UILabel!
    @IBOutlet weak var lblLOFoodDelived: UILabel!
    

    
    // MARK: - Varibles
    
    var closerHideBottambar:((_ isClearList:Bool)   ->())?
    var strCurrentStatus = ""
    var strOrderId = ""
    
    var objOrderTracking:OrderTracking?
    var arrOrderTracking:[OrderTracking] = []

     //var isFromForgroundNotification = false
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.localization()
        
        objAppShareData.isOnMapScreen = true
       // self.imgFoodDelivered.image = #imageLiteral(resourceName: "inactive_tick_ico")
        self.vwBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.vwDone.setButtonVerifyView(vwOuter: self.vwDone, btn: self.btnDone,viewRadius:Int(20), btnRadius:Int(17.5))
        self.vwGoing.setCornerRadius(radius: 8)
        self.vwFoodDelivered.setCornerRadius(radius: 8)
        self.vwFoodReceived.setCornerRadius(radius: 8)
        self.vwInRoute.setCornerRadius(radius: 8)
        self.tabBarController?.tabBar.isHidden = true
        
       NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshUI"), object: nil, queue: nil) { [weak self](Notification) in
                               //self?.isFromForgroundNotification = true
                             self?.callWsForGetNewOrder()
                           }
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)

        self.checkStatus()
         self.checkTime()

    }
    override func viewWillDisappear(_ animated: Bool) {
                  super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
                  objAppShareData.isOnMapScreen = false
        NotificationCenter.default.removeObserver(self)

              }
    
    @objc func updateUI(){
        self.callWsForGetNewOrder()
    }
    
    func checkTime(){
        
        print(  "self.arrOrderTracking count is vc is \(self.arrOrderTracking.count)")

               
               if self.arrOrderTracking.count == 1 {
                  // let date = objAppShareData.changeDateformatWithDate(strDate: self.arrOrderTracking[0].strCreatedTime )
                let date = objAppShareData.convertLocalTime(strDateTime: self.arrOrderTracking[0].strCreatedTime)
                    self.lblGoing.text = date
                    self.lblInRoute.isHidden = true
                    self.lblFoodReceived.isHidden = true
               }else if self.arrOrderTracking.count == 2{
                   let date = objAppShareData.convertLocalTime(strDateTime: self.arrOrderTracking[0].strCreatedTime)
                   self.lblGoing.text = date
                   let date1 = objAppShareData.convertLocalTime(strDateTime: self.arrOrderTracking[1].strCreatedTime)
                   self.lblFoodReceived.text = date1
                
                self.lblInRoute.isHidden = true
                self.lblFoodReceived.isHidden = false
                               
               }else if self.arrOrderTracking.count == 3{
                   
                    let date = objAppShareData.convertLocalTime(strDateTime: self.arrOrderTracking[0].strCreatedTime)
                    self.lblGoing.text = date
                    let date1 = objAppShareData.convertLocalTime(strDateTime: self.arrOrderTracking[1].strCreatedTime)
                    self.lblFoodReceived.text = date1
                    let date2 = objAppShareData.convertLocalTime(strDateTime: self.arrOrderTracking[2].strCreatedTime)
                    self.lblInRoute.text = date2
              
                self.lblGoing.isHidden = false
                self.lblInRoute.isHidden = false
                self.lblFoodReceived.isHidden = false
                   
               }else{
                   
               }
        
    }
    
    
    
    
    func checkStatus(){
       // active_tick_ico
        print(  "self.strCurrentStatus in change status vc is \(self.strCurrentStatus)")

        //        if self.strCurrentStatus == "3"{
        //
        //        }
                
        
        if self.strCurrentStatus == "1" || self.strCurrentStatus == "2" || self.strCurrentStatus == "3" {

            self.imgGoing.image = #imageLiteral(resourceName: "tick_ico")
            self.btnFoodReceived.isUserInteractionEnabled = true
            self.btnFoodInRoute.isUserInteractionEnabled = false
            self.btnFoodDelivered.isUserInteractionEnabled = false
          //  self.btnDone.isUserInteractionEnabled = false
            //self.strCurrentStatus = "3"
        }
        

               else if self.strCurrentStatus == "4"{
                    self.imgGoing.image = #imageLiteral(resourceName: "tick_ico")
                    self.imgFoodReceived.image = #imageLiteral(resourceName: "tick_ico")

        self.btnGoing.isUserInteractionEnabled = false
        self.btnFoodReceived.isUserInteractionEnabled = false
        self.btnFoodInRoute.isUserInteractionEnabled = true
        self.btnFoodDelivered.isUserInteractionEnabled = false
        //self.btnDone.isUserInteractionEnabled = false
            
                }
          
         else if self.strCurrentStatus == "5"{
            self.imgGoing.image = #imageLiteral(resourceName: "tick_ico")
            self.imgFoodReceived.image = #imageLiteral(resourceName: "tick_ico")
            self.imgFoodInRoute.image = #imageLiteral(resourceName: "tick_ico")
        self.btnGoing.isUserInteractionEnabled = false
        self.btnFoodReceived.isUserInteractionEnabled = false
        self.btnFoodInRoute.isUserInteractionEnabled = false
        self.btnFoodDelivered.isUserInteractionEnabled = true
       // self.btnDone.isUserInteractionEnabled = false
            
                }
        
       else if self.strCurrentStatus == "6"{
                 self.imgGoing.image = #imageLiteral(resourceName: "tick_ico")
                 self.imgFoodReceived.image = #imageLiteral(resourceName: "tick_ico")
                 self.imgFoodInRoute.image = #imageLiteral(resourceName: "tick_ico")
                self.imgFoodDelivered.image = #imageLiteral(resourceName: "tick_ico")
             self.btnGoing.isUserInteractionEnabled = false
             self.btnFoodReceived.isUserInteractionEnabled = false
             self.btnFoodInRoute.isUserInteractionEnabled = false
             self.btnFoodDelivered.isUserInteractionEnabled = false
             self.btnDone.isUserInteractionEnabled = false

            
            self.setRootNavigation()
//            self.closerHideBottambar?(true)
//            self.dismiss(animated: false, completion: nil)

            
                     }
        
        else {
            self.imgGoing.image = #imageLiteral(resourceName: "inactive_tick_ico")
        }
        
    }
    func localization(){
        
        self.lblChangeStatus.text = "Change_Status".localize
        self.lblLOGoingToRestorent.text = "Going_To_Restaurant".localize
        self.lblLOFoodRecived.text = "Food_Received".localize
        self.lblLORoute.text = "In_Route".localize
        self.lblLOFoodDelived.text = "Food_Delivered".localize
        
        self.btnDone.setTitle("Done".localize, for: .normal)

        
    }
    
    
       // MARK: - Buttons Action

       @IBAction func btnCancelAction(_ sender: UIButton) {
           self.view.endEditing(true)
        self.tabBarController?.tabBar.isHidden = false
     //   self.navigationController?.popViewController(animated: false)
        
        self.closerHideBottambar?(true)
        self.dismiss(animated: false, completion: nil)

       }
    
    @IBAction func btnGoingAction(_ sender: UIButton) {
        self.view.endEditing(true)
       //  objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)

    }
    
    @IBAction func btnFoodRecievedAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
        print(  "self.strCurrentStatus in btnFoodRecievedAction is \(self.strCurrentStatus)")

        if  self.strCurrentStatus != "3" {
            
            objAlert.showAlert(message: "food_is_being_prepared".localize, title: kAlert.localize, controller: self)
            
        }else {
        if sender.tag == 0 {
                   self.imgFoodReceived.image = #imageLiteral(resourceName: "active_check_box_ico")
                   sender.tag = 1
                self.btnDone.isUserInteractionEnabled = true

               }else{
                   self.imgFoodReceived.image = #imageLiteral(resourceName: "inactive_tick_ico")
                   sender.tag = 0
               }
    }
    }
    
    @IBAction func btnInRouteAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
        print(  "self.strCurrentStatus in btnInRouteAction is \(self.strCurrentStatus)")

        if sender.tag == 0 {
                   self.imgFoodInRoute.image = #imageLiteral(resourceName: "active_check_box_ico")
                   sender.tag = 1
                self.btnDone.isUserInteractionEnabled = true

               }else{
                   self.imgFoodInRoute.image = #imageLiteral(resourceName: "inactive_tick_ico")
                   sender.tag = 0
               }
    }
          
    
    @IBAction func btnFoodDelevierdAction(_ sender: UIButton) {
        self.view.endEditing(true)
        print(  "self.strCurrentStatus in btnFoodDelevierdAction is \(self.strCurrentStatus)")

        if sender.tag == 0 {
            self.imgFoodDelivered.image = #imageLiteral(resourceName: "active_check_box_ico")
            sender.tag = 1
            self.btnDone.isUserInteractionEnabled = true

          //  self.strStatus = "5"
           // print("strStatus is  \(self.strStatus)")
            
        }else{
            self.imgFoodDelivered.image = #imageLiteral(resourceName: "inactive_tick_ico")
            sender.tag = 0
        }

        
    }
    
    @IBAction func btnDoneAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        print(  "self.strCurrentStatus in btnDoneAction is \(self.strCurrentStatus)")

        if  self.imgFoodReceived.image != #imageLiteral(resourceName: "active_check_box_ico")  && self.imgFoodReceived.image != #imageLiteral(resourceName: "tick_ico") {
           // objAlert.showAlert(message: "Please select food received option", title: kAlert, controller: self)
            objAlert.showAlert(message: "Please_complete_your_step".localize, title: kAlert.localize, controller: self)

        } else if  self.imgFoodReceived.image == #imageLiteral(resourceName: "active_check_box_ico") {
            print("in api pass 4")
           // self.strCurrentStatus = "4"
            
            self.callWsForChangeOrderStatus(status: "4")
        }
        
         else if  self.imgFoodInRoute.image != #imageLiteral(resourceName: "active_check_box_ico")  && self.imgFoodInRoute.image != #imageLiteral(resourceName: "tick_ico") {
          //  objAlert.showAlert(message: "Please select food inroute option", title: kAlert, controller: self)
            objAlert.showAlert(message: "Please_complete_your_step".localize, title: kAlert.localize, controller: self)

        } else if  self.imgFoodInRoute.image == #imageLiteral(resourceName: "active_check_box_ico") {
            print("in api pass 5")
           // self.strCurrentStatus = "5"
            self.callWsForChangeOrderStatus(status: "5")
        }
        
          else if  self.imgFoodDelivered.image != #imageLiteral(resourceName: "active_check_box_ico")  && self.imgFoodDelivered.image != #imageLiteral(resourceName: "tick_ico") {
            //objAlert.showAlert(message: "Please select food delivered option", title: kAlert, controller: self)
            objAlert.showAlert(message: "Please_complete_your_step".localize, title: kAlert.localize, controller: self)

        }else{
            self.callWsForChangeOrderStatus(status: "6")
              print("in api pass 6")
           // self.strCurrentStatus = "6"
        }
       // self.checkStatus()
    }
}


extension ChangeStatusVC {
// TODO: Webservice For change Order Status
    func callWsForChangeOrderStatus(status:String){
    
    if !objWebServiceManager.isNetworkAvailable(){
        objWebServiceManager.StopIndicator()
        objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
        return
    }
    objWebServiceManager.StartIndicator()
    
    var param: [String: Any] = [:]
    param = [
        WsParam.orderID: self.strOrderId,
        WsParam.currentStatus : status
        ] as [String : Any]
    
    print(param)
    
    objWebServiceManager.requestPost(strURL: WsUrl.changeOrderStatus, params: param, strCustomValidation: "", showIndicator: false, success: {response in
        print(response)
        objWebServiceManager.StopIndicator()
        let status =   (response["status"] as? String)
        let message =  (response["message"] as? String)
        
        if status == "success"{
            
            let dic  = response["data"] as? [String:Any]
            
            
            if let currentStatus = dic?["current_status"]as? String{
              
                self.strCurrentStatus = currentStatus
                
                 print(  "currentStatus is \(currentStatus)")
                
                if currentStatus == "6" {
                    self.setRootNavigation()

                }else{
                    
                    //
                    self.closerHideBottambar?(true)
                    self.dismiss(animated: false, completion: nil)
                    self.tabBarController?.tabBar.isHidden = false
                    //
                    
                }
            }
            
                           if let arrTrackingData = dic?["order_tracking"] as? [[String: Any]]{
                            self.arrOrderTracking.removeAll()

                               for dictTrackingData in arrTrackingData
                               {
                                   let objData = OrderTracking.init(dict: dictTrackingData)
                                   self.arrOrderTracking.append(objData)
                               }
                               print("self.arrOrderTracking.count is \(self.arrOrderTracking.count)")
                            self.checkTime()
                           }
            
            self.checkStatus()
            
        }
        else
        {
            objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
        }
        
        
    }, failure: { (error) in
        print(error)
        objWebServiceManager.StopIndicator()
        objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        
    })
}
    
    func setRootNavigation(){
        
        objAppDelegate.showFoodDeliveryTabbar()
        

    }
}


// TODO: Webservice For get current status
extension ChangeStatusVC {
        
        func callWsForGetNewOrder(){
            
            if !objWebServiceManager.isNetworkAvailable(){
                objWebServiceManager.StopIndicator()
                objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
                return
            }
           // objWebServiceManager.StartIndicator()
//            if  self.isFromForgroundNotification != true{
//                   objWebServiceManager.StartIndicator()
//                   }
            objWebServiceManager.requestGet(strURL: WsUrl.newOrder  ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
                print(response)
                
                let status =   (response["status"] as? String)
              //  let message =  (response["message"] as? String)
                
                if status == "success" {
                    
                   
                    let dic  = response["data"] as? [String:Any]

            
                    if let orderDetail = dic?["new_order"] as? [String:Any]{
                                                
                        if let currentStatus = orderDetail["current_status"]as? String{
                                   print(  "currentStatus is new order api  \(currentStatus)")
                                     self.strCurrentStatus = currentStatus
                               }
                        
                    }
                    
                }else{
                    
                    
                    // objAlert.showAlert(message:message ?? "", title: "Alert", controller: self)
                }
            }, failure: { (error) in
                print(error)
                objWebServiceManager.StopIndicator()
                objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
                
            })
            
        }
    
}
