
//
//  PastTripVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 07/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class PastTripVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var vwNoRecord: UIView!
    @IBOutlet weak var lblCompletedLine: UILabel!
    @IBOutlet weak var lblCancledLine: UILabel!
    @IBOutlet weak var tblPastTrip: UITableView!
    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var btnCanceled: UIButton!
    @IBOutlet weak var vwChat: UIView!
   @IBOutlet weak var lblChatCount: UILabel!
    
    //Localization outlets -
    
    @IBOutlet weak var lblLOHeaderPastTrip: UILabel!
    @IBOutlet weak var lblNOTripHere: UILabel!
    
    
    //MARK: Varibles
    
    var strtype = "1"
    var strUserType = "1"
    // var strTripType:Int=1
    var arrBookingList:[BookingModel] = []
    var isFromCustomer = false
    
    // pagination
    var isDataLoading:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    
    var strNextPageUrl = ""
    // var isNewDataLoading = false
    
    // Refresh
   var pullToRefreshCtrl:UIRefreshControl!
      var isRefreshing = false
    var isFromForgroundNotification = false

    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPullToRefresh()
        if objAppShareData.isFromBannerNotification == true {
            self.strUserType = objAppShareData.notificationBannerDict?["role"] as? String ?? ""
            
            if self.strUserType == "1"{
                
                let sb = UIStoryboard(name: "PastTrip", bundle: nil)
                let detailVC = sb.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
                detailVC.strBookingId = objAppShareData.strBannerReferenceID
                detailVC.strUserType = self.strUserType
                detailVC.isFromCustomer = true
                self.navigationController?.pushViewController(detailVC, animated: false)
                
            }else{
                let sb = UIStoryboard(name: "PastTrip", bundle: nil)
                let detailVC = sb.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
                detailVC.strBookingId = objAppShareData.strBannerReferenceID
                detailVC.strUserType = self.strUserType
                detailVC.isFromCustomer = false
                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
        self.vwNoRecord.isHidden = false
        self.didloadSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.localization()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    
    @objc func refrershUI(){
        
//        self.lblCompletedLine.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
//        self.lblCancledLine.backgroundColor = UIColor.clear
//        self.btnCompleted.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1), for: .normal)
//        self.btnCanceled.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
        
        self.arrBookingList.removeAll()
        self.strNextPageUrl = ""
        self.isDataLoading = false
     //   self.strtype = "1"
        self.limit = 10
        self.offset = 0
        self.isFromForgroundNotification = true
        if self.isFromCustomer == true {
            self.tabBarController?.tabBar.isHidden = true
            self.vwBack.isHidden = false
            self.vwChat.isHidden = true
            if  self.strtype == "1"{
                self.callWsForGetPastTripList(tripType: 1)
                
            }else if self.strtype == "2"{
                self.callWsForGetPastTripList(tripType: 2)
                
            }
        }else{
            self.strUserType = "2"
            if  self.strtype == "1"{
                self.callWsForGetPastTripList(tripType: 1)
                
            }else if self.strtype == "2"{
                self.callWsForGetPastTripList(tripType: 2)
                
            }
         
//            self.callWsForGetPastTripList(tripType : 1 )
//
            
            self.tabBarController?.tabBar.isHidden = false
           
            self.vwBack.isHidden = true
            self.vwChat.isHidden = false
            self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
                  self.lblChatCount.clipsToBounds = true
                   objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.isFromForgroundNotification = false
        NotificationCenter.default.removeObserver(self)
    }
    
    func didloadSetup(){
        tblPastTrip.register(UINib(nibName: "CompletedCell", bundle: nil), forCellReuseIdentifier: "CompletedCell")
      //  self.vwBack.setCornerRadius(radius: 8)
        
        self.tblPastTrip.dataSource = self
        self.tblPastTrip.delegate = self
        
        self.lblCompletedLine.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
        self.lblCancledLine.backgroundColor = UIColor.clear
        self.btnCompleted.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1), for: .normal)
        self.btnCanceled.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
        
        self.arrBookingList.removeAll()
        self.strNextPageUrl = ""
        self.isDataLoading = false
        self.strtype = "1"
        self.limit = 10
        self.offset = 0
        
        // self.callWsForGetPastTripList(tripType : 1 )
        if self.isFromCustomer == true {
            self.tabBarController?.tabBar.isHidden = true
            self.vwBack.isHidden = false
            self.vwChat.isHidden = true
            self.callWsForGetPastTripList(tripType : 1 )
        }else{
            self.tabBarController?.tabBar.isHidden = false
            self.strUserType = "2"
            self.callWsForGetPastTripList(tripType : 1 )
            self.vwBack.isHidden = true
            self.vwChat.isHidden = false
            self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
                  self.lblChatCount.clipsToBounds = true
                   objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
        }
       // self.tblPastTrip.reloadData()
    }
    
    
    func localization(){
        self.lblLOHeaderPastTrip.text = "Past_Trip".localize
        self.lblNOTripHere.text = "No_trip_here".localize
        self.btnCanceled.setTitle("Cancelled".localize, for: .normal)
        self.btnCompleted.setTitle("Completed".localize, for: .normal)
    }
    
    //MARK: Button Actions
    
    @IBAction func btnChatAction(_ sender: Any) {
        self.view.endEditing(true)
       let sb = UIStoryboard(name: "Chat", bundle: nil)
              let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
              self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCompleted(_ sender: Any) {
        self.lblCompletedLine.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
        self.lblCancledLine.backgroundColor = UIColor.clear
        
        self.btnCompleted.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1), for: .normal)
        self.btnCanceled.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
        
        
        
        self.strtype = "1"
        // self.strTripType = 1
        self.arrBookingList.removeAll()
        self.limit = 10
        self.offset = 0
        self.strNextPageUrl = ""
        self.isDataLoading = false
        self.callWsForGetPastTripList(tripType : 1 )
        
      //  self.tblPastTrip.reloadData()
        
        
    }
    @IBAction func btnCancled(_ sender: Any) {
        self.lblCompletedLine.backgroundColor = UIColor.clear
        self.lblCancledLine.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
        
        self.btnCanceled.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1), for: .normal)
        self.btnCompleted.setTitleColor(#colorLiteral(red: 0.6470588235, green: 0.6470588235, blue: 0.6470588235, alpha: 1), for: .normal)
        
        self.strtype = "2"
        //self.strTripType = 2
        self.strNextPageUrl = ""
        self.isDataLoading = false
        self.arrBookingList.removeAll()
        self.limit = 10
        self.offset = 0
        self.callWsForGetPastTripList(tripType : 2 )
      //  self.tblPastTrip.reloadData()
        
    }
    
    
}
//MARK: UITableViewDelegate & UITableViewDataSource

extension PastTripVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrBookingList.count
        
        //  return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblPastTrip.dequeueReusableCell(withIdentifier: "CompletedCell", for: indexPath) as!CompletedCell
        
        let obj = self.arrBookingList[indexPath.row]
        cell.pastTripCell(obj: obj, tripType : self.strtype , userType : self.strUserType)
        cell.lblLOPrice.text = "Price".localize
        cell.lblLOKilometer.text = "Kilometer".localize

        cell.btnReview.tag = indexPath.row
        cell.btnReview.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
  
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objData = arrBookingList[indexPath.row]
        let sb = UIStoryboard(name: "PastTrip", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "TripDetailVC") as! TripDetailVC
        detailVC.strBookingId = objData.strBookingID
        detailVC.strUserType = self.strUserType
        detailVC.isFromCustomer = self.isFromCustomer
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
    
    
    @objc func buttonClicked(sender:UIButton) {
        
        if self.arrBookingList.count > 0 {
        
        let obj = self.arrBookingList[sender.tag]
        
        print("btn review is clicked \(obj.strDriverId)")
        
        let sb = UIStoryboard(name: "Map", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
        detailVC.strBookingId = obj.strBookingID
        detailVC.strUserId = obj.strDriverId
        detailVC.strProfile = obj.strDriverImage
        detailVC.strName = obj.strDriverName
        detailVC.strRating = obj.strRating
        detailVC.strReview = obj.strReview
        detailVC.closerDeleteAlertList = {
            isClearListData in
            if isClearListData{
                self.strtype = "1"
                self.arrBookingList.removeAll()
                self.limit = 10
                self.offset = 0
                self.strNextPageUrl = ""
                self.isDataLoading = false
                self.callWsForGetPastTripList(tripType : 1 )
                self.tblPastTrip.reloadData()
                
            }
        }
        
        detailVC.modalPresentationStyle = .overCurrentContext
        self.present(detailVC, animated: false, completion: nil)
        }
    }
}


extension PastTripVC {
    // TODO: Webservice For get DriverList
    
    func callWsForGetPastTripList(tripType : Int){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }else if self.isFromForgroundNotification{
            objWebServiceManager.StopIndicator()
        }else{
            objWebServiceManager.StartIndicator()

        }
        
        // var param: [String: Any] = [:]
        var param =  [:] as [String : Any]
        
        
        var strWsUrl = ""
        
        if strNextPageUrl == ""
        {
            strWsUrl  = WsUrl.getPastRide
            
            param = [
                WsParam.userType: self.strUserType ,
                WsParam.tripType: tripType,
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
     
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)

            
            if self.isRefreshing{
                self.arrBookingList.removeAll()
            }
            self.isRefreshing = false
            self.pullToRefreshCtrl.endRefreshing()
            
            
            if status == "success"{
                
        
                
                let dic  = response["data"] as? [String:Any]
                
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        self.vwNoRecord.isHidden = true
                        self.tblPastTrip.isHidden = false
                        
                    }else{
                        self.vwNoRecord.isHidden = false
                        self.tblPastTrip.isHidden = true
                    }
                }
                
                self.totalRecords = Int(dic!["total_records"] as? String ?? "") ?? 0
                
                
                if   let paging  = dic?["paging"] as? [String:Any]
                {
                    if let strNext  = paging["next"] as? String
                    {
                        self.strNextPageUrl = strNext
                    }
                  
                }
                
                
                if let arrBookingData = dic?["booking_list"] as? [[String:Any]]{
                    // self.arrBookingList.removeAll()
                    for dictBookingData in arrBookingData{
                                                
                        let objBookingData = BookingModel.init(dict: dictBookingData)
                                                
                       /*
                        if let driverrData = objAppShareData.convertToDictionary(text: dictBookingData["driver_json"] as? String ?? "") {
                            
                            
                            if let userID = driverrData["userID"]as? String{
                                driverId = userID
                                print("self.userID count is \(userID))")
                                
                            }
                            
                            
                            if let avatar = driverrData["avatar"]as? String{
                                ProfilePic = avatar
                                
                            }
                            
                            if let fullName = driverrData["full_name"]as? String{
                                name = fullName
                                
                            }
                        }
                        
                        objBookingData.strDriverId = driverId
                        objBookingData.strAvatar = ProfilePic
                        objBookingData.strFullName = name
                        
                       */
                        
                        self.arrBookingList.append(objBookingData)
                    }
                    //                    self.vwData.isHidden = false
                    print("self.arrBookingList count is \(self.arrBookingList.count)")
                    
                    
                }
                
                self.tblPastTrip.reloadData()
                
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
    
}

//MARK:- Pagination
extension PastTripVC {
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblPastTrip.contentOffset.y + tblPastTrip.frame.size.height) >= tblPastTrip.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrBookingList.count != totalRecords {
                        print("self.arrBookingList count is \(self.arrBookingList.count)")
                        print("self.totalRecords is \(self.totalRecords)")
                        if  self.strtype == "2" {
                            self.callWsForGetPastTripList(tripType : 2 )
                        } else {
                            self.callWsForGetPastTripList(tripType : 1 )
                        }
                        
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
    
}
//MARK: - Pull to refresh list
extension PastTripVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblPastTrip.refreshControl = pullToRefreshCtrl
        } else {
            self.tblPastTrip.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
        limit = 10
        offset = 0
        self.strNextPageUrl = ""
        if  self.strtype == "1"{
            self.callWsForGetPastTripList(tripType: 1)
            
        }else if self.strtype == "2"{
            self.callWsForGetPastTripList(tripType: 2)
            
        }
    }
}
