//  NotificationVC.swift
//  Qvafy
//  Created by ios-deepak b on 25/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.

import UIKit
import SlideMenuControllerSwift
var currentDateTime = ""
class NotificationVC: UIViewController {
 
    //MARK: Outlets
    
    @IBOutlet weak var vwSideMenu: UIView!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var vwNoRecord: UIView!
    @IBOutlet weak var tblNotificationList: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwChat: UIView!
    @IBOutlet weak var lblChatCount: UILabel!
    //localisation -
    @IBOutlet weak var lblNOtification: UILabel!

    @IBOutlet weak var lblNoNotification: UILabel!
    
    //MARK: Varibles
    //  var strUserType = "1"
    //  var isFromCustomer = false
    var arrNotificationList:[NotificationModel] = []
    var strReferenceId: String = ""
    var strType: String = ""
    var strRole: String = ""
    var strReferenceType: String = ""
    var strCurrentStatus: String = ""

    // pagination
    var isDataLoading:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    var strNextPageUrl = ""
    
     // Refresh
    var pullToRefreshCtrl:UIRefreshControl!
       var isRefreshing = false
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
                    self.lblChatCount.clipsToBounds = true
        
        print(" objAppShareData.UserDetail.strRole is \(objAppShareData.UserDetail.strRole)")
         self.setPullToRefresh()
        self.tblNotificationList.estimatedRowHeight = 80
        self.tblNotificationList.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblNOtification.text = "Notifications".localize
        self.lblNoNotification.text = "No_notification_here".localize

        if objAppShareData.UserDetail.strRole == "1" {
            self.vwSideMenu.isHidden = false
              self.vwChat.isHidden = true
        }else{
            self.vwSideMenu.isHidden = true
            self.vwChat.isHidden = false
            objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
        }
        self.vwHeader.setviewbottomShadow()
        self.vwNoRecord.isHidden = true
        self.tblNotificationList.isHidden = true
        self.arrNotificationList.removeAll()
        self.strNextPageUrl = ""
        self.isDataLoading = false
        self.limit = 10
        self.offset = 0
        self.callWsForGetNotificationList()
        //  self.timeGapBetweenDates(previousDate: "2020-09-03 10:13:12", currentDate: "2020-09-03 10:23:31")
        
    }
    
    //MARK: - Button Action
    @IBAction func btnSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnChatAction(_ sender: Any) {
           self.view.endEditing(true)
          let sb = UIStoryboard(name: "Chat", bundle: nil)
                 let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
                 self.navigationController?.pushViewController(detailVC, animated: true)
       }
}

//MARK: UITableViewDelegate & UITableViewDataSource

extension NotificationVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrNotificationList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblNotificationList.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
       
       
        print(arrNotificationList.count)
        if self.arrNotificationList.count > 0 {
            let obj = self.arrNotificationList[indexPath.row]
            cell.NotificationListCell(obj: obj )
            cell.checkImages(obj: obj )
            
//            cell.btnCell.tag = indexPath.row
//            cell.btnCell.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
            
            cell.btnCell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {

        let obj = self.arrNotificationList[indexPath.row]
        self.strReferenceId = obj.strReferenceId
        self.strType = obj.strType
        self.strRole = obj.strRole
        self.strCurrentStatus = obj.strCurrentStatus
        self.strReferenceType = obj.strReferenceType

        print("self.strRole is \( self.strRole)")
        self.callWsForReadNotification(strAlertId: obj.strAlertID )
        self.tblNotificationList.reloadData()
        }
        }
    
    
//    @objc func buttonClicked(sender:UIButton) {
//
//        let obj = self.arrNotificationList[sender.tag]
//        self.strReferenceId = obj.strReferenceId
//        self.strType = obj.strType
//        self.strRole = obj.strRole
//        self.strCurrentStatus = obj.strCurrentStatus
//        self.strReferenceType = obj.strReferenceType
//
//        print("self.strRole is \( self.strRole)")
//        self.callWsForReadNotification(strAlertId: obj.strAlertID )
//        self.tblNotificationList.reloadData()
//    }
}

//MARK: Api Calling

extension NotificationVC {
    // TODO: Webservice For get Notification List
    
    func callWsForGetNotificationList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
  /*
        var param =  [:] as [String : Any]
        
        var strWsUrl = ""

        if strNextPageUrl == ""
        {
            strWsUrl  = WsUrl.getNotificationList

            param = [
                WsParam.limit: self.limit,
                WsParam.offset: self.offset,
                ] as [String : Any]
        }
        else
        {
            strWsUrl = strNextPageUrl
        }


        print(param)

        objWebServiceManager.requestGet(strURL: strWsUrl  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
                
       */
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }
        objWebServiceManager.requestGet(strURL:WsUrl.getNotificationList+"limit="+String(self.limit)+"&offset="+String(self.offset), Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
                      
        print(response)
            
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            if self.isRefreshing{
                self.arrNotificationList.removeAll()
            }
            self.isRefreshing = false
            self.pullToRefreshCtrl.endRefreshing()
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        self.vwNoRecord.isHidden = true
                        self.tblNotificationList.isHidden = false
                        
                        //////////////////
                        
                        if let currentDatetime  = dic?["current_datetime"] as? String {
                            print("self.currentDatetime in string is \(currentDatetime)")
                            currentDateTime = currentDatetime
                        }
                        
                        self.totalRecords = dic?["total_records"] as? Int ?? 0
                        
                        print("self.totalRecords count is \(self.totalRecords)")
                        if   let paging  = dic?["paging"] as? [String:Any]
                        {
                            if let strNext  = paging["next"] as? String
                            {
                                self.strNextPageUrl = strNext
                            }
                            
                        }
                        
                        if let arrNotificationData = dic?["notification_list"] as? [[String: Any]]{
                            
                            for dictNotificationData in arrNotificationData
                            {
                                let objNotificationData = NotificationModel.init(dict: dictNotificationData)
                                self.arrNotificationList.append(objNotificationData)
                            }
                            print("self.arrNotificationList.count is \(self.arrNotificationList.count)")
                            
                          if self.arrNotificationList.count > 0  {
                                self.tblNotificationList.reloadData()
                                
                        
                          }
                        }
                        
                          
                        //////////////////
                        
                        
                    }else{
                        self.vwNoRecord.isHidden = false
                        self.tblNotificationList.isHidden = true
                    }
                }
                
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
    
    // TODO: Webservice For read Notification
    func callWsForReadNotification(strAlertId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
         objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        param = [
            WsParam.alertId: strAlertId
            ] as [String : Any]
        print(param)

        objWebServiceManager.requestPost(strURL: WsUrl.readNotification, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                objWebServiceManager.StopIndicator()

                self.redirectionFromNotification()

                
            }
            else
            {
                // objAlert.showAlert(message:message ?? "", title: "Alert", controller: self)
                
                if message != "Alert id not exist." {
                    
                }else{
                    objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
                    
                }
                
            }
            
            
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
            
        })
    }
    
}

//MARK: - Pull to refresh list
extension NotificationVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblNotificationList.refreshControl = pullToRefreshCtrl
        } else {
            self.tblNotificationList.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
        limit = 10
        offset = 0
        self.callWsForGetNotificationList()
    }
}



//MARK:- Pagination
extension NotificationVC {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblNotificationList.contentOffset.y + tblNotificationList.frame.size.height) >= tblNotificationList.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrNotificationList.count != totalRecords {
                        
                        self.callWsForGetNotificationList()
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}
    //MARK:- Redirections
    extension NotificationVC {

    
    func redirectionFromNotification(){
        
        if objAppShareData.UserDetail.strRole == "1" { // for Customer side
            if self.strReferenceType == "1"{ // for ride booking
                
                if self.strCurrentStatus == "1" ||  self.strCurrentStatus == "2" {
                    self.goToMapVC()
                } else if self.strCurrentStatus == "3" {
                    self.goToMapVC()
                    
                }else if self.strCurrentStatus == "4" {
                    self.goToMapVC()
                    
                }else if self.strCurrentStatus == "5" {
                    self.goToTripDetailVCFromCustomer()
                }else if self.strCurrentStatus == "6" {
                    self.goToTripDetailVCFromCustomer()
                    // past trip
                }else if self.strCurrentStatus == "7" {
                    self.goToTripDetailVCFromCustomer()
                    // past trip
                    
                } else if self.strCurrentStatus == "0" {
                    self.goToTripDetailVCFromCustomer()
                    // past trip
                }
                
            } else if self.strReferenceType == "2"{ // for restorent order
                
                if self.strCurrentStatus == "1" ||  self.strCurrentStatus == "2" {
                    self.goToUpcomingDetailVC()
                    
                }else if self.strCurrentStatus == "3" {
                    self.goToUpcomingDetailVC()
                    
                } else if self.strCurrentStatus == "4" {
                    self.goToUpcomingDetailVC()
                    
                }else if self.strCurrentStatus == "5" {
                    self.goToUpcomingDetailVC()
                    
                }else if self.strCurrentStatus == "6" {
                    self.goToCustomerPastOrderDetailVC()
                    
                }else if self.strCurrentStatus == "7" {
                    self.goToCustomerPastOrderDetailVC()
                }
                
            }
            
        } else  if objAppShareData.UserDetail.strRole == "2" { // for Taxi Driver side
            
            
            if self.strReferenceType == "1"{ // for ride booking
                
                if self.strCurrentStatus == "5" {
                    self.goToTripDetailVCFromTaxiDriver()
                }else if self.strCurrentStatus == "6" {
                    self.goToTripDetailVCFromTaxiDriver()
                    
                }else if self.strCurrentStatus == "0" {
                    self.goToTripDetailVCFromTaxiDriver()
                    
                }else {
                    self.goToTaxiMapVC()
                }
            } else if self.strReferenceType == "0" { // for doc
                self.goToTaxiProfile()
                // doubt
            }
            
        }else  if objAppShareData.UserDetail.strRole == "3" { // for Food Delivery side
            
            
            
            if self.strReferenceType == "2"{ // for order
                
                 if self.strCurrentStatus == "6" ||  self.strCurrentStatus == "7"  {
                    self.goToFoodDriverPastOrderDetailVC()
                }else{
                    self.goToFoodTrackingVC()
                }
            } else if self.strReferenceType == "0"{ // for doc
                self.goToFoodDriverProfile()
                // doubt
            }
                        
        }
        
    }
    
    /////////////////
    
    func goToMapVC(){
        objAppDelegate.showCustomerTabbar()
        selected_TabIndex = 0
        
    }
    func goToUpcomingDetailVC(){
        let sb = UIStoryboard(name: "Upcoming", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UpcomingDetailVC") as! UpcomingDetailVC
        detailVC.strOrderId = self.strReferenceId
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func goToCustomerPastOrderDetailVC(){
        let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CustomerPastOrderDetailVC") as! CustomerPastOrderDetailVC
        detailVC.strOrderId = self.strReferenceId
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func goToTripDetailVCFromCustomer(){
        let sb = UIStoryboard(name: "PastTrip", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
        detailVC.strBookingId = self.strReferenceId
        detailVC.strUserType = self.strRole
        detailVC.isFromCustomer = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    func goToTripDetailVCFromTaxiDriver(){
        let sb = UIStoryboard(name: "PastTrip", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
        detailVC.strBookingId = self.strReferenceId
        detailVC.strUserType = self.strRole
        detailVC.isFromCustomer = false
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func goToTaxiMapVC(){
        objAppDelegate.showTexiDriverTabbar()
        selected_TabIndex = 0
    }
    
    func goToTaxiProfile(){
        objAppDelegate.showTexiDriverTabbar()
        selected_TabIndex = 4
    }
    
    func goToFoodDriverProfile(){
        objAppDelegate.showFoodDeliveryTabbar()
        selected_TabIndex = 4
    }
    
    func goToFoodTrackingVC(){
        let sb = UIStoryboard(name: "Order", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "FoodTrackingVC") as! FoodTrackingVC
        detailVC.strOrderId = self.strReferenceId
        self.navigationController?.pushViewController(detailVC, animated: true)    }
    
    func goToFoodDriverPastOrderDetailVC(){
        
        let sb = UIStoryboard(name: "PastOrder", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PastOrderDetailVC") as! PastOrderDetailVC
        detailVC.strOrderId = self.strReferenceId
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

