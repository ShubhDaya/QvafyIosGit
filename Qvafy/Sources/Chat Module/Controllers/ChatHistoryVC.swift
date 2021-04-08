
//
//  ChatHistoryVC.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//

import UIKit
import Firebase
import Alamofire
//import Kingfisher
//import AlamofireImage

//var self.isObserverCalled = true

class ChatHistoryVC: UIViewController {
    
    //MARK:- All Variables
    var strMyChatId:String = ""
    var strAuthToken:String = ""
    var arrReadMsg:[Int] = []
    var strEventOrgId = ""
    var strEventMemId = ""
    var strEventCompId = ""
    var strEventOwnerType = ""
    var arrChatHistory = [ChatHistoryData]()
    var strUser_Id:String = ""
    var isOnChatHistory : Bool = false
    var isDidSelectCalled = false
    var isObserverCalled = true
    var userType = ""
    var user_Id = ""
    var group_Id = ""
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle?
    
    var strUserID = ""
      // var strUserType = ""
      var strDriverId = ""
      var strReferenceID = ""
      var strOrderId = ""
     var isFromDriverSide:Bool = false
    
     var strTotalUnread:String = ""
     var strTotalunreadCount = 0
    
    // Refresh
   var pullToRefreshCtrl:UIRefreshControl!
      var isRefreshing = false
   
    
    //MARK:- All OUTLETS
    @IBOutlet weak var viewNoDataFound: UIView!
    @IBOutlet weak var tableMessages: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblNoMessages: UILabel!
    @IBOutlet weak var lblNoMessagesText: UILabel!
    
    @IBOutlet weak var viewHeader: UIView!
    
    
    // Localization Outlets -
    @IBOutlet weak var lblLOMessageHeader: UILabel!
    @IBOutlet weak var lblLONoMsgHere: UILabel!
    
    
      //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPullToRefresh()

        ref = Database.database().reference()
        self.strUserID = objAppShareData.UserDetail.strUserID
        
        if objAppShareData.isFromBannerNotification == true {
            if  objAppShareData.strBannerNotificationType == "chat"{
              let sb = UIStoryboard(name: "Chat", bundle: nil)
              let detailVC = sb.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                 if let bannerChatRoom = objAppShareData.notificationBannerDict?["chat_node"]as? String{
                                   // objAppShareData.strBannerChatRoom = bannerChatRoom
                    detailVC.strChatRoom  = bannerChatRoom
                     print("objAppShareData.strBannerChatRoom is \(bannerChatRoom)")
                    }
                
                if let senderId = objAppShareData.notificationBannerDict?["senderId"]as? String{
                                detailVC.strOpponentId = senderId
                        }
                              
                if let referenceId = objAppShareData.notificationBannerDict?["reference_id"]as? String{
                        detailVC.strReferenceID = referenceId
                }
                //  detailVC.strChatRoom = objAppShareData.strBannerChatRoom
                self.navigationController?.pushViewController(detailVC, animated: false)
            }
        }
        
        self.viewNoDataFound.isHidden = true
        tableMessages.delegate = self
        tableMessages.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localisation()
        self.viewHeader.setviewbottomShadow()

        self.isObserverCalled = false
        isOnChatHistory = true
        self.GetChatHistoryFromFirebase()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
         super.viewWillDisappear(animated)
         self.isOnChatHistory = false
     }
     
     override func viewDidDisappear(_ animated: Bool) {
         super.viewDidDisappear(animated)
         self.isOnChatHistory = false
         //self.ref.removeAllObservers()
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    
    //MARK: - Buttons Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Localization Func
    func localisation(){
        self.lblLOMessageHeader.text = "Messages".localize
        self.lblLONoMsgHere.text = "No_message_here".localize
    }
}

//MARK: - Tableview Delegate DataSource methods
extension ChatHistoryVC:UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrChatHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cellIdentifier = "Cell_ChatHistory"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! Cell_ChatHistory
        
        let objChatList = arrChatHistory[indexPath.row]
        
        print("objChatList.strOppentId is \(objChatList.strOppentId)")
        print("self.strUserID is \(self.strUserID)")
        if objChatList.strOppentId != ""{
            

        }
        
        if objChatList.str_isImage == 1 {
            cell.viewIconCamera.isHidden = false
            cell.lblMsg.textColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)
            cell.lblMsg.text = "Image"

            }else{
                cell.viewIconCamera.isHidden = true
                cell.lblMsg.text = objChatList.str_message
                 cell.lblMsg.textColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)
        }
    
        if objChatList.isOnline == "Online" {
            //cell.vwOnline.isHidden = false
            cell.vwOnline.isHidden = true
        }else{
            cell.vwOnline.isHidden = true
        }
        
        if let imgUrl = URL(string: objChatList.str_ProfileImage){
            cell.imgUserProfile.sd_setImage(with: imgUrl, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }
        else{
            cell.imgUserProfile.image = UIImage(named: "defaultUser")
        }
        cell.lblUserName.text = objChatList.str_Name //+ " (#" + objChatList.strOrdernumber + ")"
        cell.lblOorderNumber.text = "(#" + objChatList.strOrdernumber + ")"
        let strCount = String(objChatList.unreadCount)
        
        if strCount == "0" {
            cell.lblMsgCount.isHidden = true
        }else{
            cell.lblMsgCount.isHidden = false
            cell.lblMsgCount.text = strCount
        }
        
        cell.lblTime.text = objChatList.strDateTime
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        isDidSelectCalled = true
        let obj = arrChatHistory[indexPath.row]
        self.goToChatScreenWithUser(objChatList: obj)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        self.isObserverCalled = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.isObserverCalled = true
    }
    
    func goToChatScreenWithUser(objChatList :ChatHistoryData ){
        
        
         print("strKey is in didselect \(objChatList.strKey)")
        // "1-2-T-56-A"
        
        let fullNameArr = objChatList.strKey.components(separatedBy: "-")
        
         print("customer id is  \(fullNameArr[0])")
         print("driver id is  \(fullNameArr[1])")
         print("driver type is  \(fullNameArr[2])")
         print("rideOrder id is  \(fullNameArr[3])")
         print("Admin id is  \(fullNameArr[4])")
         print("strUserType is \(objChatList.userType)")
         print("objChatList.strOrdernumber is \(objChatList.strOrdernumber)")
        
        

             let sb = UIStoryboard(name: "Chat", bundle: nil)
             let detailVC = sb.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC

        detailVC.strCustomerId = fullNameArr[0]
        detailVC.strDriverId = fullNameArr[1]
        detailVC.strOrderRideId = fullNameArr[3]
        detailVC.strReferenceID = objChatList.strOrdernumber
        detailVC.isFromChatHistory = true
        detailVC.strChatRoom = objChatList.strKey
        if objChatList.userType == "2" {
            detailVC.strDriverType = "2"
            detailVC.isFromDriverSide = true
            detailVC.strOpponentId = fullNameArr[1]
            detailVC.strReferenceType = "1"
        } else if objChatList.userType == "3" {
            detailVC.isFromDriverSide = true
             detailVC.strDriverType = "3"
            detailVC.strOpponentId = fullNameArr[1]
            detailVC.strReferenceType = "2"
        }else{
            detailVC.isFromDriverSide = false
            //detailVC.strDriverType = "1"
            //detailVC.strDriverType = objChatList.userType
            detailVC.strOpponentId = fullNameArr[0]
            //detailVC.strDriverType = objAppShareData.UserDetail.strRole
           // detailVC.strDriverType = fullNameArr[2]
            let type = fullNameArr[2]
            if type == "T" {
                detailVC.strReferenceType = "1"
                detailVC.strDriverType = "2"
            }else if type == "F" {
                detailVC.strReferenceType = "2"
                detailVC.strDriverType = "3"

            }
//            if objAppShareData.UserDetail.strRole == "2" {
//                  detailVC.strReferenceType = "1"
//            }else if objAppShareData.UserDetail.strRole == "3" {
//                detailVC.strReferenceType = "2"
//            }
        }
        
        // detailVC.strOpponentId = self.strDriverId
            self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - FireBase Method calls
extension ChatHistoryVC{
    
    func GetChatHistoryFromFirebase() {
        
        if !NetworkReachabilityManager()!.isReachable{
            //objIndicator.stopActivityIndicator()
            //  objAppShareData.showAlert(message: "", title: NoInternetConnection, controller: self)
            return
        }
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }
        // Listen for new messages in the Firebase database
       _refHandle = self.ref.child("chat_history").child(self.strUserID).observe(.value, with: { [weak self] (snapshot) -> Void in
                     print("snapshot = \(snapshot)")
            guard let strongSelf = self else { return }
            
            if !(self?.isOnChatHistory)!{
                return
            }
            
            
            
            if snapshot.hasChildren(){
                //
                if ((self?.isRefreshing) != nil){
                    self?.arrChatHistory.removeAll()
                }
                self?.isRefreshing = false
                self?.pullToRefreshCtrl.endRefreshing()
                //
                self?.arrChatHistory.removeAll()
                for child in snapshot.children {
                    let strKey = ((child as! DataSnapshot).key)
                   // print("strKey is \(strKey)")
                    
                    strongSelf.parseDataChatHistory(dict: (child as! DataSnapshot).value as? [String : Any] ?? [:], key: strKey)
                }
                
            }else{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                    //objIndicator.stopActivityIndicator()
                }
                strongSelf.arrChatHistory.removeAll()
                strongSelf.tableMessages.reloadData()
                strongSelf.viewNoDataFound.isHidden = false
                //
                
                if (self?.arrChatHistory.count == 0) {
                    self?.viewNoDataFound.isHidden = false
                    self?.tableMessages.isHidden = true
                } else {
                    self?.viewNoDataFound.isHidden = true
                    self?.tableMessages.isHidden = false
                }
                //
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            //objIndicator.stopActivityIndicator()
        }
    }
    
}

//MARK: - Parsing Methods
extension ChatHistoryVC{
    
    func parseDataChatHistory(dict:[String:Any], key : String){
        
        self.isObserverCalled = false
        self.arrReadMsg.removeAll()
        
        let objChatList = ChatHistoryData()
      
        objChatList.strOrdernumber = dict["reference_id"] as? String ?? ""
        objChatList.strOrderRideId = dict["order_Id_ride_id"] as? String ?? ""
        objChatList.str_isImage = dict["image"] as? Int ?? 0
       
        objChatList.str_imageURL = dict["image_url"] as? String ?? ""
        objChatList.strMsgReadTick = dict["msg_read_tick"] as? String ?? ""
        objChatList.time = dict["timestamp"] as? Double ?? 0
        objChatList.unreadCount = dict["unread_count"] as? Int ?? 0
        objChatList.strKey = key
        
         objChatList.isTyping = dict["typing"] as? Int ?? 0
        
        
         objChatList.str_message = dict["last_message"] as? String ?? "" // new key
          objChatList.strOppentId = dict["last_sender_id"] as? String ?? "" // new key
        
         self.strDriverId = objChatList.strOppentId
         self.strReferenceID = objChatList.strOrdernumber
         self.strOrderId = objChatList.strOrderRideId
        
       // self.getData()
        
       // self.getData(strkey : objChatList.strKey , strId: objChatList.strOppentId)
        let date = Date(timeIntervalSince1970: objChatList.time / 1000.0)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.timeZone = NSTimeZone.local
        let date_1 = dateFormatter.string(from: date)
        
        let currentDate = Date()
        let Date_2 = dateFormatter.string(from: currentDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        timeFormatter.dateFormat = "hh:mm a"
        let Time = timeFormatter.string(from: date)
        
        if date_1 == Date_2 {
            objChatList.strDateTime = Time
        }else{
            objChatList.strDateTime = date_1
        }
        
        let arr = objAppShareData.arrUsers.filter({$0.userId == objChatList.strOppentId})
        var objUser = user.init()
        if arr.count>0{
            objUser = arr[0]
        }
        objChatList.str_Name = objUser.str_Name
        objChatList.str_ProfileImage = objUser.str_ProfileImage
        objChatList.isOnline = objUser.isOnline
        objChatList.userType = objUser.userType

      if  objChatList.strOppentId != ""{
            self.arrChatHistory.append(objChatList)
        }
        
        if arrChatHistory.count > 0 {
            self.viewNoDataFound.isHidden = true
        }else{
            self.viewNoDataFound.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            //objIndicator.stopActivityIndicator()
        }
        
        self.arrChatHistory = self.arrChatHistory.sorted {
            (lhs, rhs) in lhs.time > rhs.time
        }
        
        print("self.arrChatHistory.count = \(self.arrChatHistory.count)")
        self.tableMessages.reloadData()
        
        if (self.arrChatHistory.count == 0) {
            self.viewNoDataFound.isHidden = false
            self.tableMessages.isHidden = true
        } else {
            self.viewNoDataFound.isHidden = true
            self.tableMessages.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
            self.isObserverCalled = true
        }

        
        var count = 0
        for obj in self.arrChatHistory{
              count = count + obj.unreadCount
        }
          self.strTotalunreadCount =  count
         print("self.strTotalunreadCount after loop = \(self.strTotalunreadCount)")
        
        
       
    }

}

//MARK: - timeAgoSinceDate
extension ChatHistoryVC{
    func timeAgoSinceDate(date:NSDate, numericDates:Bool) -> String {
        
        let calendar = NSCalendar.current
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now
        
        let unitsSet : Set<Calendar.Component> = [.year,.month,.weekOfYear,.day, .hour, .minute, .second, .nanosecond]
        
        let components:NSDateComponents = calendar.dateComponents(unitsSet, from: earliest, to: latest as Date) as NSDateComponents
        
        if (components.year >= 2) {
            return "\(components.year) \("years ago".localize)"
        } else if (components.year == 1){
            if (numericDates){
                return "\("years ago".localize)"
            } else {
                return "Last year".localize
            }
        } else if (components.month >= 2) {
            return "\(components.month) \("months ago".localize)"
        } else if (components.month == 1){
            if (numericDates){
                return "1 \("months ago".localize)"
            } else {
                return "Last month".localize
            }
        } else if (components.weekOfYear >= 2) {
            return "\(components.weekOfYear) \("weeks ago".localize)"
        } else if (components.weekOfYear == 1){
            if (numericDates){
                return "1 \("weeks ago".localize)"
            } else {
                return "Last week".localize
            }
        } else if (components.day >= 2) {
            return "\(components.day) \("days ago".localize)"
        } else if (components.day == 1){
            if (numericDates){
                return "1 \("days ago".localize)"
            } else {
                return "Yesterday".localize
            }
        } else if (components.hour >= 2) {
            return "\(components.hour) \("hours ago".localize)"
        } else if (components.hour == 1){
            if (numericDates){
                return "1 \("hours ago".localize)"
            } else {
                return "hour ago".localize
            }
        } else if (components.minute >= 2) {
            return "\(components.minute) \("mins ago".localize)"
        } else if (components.minute == 1){
            if (numericDates){
                return "1 \("mins ago".localize)"
            } else {
                return "1 \("mins ago".localize)"
            }
        } else if (components.second >= 3) {
            return "\(components.second) \("secs ago".localize)"
        } else {
            return "1 \("secs ago".localize)"
        }
        
    }
    
}
///////////////////////

//

//MARK: - Pull to refresh list
extension ChatHistoryVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tableMessages.refreshControl = pullToRefreshCtrl
        } else {
            self.tableMessages.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
//        limit = 10
//        offset = 0
        self.GetChatHistoryFromFirebase()
    }
}

