
//
//  ChatVC.swift
//  Appointment
//
//  Created by Apple on 11/06/18.
//  Copyright © 2018 MINDIII. All rights reserved.
//
///*
import UIKit
import Firebase
import Alamofire
//import AlamofireImage
//import IQKeyboardManagerSwift
import SVProgressHUD
import UserNotifications
import NotificationCenter

//import Kingfisher

//BlockUser
enum BlockStatus {
    case kBlockedByMe
    case kBlockedByOpponent
    case kBlockedByBoth
    case kBlockedByNone
}

class ChatVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UIGestureRecognizerDelegate {
    

    //MARK:- Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var viewOpponentName: UIView!
    @IBOutlet weak var viewOpponentOnline: UIView!
    @IBOutlet weak var viewOpponentNumber: UIView!
    @IBOutlet weak var viewNoChat: UIView!
    @IBOutlet weak var viewZoomImg: UIView!
    @IBOutlet weak var imgZoomImage: UIImageView!
    @IBOutlet weak var scrollViewImg: UIScrollView!
    @IBOutlet weak var viewChatShadow: UIView!
    @IBOutlet weak var imgOpponent: UIImageView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var tableChat: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var txtViewChat: UITextView!
    @IBOutlet weak var bottem: NSLayoutConstraint!
    @IBOutlet weak var btnDeleteChatYes: UIButton!
    @IBOutlet weak var viewMsgDay: UIView!
    @IBOutlet weak var viewMsgDayBack: UIView!
    @IBOutlet weak var viewProfileImg: UIView!
    @IBOutlet weak var viewtxtMessage: UIView!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var viewBlockStatus: UIView!
    @IBOutlet weak var viewCounterOffer: UIView!
    @IBOutlet var btnCancelCounter: UIButton!
    @IBOutlet weak var viewFor_Block_Delete: UIView!
    @IBOutlet weak var viewForBlock: UIView!
    @IBOutlet weak var viewForDelete: UIView!
    @IBOutlet weak var lblOpponentName: UILabel!
    @IBOutlet weak var lblOrdernumber: UILabel!
    @IBOutlet var lblBlockTitle: UILabel!
    @IBOutlet var lblNoMessage: UILabel!
    @IBOutlet weak var vwbottomforOrder: UIView!
    @IBOutlet weak var vwbottomforBlock: UIView!
    @IBOutlet weak var lblbottomBlock: UILabel!
    @IBOutlet weak var lblbottomOrder: UILabel!
     @IBOutlet weak var vwCancleBack: UIView!
    @IBOutlet weak var vwScroll: UIScrollView!

    //Localization Outlets-
    @IBOutlet weak var lblLODeleteCHat: UILabel!

    //MARK:- Varibles
    var imgType:Int = 0
    var unreadCount:Int = 0
    var badgeCount:Int = 0
    var isOppNotification:String = "1"
    var strChatRoom:String = ""
    var localImagePath:String = ""
    var seconds = 5
    var timer = Timer()
    var childautoID = ""
    var isOnline = ""
    var storageRef: StorageReference!
    var blockedBy: BlockStatus = BlockStatus.kBlockedByNone
    var isOpponentOnline:Int = 0
    var strTextNotification:String = ""
    var strName:String = ""
    var profilePic:String = ""
    var strMyChatId:String = ""
    var strFireBaseId:String = ""
    var isOffer:Int = 0
    
    var Id = ""
    
    
    var strOpponentEmail = ""
    var strOpponentFirebaseId = ""
    var strOpponentUid = ""
    
    var strOpponentFirebaseToken = ""
    var strOpponentName = ""
    var imgOpponentProfileImage = ""
    var strOpponentUserId = ""
    var strSenderId = ""
    
    var strType = ""
    var strPrice = ""
    var strSelectedSize = ""
    var strSelectedSizeID = ""
    var strSelectedColor = ""
    var strSelectedColorID = ""
    
    var strProductName = ""
    var strQuantity = ""
    var strFeatureImage = ""
    var strSeller_id = ""
    var strVariantId = ""
    var strCategoryId = ""
    var strCategoryName = ""
    var strSalePrice = ""
    var strRegularPrice = ""

    var strOpponentAuthToken = ""
    let txtViewMsgMaxHeight: CGFloat = 100
    let txtViewMsgMinHeight: CGFloat = 35
    let imagePicker = UIImagePickerController()
    private var tap: UITapGestureRecognizer!
    var arrMessages = [ChatData]()
    
    var arrFilterMessages = [Any]()
    var message = ""
    var imgUrl = ""
    var ref: DatabaseReference!
    var messages: [DataSnapshot]! = []
    fileprivate var _refHandle: DatabaseHandle?
    
    
    var strChatTypeID:String = ""
    var strProductID = ""
 
    var strBuyerID = ""
    var strUserName = ""

    var strSellerID = ""
    var strUserID = ""
    var strUsertype = ""
    var strOrderNumber = ""
    
    //For pagination
    var lastContentOffset: CGFloat = 0
    var strPaginationKey:String = ""
   
    var newMessageRefHandle: DatabaseHandle?
    //
    
    // var arrProductColors = [VariantValueModel]()
    //   var arrProductSize = [VariantValueModel]()
    
    var isClearChat:Bool = false
    var isChatAvaible:Bool = false
    var isChatAppearFirst:Bool = false
    var isPullToRefresh = false
    var isImagePicked:Bool = false
    var isSendButtonClicked:Bool = false
    var isLastMsg = false
    var isLoading = false
    var isImageSend:Bool = false
    var isFromBlock = false
    var isAvailableProduct:Bool = false
    var isOrderDelete:Bool = false
    var isTableScrollToTop:Bool = false
    var isOfferExit = false

    var strTimestamp:Double?
    var messageTimeStamp:Double?
    var LatestTimeStamp:Double = 0
    
    // deepak new

    var strCustomerId = ""
    var strDriverId = ""
    var strDriverType = ""
    var strReferenceID = ""
    var strOrderRideId = ""
    var isFromDriverSide:Bool = false
    var isFromChatHistory = false
    
    var strCurrentStatus = ""
    var strOpponentId = ""
    var strReferenceType = ""
    
    var strLoginUserId = ""
    var strLoginUserRole = ""
    var strBlockStatus = ""
    
    // var strongSelfref = Database.database().reference()
    // deepak
    
    var imageSize: Double = 0.0
    var placeholderLabel : UILabel!
    
    //MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.forTextViewPlaceHolder()
        self.lblNoMessage.isHidden = true
     //   self.viewFor_Block_Delete.isHidden = true
        self.viewZoomImg.isHidden = true
        self.viewBottom.isHidden = false
         self.isChatAppearFirst = true
        self.vwbottomforOrder.isHidden = true
        self.vwbottomforBlock.isHidden = true
         objAppShareData.isOnChatScreen = true
         self.vwCancleBack.layer.cornerRadius = self.vwCancleBack.frame.height/2
       // self.viewProfileImg.setProfileVerifyView(vwOuter: self.viewProfileImg, img: self.imgOpponent)
        
        self.viewProfileImg.setUserProfileView(vwOuter: self.viewProfileImg, img: self.imgOpponent , radius : 4)

       // self.viewProfileImg.setShadowWithCornerRadius()

        self.strLoginUserId = objAppShareData.UserDetail.strUserID
        self.strLoginUserRole = objAppShareData.UserDetail.strRole
        self.strUserName  = objAppShareData.UserDetail.strFullName
        
        if objAppShareData.isFromBannerNotification == true {
            if  objAppShareData.strBannerNotificationType == "chat"{
                
                let fullNameArr = self.strChatRoom.components(separatedBy: "-")

                self.strCustomerId = fullNameArr[0]
                self.strDriverId = fullNameArr[1]
                self.strOrderRideId = fullNameArr[3]
                
                if fullNameArr[2] == "T"{
                    self.strReferenceType = "1"
                } else if fullNameArr[2] == "F"{
                    self.strReferenceType = "2"
                }
     
                //strReferenceType
                
            }
        } else {
            
            var driverType = ""
                 //  var OpponentId = ""
                   if self.strDriverType == "2"{
                       driverType = "T"
                   }else if self.strDriverType == "3"{
                       driverType = "F"
                   }
                                      

                   self.strChatRoom = self.strCustomerId+"-"+self.strDriverId+"-"+String(driverType)+"-"+self.strOrderRideId+String("-A")
                   print("self.strChatRoom is \(self.strChatRoom)")
            
        }
        
       
        
        self.ref = Database.database().reference()
        //  self.viewMenu.isHidden = true
        objAppShareData.opponentUserId = self.strOpponentId
        
        print("objAppShareData.opponentUserId is on chat vc \(objAppShareData.opponentUserId)")
        print("self.strOpponentId is on chat vc viewdidload \(self.strOpponentId)")
        print("self.strLoginUserId is on chat vc viewdidload \(self.strLoginUserId)")
        
        print("self.isChatAvaible is on chat vc viewdidload \(self.isChatAvaible)")
        print("self.isChatAppearFirst is on chat vc viewdidload \(self.isChatAppearFirst)")
        print("objAppShareData.isOnChatScreen is on chat vc viewdidload \(objAppShareData.isOnChatScreen)")
        self.scrollViewImg.minimumZoomScale = 1.0
        self.scrollViewImg.maximumZoomScale = 5.0
        self.scrollViewImg.delegate = self
        self.txtViewChat.delegate = self
        self.observeKeyboard()
        self.configureStorage()
        self.configureView()
        self.getDeletechat()
        self.clearUnreadChatHistory() // commented by sir

        self.readAllOpponentChat()

        DispatchQueue.main.async {
            self.observeOrderMessages(lastMessageKey: nil)
            self.getOpponentDetailsFromFirebase(strOpponentId: self.strOpponentId)
        }
                            self.getOpponentUnreadCount() // commented by sir // deepak reopen
                        self.checkBlockStatusForThisChatRoom()
                                 //  self.getOpponentbadgeCount()
        //

        self.vwHeader.setviewbottomShadow()
        
        
        self.callWsForCheckCurrentStatus(type: self.strReferenceType , referenceId: self.strOrderRideId)
        
        
        if objAppShareData.isFromBannerNotification == true {
            objAppShareData.resetBannarData()
        }
    }
    
    
    @objc func willResignActive(_ notification: Notification) {
        //  objAppShareData.isOnChatScreen = false
    }
    
    @objc func willEnterForground(_ notification: Notification) {
        // objAppShareData.isOnChatScreen = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.forTextViewPlaceHolder()
        
        self.lblLODeleteCHat.text = "Delete_chat".localize
        self.lblNoMessage.text =  "No_message_here".localize
        
        if  isImagePicked == false {
        
        self.viewMenu.isHidden = true
        bottem.constant = 7
        isFromBlock = true
         self.isChatAppearFirst = true
        self.tabBarController?.tabBar.isHidden = true
            objAppShareData.isOnChatScreen = true
        }else{

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//           IQKeyboardManager.shared.enable = true
//           IQKeyboardManager.shared.enableAutoToolbar = true
           self.ref.removeAllObservers()
          objAppShareData.isOnChatScreen = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func gestureHandlerMethod() {
        
        self.txtViewChat.text = self.txtViewChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if self.txtViewChat.text.count > 0{
            self.txtViewChat.isScrollEnabled = false
            
        }else{
            self.txtViewChat.isScrollEnabled = false
        }
        self.viewMenu.isHidden = true
        bottem.constant = 7
        self.view.endEditing(true)
    }
    
    //MARK:- Zoom Image
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgZoomImage
    }
    
    func configureStorage() {
        
        ref =  Database.database().reference()
        storageRef = Storage.storage().reference().child("chat_photos")
    }
    
    func configureView() {
        imagePicker.delegate = self
        self.tableChat.delegate = self
        self.tableChat.dataSource = self
        tableChat.rowHeight = UITableView.automaticDimension
        self.viewZoomImg.isHidden = true
        self.viewShadow.layer.masksToBounds = false
        self.viewShadow.layer.shadowColor = UIColor.black.cgColor
        self.viewShadow.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.viewShadow.layer.shadowOpacity = 0.5
        tableChat.estimatedRowHeight = 50.0
        tableChat.rowHeight = UITableView.automaticDimension
    }
  
}


//MARK:- //
extension ChatVC{
    
    
    func tableViewScrollToBottom(animated: Bool) {
        
        DispatchQueue.main.async {
            let numberOfSections = self.tableChat.numberOfSections
            let numberOfRows = self.tableChat.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableChat.scrollToRow(at: indexPath, at: .none, animated: animated)
                self.tableChat.isHidden = false
            }
        }
    }
    
    //send message
    func sendMessageNew(){
        
        self.txtViewChat.text = self.txtViewChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtViewChat.isScrollEnabled = false
        isChatAppearFirst = true
        isSendButtonClicked = false
        
        
        self.txtViewChat.text = self.txtViewChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtViewChat.isScrollEnabled = false
        self.txtViewChat.frame.size.height = self.txtViewMsgMinHeight
        
        if self.txtViewChat.text == "" {
            print("Type Something..")
           // self.forTextViewPlaceHolder()

            return
        }else{
            message = self.txtViewChat.text
            self.imgType = 0
            
          //  print("self.txtViewChat.text is \(self.txtViewChat.text)")
            self.writeDataOnFirebaseForChatNew()
        }
        
        self.viewZoomImg.isHidden = true
        self.imgZoomImage.image = nil
        self.txtViewChat.text = ""
    }
    
    //MARK:- Alert for validation
    func showAlert(message: String, title: String = "", controller: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK".localize, style: .default, handler: nil)
        alertController.addAction(OKAction)
        controller.present(alertController, animated: true, completion: nil)
    }
}


//MARK: - Textview delegate methods

extension ChatVC:UITextViewDelegate{
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.isChatAvaible == true {
            self.createTypingStatus()
        }else{
            
        }
        
        self.viewMenu.isHidden = true
        if isImageSend == true{
            isImageSend = false
            //  AppSharedClass.shared.isNotificationTapped = true
        }else{
            // AppSharedClass.shared.isNotificationTapped = false
        }
        
        if self.txtViewChat.text == "\n"{
            
            self.txtViewChat.resignFirstResponder()
        }else{
            
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView){

        if txtViewChat.text == "" {
            self.placeholderLabel.isHidden = false
        }else{
            self.placeholderLabel.isHidden = true
        }
        
        
        if self.blockedBy == BlockStatus.kBlockedByMe || self.blockedBy == BlockStatus.kBlockedByBoth || self.blockedBy == BlockStatus.kBlockedByOpponent  {
            
            return
            
        }else{
            
        }
        self.viewMenu.isHidden = true
        
        if self.txtViewChat.contentSize.height >= self.txtViewMsgMaxHeight{
            self.txtViewChat.isScrollEnabled = true
        }
        else
        {
            self.txtViewChat.frame.size.height = self.txtViewChat.contentSize.height
            self.txtViewChat.isScrollEnabled = false
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        let indexPath = IndexPath(row: self.arrMessages.count - 1, section: 0)
        
        if self.arrMessages.count > 0{
            
            if isTableScrollToTop == false {
                
                self.tableChat.scrollToRow(at: indexPath, at: .top, animated: true)
            } else {
                //self.tableChat.scrollToRow(at: indexPath, at: .top, animated: true)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        timer.invalidate()
        seconds = 0
        if self.isChatAvaible == true {
            self.removeTypingStatus()
        }else{
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if self.isChatAvaible == true {
            self.createTypingStatus()
        }else{
            
        }
        
        let text = self.txtViewChat.text! as NSString
        var substring: String = txtViewChat.text!
        substring = (substring as NSString).replacingCharacters(in: range, with: text as String)
        substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        self.searchAutocompleteEntries(withSubstring: substring)
        
        return true
    }
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        if substring != "" {
            // to limit network activity, reload half a second after last key press.
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 3)
        }
        
    }
    
    @objc func reload() {
        if self.isChatAvaible == true {
            self.removeTypingStatus()
        }else{
            
        }
        
    }
    
    
    func createTypingStatus(){
        let ref = Database.database().reference()
       //  ref.child("chat_history").child(self.strOpponentId).child(self.strChatRoom).updateChildValues(["typing": 1]) // arjun
         ref.child("chat_history").child(self.strLoginUserId).child(self.strChatRoom).updateChildValues(["typing": 1]) // deepak
    }
    
    func removeTypingStatus(){
        let ref = Database.database().reference()
//        var strChatHistoryId = ""
//        var strOpponentId = ""
//        strOpponentId = self.strOpponentId
//        strChatHistoryId = self.strChatRoom
// ref.child("chat_history").child(self.strOpponentId).child(self.strChatRoom).updateChildValues(["typing": 0]) // arjun
        ref.child("chat_history").child(self.strLoginUserId).child(self.strChatRoom).updateChildValues(["typing": 0]) // deepak
    }
    func forTextViewPlaceHolder(){
    self.placeholderLabel = UILabel()
    self.placeholderLabel.text = "Type Something..".localize
    self.placeholderLabel.textAlignment = .center
    self.placeholderLabel.font = UIFont.init(name: "Poppins-Medium", size: 9.3)
    self.placeholderLabel.sizeToFit()
    self.txtViewChat.addSubview(self.placeholderLabel)
    //   self.placeholderLabel.frame.origin = CGPoint(x: self.txtViewChat.frame.width / 2, y: self.txtViewChat.frame.height / 2)
    //        self.placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtViewChat.font?.pointSize)! / 5)
        self.placeholderLabel.frame.origin = .init(x: 5, y: 8)
    self.placeholderLabel.textColor = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1)
    }
}

//MARK:- Tableview delegate methods
extension ChatVC:UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objChat = arrMessages[indexPath.row]
        let arrTime = objChat.strTimeStamp.components(separatedBy: " ")
        let msgtimeOnly = arrTime[1]
        let msgAM_PM = arrTime[2]
        let msgtime = msgtimeOnly+" "+msgAM_PM
        let strSenderChatId = objChat.strOppId
        let strUserId = objAppShareData.UserDetail.strUserID
        //        print("strSenderChatId is \(strSenderChatId)")
        //        print("strUserId is \(strUserId)")
        if strSenderChatId == strUserId {
            
            if objChat.strIsImage == 1 {
                
                let cellIdentifier = "MyImageCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MyImageCell
                cell.imgMySide.image = #imageLiteral(resourceName: "chat_placeholder_img")
                cell.viewMsgDay.isHidden = true
                
                if objChat.strImageURL == ""{
                    cell.imgMySide.image = #imageLiteral(resourceName: "chat_placeholder_img")
                    
                }else{
                    if let urlImg_1 = URL(string: objChat.strImageURL){
                        // cell.imgMySide.af_setImage(withURL: urlImg_1, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        cell.imgMySide.sd_setImage(with: urlImg_1, placeholderImage: #imageLiteral(resourceName: "chat_placeholder_img"))
                    }
                    
                }
                
                
                                if objChat.isMsgRead == 1  {
                                    cell.imgSeen.image = #imageLiteral(resourceName: "read_ico")
                
                                }else{
                                    cell.imgSeen.image = #imageLiteral(resourceName: "unread_ico2")
                                }
                
                cell.lblMyMsgTime.text = msgtime
                cell.btnZoomImage.tag = indexPath.row
                cell.btnZoomImage.addTarget(self, action:#selector(btnZoomImage(sender:)) , for: .touchUpInside)
                
                cell.lblMsgDay.text = objChat.strRelativePastTime
                if indexPath.row == 0 {
                    if self.isLastMsg == true{
                        //cell.viewMsgDay.isHidden = false
                        cell.viewMsgDay.isHidden = false // deepak
                    }
                } else {
                    let objChatDay = arrMessages[indexPath.row - 1]
                    if (objChat.strRelativePastTime == objChatDay.strRelativePastTime) {
                        cell.viewMsgDay.isHidden = true
                    } else {
                        cell.viewMsgDay.isHidden = false
                    }
                }
                cell.btnZoomImage.tag = indexPath.row
                cell.btnZoomImage.addTarget(self, action:#selector(btnZoomImage(sender:)) , for: .touchUpInside)
                return cell
                
            }else{
                
                let cellIdentifier = "MyTextCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MyTextCell
                cell.lblMyMessage.text = objChat.strMessage
                cell.lblMyMsgTime.text = msgtime
                cell.viewMsgDay.isHidden = true
                
                                if objChat.isMsgRead == 1  {
                                    cell.imgSeen.image = #imageLiteral(resourceName: "read_ico")
                                }else{
                                   cell.imgSeen.image = #imageLiteral(resourceName: "unread_ico2")
                                }
                cell.lblMsgDay.text = objChat.strRelativePastTime
                if indexPath.row == 0 {
                    if self.isLastMsg == true{
                        //      cell.viewMsgDay.isHidden = false
                        cell.viewMsgDay.isHidden = false // deepak
                    }
                } else {
                    let objChatDay = arrMessages[indexPath.row - 1]
                    if (objChat.strRelativePastTime == objChatDay.strRelativePastTime) {
                        cell.viewMsgDay.isHidden = true
                    } else {
                        cell.viewMsgDay.isHidden = false
                    }
                }
                
                return cell
            }
        }else{
            
            if objChat.strIsImage == 1 {
                
                let cellIdentifier = "OpponentImageCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OpponentImageCell
                // cell.OppImageIndicator.isHidden = true
                cell.viewMsgDay.isHidden = true
                
                cell.lblOppoName.isHidden = true

                
//                if objChat.strOppId == "A" {
//                    cell.lblOppoName.textColor = #colorLiteral(red: 0.9994242787, green: 0.7029308677, blue: 0, alpha: 1)
//                    cell.lblOppoName.text = "Admin".localize
//                }else{
//                    cell.lblOppoName.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
//                    cell.lblOppoName.text = self.strOpponentName
//                }
                
                if objChat.strImageURL == ""{
                    
                    cell.imgOppSide.image = #imageLiteral(resourceName: "chat_placeholder_img")
                }else{
                    
                    if let urlImg_1 = URL(string: objChat.strImageURL){
                        // cell.imgOppSide.af_setImage(withURL: urlImg_1, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        cell.imgOppSide.sd_setImage(with: urlImg_1, placeholderImage: #imageLiteral(resourceName: "chat_placeholder_img"))
                    }
                    
                }
                
                cell.lblOppMsgTime.text = msgtime
                cell.btnZoomImage.tag = indexPath.row
                cell.btnZoomImage.addTarget(self, action:#selector(btnZoomImage(sender:)) , for: .touchUpInside)
                cell.lblMsgDay.text = objChat.strRelativePastTime
                if indexPath.row == 0 {
                    if self.isLastMsg == true{
                        cell.viewMsgDay.isHidden = false
                    }
                } else {
                    let objChatDay = arrMessages[indexPath.row - 1]
                    if (objChat.strRelativePastTime == objChatDay.strRelativePastTime) {
                        cell.viewMsgDay.isHidden = true
                    } else {
                        cell.viewMsgDay.isHidden = false
                    }
                }
                cell.btnZoomImage.tag = indexPath.row
                cell.btnZoomImage.addTarget(self, action:#selector(btnZoomImage(sender:)) , for: .touchUpInside)
                return cell
            }
            else{
                
                let cellIdentifier = "OpponentTextCell"
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OpponentTextCell
                cell.lblOppMessage.text = objChat.strMessage
                cell.lblOppMsgTime.text = msgtime
                
                cell.viewMsgDay.isHidden = true
                cell.lblOppoName.isHidden = true
                
                
                
//                if objChat.strOppId == "A" {
//                    cell.lblOppoName.textColor = #colorLiteral(red: 0.9176470588, green: 0.007843137255, blue: 0.007843137255, alpha: 1)
//                    cell.lblOppoName.text = "Admin".localize
//                }else{
//                    cell.lblOppoName.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
//                    cell.lblOppoName.text = self.strOpponentName
//                    print("self.strOpponentName is \(self.strOpponentName)")
//                }
                
                cell.lblMsgDay.text = objChat.strRelativePastTime
                if indexPath.row == 0 {
                    if self.isLastMsg == true{
                        cell.viewMsgDay.isHidden = false
                    }
                } else {
                    let objChatDay = arrMessages[indexPath.row - 1]
                    if (objChat.strRelativePastTime == objChatDay.strRelativePastTime) {
                        cell.viewMsgDay.isHidden = true
                    } else {
                        cell.viewMsgDay.isHidden = false
                    }
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.viewMenu.isHidden = true
        if self.txtViewChat.text.count > 0{
            
            self.txtViewChat.isScrollEnabled = false
            
        }else{
            
            self.txtViewChat.isScrollEnabled = false
            
        }
        self.viewMenu.isHidden = true
        self.view.endEditing(true)
        bottem.constant = 7
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // self.lastContentOffset = scrollView.contentOffset.y
        
        if self.arrMessages.count > 0{
            
            //            self.viewMsgDay.isHidden = false
            //            self.viewMsgDayBack.isHidden = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //self.setView(view: self.viewMsgDay, hidden: true)
        // self.setView(view: self.viewMsgDayBack, hidden: true)
        
        if (self.tableChat.indexPathsForVisibleRows)!.count>0{
            let indexPath = self.tableChat.indexPathsForVisibleRows![0]
            if indexPath.row<=25 && !self.isLoading{
                if self.arrMessages.count < 50 {
                    self.isLastMsg = true
                    return
                }
                let obj = self.arrMessages[0]
                if self.strPaginationKey != obj.strKey{
                    self.isLoading = true
                    self.isPullToRefresh = true
                    
                    DispatchQueue.main.async {
                        self.observeOrderMessages(lastMessageKey: obj.strKey)
                        
                    }
                }else{
                    self.isLastMsg = true
                }
            }
        }
    }
    
    func setView(view: UIView, hidden: Bool) {
        UIView.transition(with: view, duration: 3, options: .transitionCrossDissolve, animations: {
            view.isHidden = hidden
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.viewMenu.isHidden = true
        if (self.tableChat.indexPathsForVisibleRows)!.count>0{

        }
        
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            // moved to bottom
            isTableScrollToTop = false
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            // moved to top
            isTableScrollToTop = true
        } else {
            // didn't move
        }
    }
    
    @objc func btnZoomImage(sender: UIButton!) {
        
        
       if  self.arrMessages.count > 0  {
        
        self.viewMenu.isHidden = true
        self.view.endEditing(true)
        bottem.constant = 7
        
        let objChat = arrMessages[sender.tag]
        if objChat.strImageURL.hasPrefix("gs://") || objChat.strImageURL.hasPrefix("http://") || objChat.strImageURL.hasPrefix("https://") {
            self.viewZoomImg.isHidden = false
            if let urlImg_1 = URL(string: objChat.strImageURL){
                 // self.imgZoomImage.af_setImage(withURL: urlImg_1, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                
                  self.imgZoomImage.sd_setImage(with: urlImg_1, placeholderImage: #imageLiteral(resourceName: "chat_placeholder_img"))
            }
            
            //            let urlImg_1 = URL(string: objChat.strImageURL)
            //            self.imgZoomImage.kf.setImage(with: urlImg_1, placeholder: #imageLiteral(resourceName: "inactive_profile_ico"))
            
        }else{
            
            self.viewZoomImg.isHidden = true
        }
        
    }
    }
}

//MARK: - firebase chat data
extension ChatVC{
    
    func timeInMiliSeconds() -> String {
        let date = Date()
        let timeInMS = "\(Int(date.timeIntervalSince1970 * 1000))"
        
        return timeInMS
    }
}


//MARK: - IBAction methods
extension ChatVC{
    
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        bottem.constant = 7
        self.viewMenu.isHidden = true
        self.isChatAvaible = false
        if objAppShareData.isFromObserverCalled == true {
            self.isChatAvaible = false
            objAppShareData.isFromObserverCalled = false
            //objAppShareData.isFromOrderchat = false
          //  objAppShareData.isOnChatScreen = false
            self.navigationController?.popViewController(animated: true)
            
        }

        else{
            self.isChatAvaible = false
            objAppShareData.isFromObserverCalled = false
            //objAppShareData.isFromOrderchat = false
          //  objAppShareData.isOnChatScreen = false
            self.view.endEditing(true)
            bottem.constant = 7
            self.viewMenu.isHidden = true
           self.navigationController?.popViewController(animated: true)
        }
         objAppShareData.opponentUserId = ""
        objAppShareData.isOnChatScreen = false
     
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        bottem.constant = 7
        if self.viewMenu.isHidden == false{
            self.viewMenu.isHidden = true
        }else{
            self.viewMenu.isHidden = false
        }
    }
    
    @IBAction func btnBlockAction(_ sender: UIButton) {
        self.viewMenu.isHidden = true
        self.view.endEditing(true)
        bottem.constant = 7
        self.changeBlockStatusOfOpponent()
    }
    

    
    @IBAction func btnDeleteChatAction(_ sender: UIButton) {
        self.viewMenu.isHidden = true
        self.view.endEditing(true)
        bottem.constant = 7
        self.alertforDeleteChat()
    }
   
    
    @IBAction func btnImageUpload(_ sender: UIButton) {
        
        //   AppSharedClass.shared.isNotificationTapped = true
        
        self.viewMenu.isHidden = true
        if self.txtViewChat.text.count > 0{
            
            self.txtViewChat.isScrollEnabled = false
            
        }else{
            self.txtViewChat.isScrollEnabled = false
            
        }
        
        if !NetworkReachabilityManager()!.isReachable{
            // objWebServiceManager.StopIndicator()
            return
        }
        
        if self.blockedBy == BlockStatus.kBlockedByMe || self.blockedBy == BlockStatus.kBlockedByBoth {
            
            if self.txtViewChat.text.count > 0{
                
                self.txtViewChat.isScrollEnabled = false
                
            }else{
                
                self.txtViewChat.isScrollEnabled = false
                
            }
            self.view.endEditing(true)
            bottem.constant = 7
            isFromBlock = true

            self.vwbottomforBlock.isHidden = false
            self.lblbottomBlock.text = "\("You_have_blocked".localize) " + self.strOpponentName + " \("Can't_send_any_message.".localize)"
             //new case block
            
            return
            
        }else if self.blockedBy == BlockStatus.kBlockedByOpponent  {
            
            if self.txtViewChat.text.count > 0{
                self.txtViewChat.isScrollEnabled = false
                
            }else{
                self.txtViewChat.isScrollEnabled = false
            }
            self.view.endEditing(true)
            bottem.constant = 7
            isFromBlock = true
     
            self.vwbottomforBlock.isHidden = false
            self.lblbottomBlock.text = "\("You_are_blocked_by".localize) " + self.strOpponentName + " \("Can't_send_any_message.".localize)"

             //// new case block
            return
        }
        
        if self.txtViewChat.text.count > 0{
            self.txtViewChat.isScrollEnabled = false
            
        }else{
            self.txtViewChat.isScrollEnabled = false
            
        }
        self.view.endEditing(true)
        bottem.constant = 7
        isFromBlock = true
        let alert:UIAlertController = UIAlertController(title: "Choose_Image".localize, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            objAppShareData.checkCameraPermissions(handler: { [weak self](isGranted) in
                guard let strongSelf = self else{return}
                if isGranted{
                    strongSelf.openCamera()
                }
            })
        }
        
        let galleryAction = UIAlertAction(title: "Gallery".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            objAppShareData.checkCameraPermissions(handler: { [weak self](isGranted) in
                guard let strongSelf = self else{return}
                if isGranted{
                    strongSelf.openGallary()
                }
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: UIAlertAction.Style.cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCancelViewZoom(_ sender: UIButton) {
        
        self.view.endEditing(true)
        bottem.constant = 7
        self.scrollViewImg.zoomScale = 1.0
        self.viewZoomImg.isHidden = true
    }
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        
        

        if !NetworkReachabilityManager()!.isReachable{
            // objWebServiceManager.StopIndicator()
            return
        }
        
        if (txtViewChat.text?.isEmpty)!{

           // self.txtViewChat.text = "."
            self.txtViewChat.text = self.txtViewChat.text.trimmingCharacters(in: .whitespacesAndNewlines)
            self.txtViewChat.isScrollEnabled = false
            self.txtViewChat.frame.size.height = self.txtViewMsgMinHeight
            self.txtViewChat.text = ""
            self.placeholderLabel.isHidden = false

            if self.txtViewChat.text.count > 0{
                
                self.txtViewChat.isScrollEnabled = false
                
            }else{
                self.txtViewChat.isScrollEnabled = false
            }
            
        }else{

            isSendButtonClicked = true
            self.txtViewChat.frame.size.height = self.txtViewMsgMinHeight
            DispatchQueue.main.async {
                self.sendMessageNew()
            }
            if self.txtViewChat.text.count > 0{
                self.txtViewChat.isScrollEnabled = false
                
            }else{
                self.txtViewChat.isScrollEnabled = false
            }
            
           self.placeholderLabel.isHidden = false
            
        }
    }
    
    func alertforBlockOpponent(){
        let alert = UIAlertController(title: kAlert.localize, message: "Do_you_want_to_block".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.blockOpponent()
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func alertforUnBlockOpponent(){
        let alert = UIAlertController(title: kAlert.localize, message: "Do_you_want_to_unblock".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.unblockOpponent()
            
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alertforDeleteChat(){
        let alert = UIAlertController(title: kAlert.localize, message: "Are_you_sure_you_want_to_delete_all_conversation?".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            self.deleteChat()
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func deleteChat(){
        self.view.endEditing(true)
        bottem.constant = 7
      //  self.viewFor_Block_Delete.isHidden = true
        self.viewMenu.isHidden = true
        var strChatHistoryId = ""
        var strUserId = ""
        strUserId = strLoginUserId
        strChatHistoryId = self.strChatRoom
         if self.arrMessages.count > 0{
            
             self.isClearChat = true
             let objMessage  = self.arrMessages.last
             let strTimestamp = objMessage?.TimeStamp
             let dict = ["timestamp":strTimestamp ?? ""] as [String : Any]
                 
             self.ref = Database.database().reference()
            
            ref.child("chat").child(self.strChatRoom).child("delete").child(strUserId).setValue(dict)
            self.ref.child("chat_history").child(strUserId).child(strChatHistoryId).updateChildValues(["last_message": ""])
            self.ref.child("chat_history").child(strUserId).child(strChatHistoryId).updateChildValues(["image": 0])
     
         }
        
    }
    
      func getDeletechat(){
//          var strUserId = ""
//          strUserId = strLoginUserId

    
       //   print(self.strChatRoom,strUserId)
          
            //  _refHandle = self.ref.child("chat").child("product_chat").child(self.strChatRoom).child("delete").child(strUserId).observe(.value, with: { [weak self] (snapshot) -> Void in
                 
        _refHandle = self.ref.child("chat").child(self.strChatRoom).child("delete").child(self.strLoginUserId).observe(.value, with: { [weak self] (snapshot) -> Void in

                
                  print("snapshot = \(snapshot)")
              
                  guard let dict = snapshot.value as? [String:Any] else { return }
                            
                  let strTimeStamp = dict["timestamp"] as? Double ?? 0
                  self?.messageTimeStamp = strTimeStamp
                      print("last get time stam \(strTimeStamp)")
                  if self?.isClearChat == true {
                      self?.isClearChat = false
                    self?.lblNoMessage.isHidden = false // deepak
                    self?.tableChat.isHidden = true // deepak
                      self?.arrMessages.removeAll()
                      self?.tableChat.reloadData()
                  }else{
                    self?.lblNoMessage.isHidden = true // deepak
                    self?.tableChat.isHidden = false // deepak
                  }
                  
              })
                        
      }
    
}



//MARK: - Send text data to firebase
extension ChatVC{
    
    func writeDataOnFirebaseForChatNew(){
        
        txtViewChat.contentSize.height = 35
        
        let calendarDate = ServerValue.timestamp()
         print("self.isOpponentOnline is \(self.isOpponentOnline)")
        
        let dictOrder = [
            "image":0,
            "image_url":  "",
            "msg_read_tick":0,
            "message":message,
            "timestamp":calendarDate,
            "reference _id": self.strReferenceID ,
            "order_Id_ride_id": self.strOrderRideId ,
            "msg_sender_id": objAppShareData.UserDetail.strUserID ] as [String : Any]
        let dictOther = [
            "value":0,
            ] as [String : Any]
        
        print(dictOrder)
        self.isChatAppearFirst = true
        
        self.ref = Database.database().reference()
        
        let Key12 = self.ref.child("chat").childByAutoId()
        let childautoID12 =  Key12.key!
        
        ref.child("chat").child(self.strChatRoom).child("messages").child(childautoID12).setValue(dictOrder)
       // ref.child("chat").child(self.strChatRoom).child("other").child(childautoID12).setValue(dictOther)
        ref.child("chat").child(self.strChatRoom).child("other").setValue(dictOther)
        self.strTextNotification = message
        self.UpdateHistory()
       // self.txtViewChat.resignFirstResponder()
//        self.ref = Database.database().reference()
//        self.ref.child("chat_history").child(self.strLoginUserId).child(self.strChatRoom).updateChildValues(["unread_count": 0])
    }
}
//MARK: - imagePicker extension method
extension ChatVC{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        isImagePicked = true
        isImageSend = true
        
        var img : UIImage?
        if let image = info[.editedImage] as? UIImage {
            
            img = image
            self.strTextNotification = "Sent an image"
            if let url = info[.referenceURL] as? NSURL {
                
                self.localImagePath = url.absoluteString ?? ""
            }
        }
//        else if let image = info[.originalImage] as? UIImage {
//
//            img = image
//            self.strTextNotification = "Sent an image"
//            if let url = info[.referenceURL] as? NSURL {
//
//                self.localImagePath = url.absoluteString ?? ""
//
//            }
//        }
        
        if let Image = img {
            self.strTextNotification = "Sent an image"
            imgZoomImage.image = Image
            
            self.uploadImageToFirebaseStorage(image: Image) { [weak self](firebaseImageUrl) in
                guard let weakSelf = self else{return}
                weakSelf.sendImageWithFirebaseURL(strLocalFileUrl: firebaseImageUrl)
            }
        }
        UIApplication.shared.endIgnoringInteractionEvents()

        objAppShareData.isOnChatScreen = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        self.viewZoomImg.isHidden = true
        picker.dismiss(animated: false, completion: nil)
        print("picker cancel.")
    }
    
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.allowsEditing = true
            self .present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    func openGallary(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - Compess image resize
extension ChatVC{
    
    func compressImage(image:UIImage) -> Data? {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1600.0
        let maxWidth : CGFloat = 1000.0
        let minHeight : CGFloat = 150.0
        let minWidth : CGFloat = 150.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        let minRatio : CGFloat = minWidth/minHeight
        var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else{
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 1
            }
        }
        
        if (actualHeight < minHeight || actualWidth < minWidth){
            if(imgRatio > minRatio){
                //adjust width according to maxHeight
                imgRatio = minHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = minHeight
            }
            else if(imgRatio < minRatio){
                //adjust height according to maxWidth
                imgRatio = minWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = minWidth
            }
            else{
                actualHeight = minHeight
                actualWidth = minWidth
                compressionQuality = 1
            }
        }
        
        let rect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        guard let img = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        guard let imageData = img.jpegData(compressionQuality:0.75) else{
            return nil
        }
        return imageData
    }
}

//MARK: - send image on firebase
extension ChatVC{
    
    func uploadImageToFirebaseStorage(image : UIImage, completion:@escaping (String)->Void){
        objWebServiceManager.StartIndicator()
               
       let imageData = self.compressImage(image: image) as Data?
        let localFilePath = "\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        let upload_metadata = StorageMetadata()
        upload_metadata.contentType = "image/jpeg"
        
        let storageImage = self.storageRef.child(localFilePath)
        storageImage.putData(imageData!, metadata: upload_metadata) { [weak self] (download_metadata, error) in
            storageImage.downloadURL { (url, error) in
                self?.view.endEditing(true)
                let downloadURL = url
                self!.imgUrl = downloadURL!.absoluteString
                //  print(">> imgUrl =  \(self!.imgUrl)")
                completion((self?.imgUrl)!)
            }
        }
    }
    
    func sendImageWithFirebaseURL(strLocalFileUrl: String) {
        objWebServiceManager.StartIndicator() // new
        let calendarDate = ServerValue.timestamp()
        
        let dictOrder = [
            "image":1,
            "image_url":  strLocalFileUrl,
            "msg_read_tick":0,
            "message":"",
            "timestamp":calendarDate,
            "reference _id": self.strReferenceID ,
            "order_Id_ride_id": self.strOrderRideId ,
            "msg_sender_id": objAppShareData.UserDetail.strUserID ] as [String : Any]
        
        let dictOther = [
            "value":0,
            ] as [String : Any]
            
            as [String : Any]
        
        print(dictOrder)
        
        self.ref = Database.database().reference()
        
        let Key12 = self.ref.child("chat").childByAutoId()
        let childautoID12 =  Key12.key!
        
        ref.child("chat").child(self.strChatRoom).child("messages").child(childautoID12).setValue(dictOrder)
       // ref.child("chat").child(self.strChatRoom).child("other").child(childautoID12).setValue(dictOther)
        ref.child("chat").child(self.strChatRoom).child("other").setValue(dictOther)
        message = ""
        self.imgType = 1
        self.UpdateHistory()
        objWebServiceManager.StopIndicator()
        UIApplication.shared.endIgnoringInteractionEvents()

      // self.tableViewScrollToBottom(animated: false)// new
    }
}

//MARK: - get data from  firebase
extension ChatVC{
    
    //MARK:- get order messages
    func observeOrderMessages(lastMessageKey:String?) {
        self.isClearChat = false
        self.isLastMsg = true
        // ref.child("chat").child(strChatHistoryId).child("messages").child(childautoID12).setValue(dictOrder)
     
        let messageQuery = self.ref.child("chat").child(self.strChatRoom).child("messages").queryEnding(atValue: nil, childKey: lastMessageKey) .queryLimited(toLast: 50)
        newMessageRefHandle = messageQuery.observe(.value, with: { (snapshot) -> Void in
            
            self.strPaginationKey = lastMessageKey ?? ""
            
            if let dict = snapshot.value as? [String:Any]{
                // print(dict)
                self.lblNoMessage.isHidden = true

                self.parseChatData(dictN: dict)
            } else {
                self.arrMessages.removeAll()
                self.tableChat.reloadData()
                objWebServiceManager.StopIndicator()
                self.lblNoMessage.isHidden = false
            }
        })
    }
    
    func parseChatData(dictN:[String:Any]){
        
        for dictxxx in dictN{
            let strKey = dictxxx.key
            let dict = dictxxx.value as! [String:Any]
            
            let objChat = ChatData()
            objChat.strKey = strKey
            objChat.strIsImage = dict["image"] as? Int ?? 0
            objChat.strImageURL = dict["image_url"] as? String ?? ""
            objChat.strMessage = dict["message"] as? String ?? ""
            objChat.isMsgRead = dict["msg_read_tick"] as? Int ?? 0
            objChat.strOppId = dict["msg_sender_id"] as? String ?? ""
            objChat.strOrderRideId = dict["order_Id_ride_id"] as? String ?? ""
            objChat.strReferenceId = dict["reference _id"] as? String ?? ""
            objChat.TimeStamp = dict["timestamp"] as? Double ?? 0
            let date = Date(timeIntervalSince1970: objChat.TimeStamp / 1000.0)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd hh:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
            objChat.strTimeStamp = dateFormatter.string(from: date)
            objChat.strRelativePastTime = self.relativePast(for: date)
            
            if self.arrMessages.contains(objChat){
              //  let index = self.arrMessages.index(of: objChat)
                let index = self.arrMessages.firstIndex(of: objChat)
                self.arrMessages.remove(at: index!)
                self.arrMessages.insert(objChat, at: index!)
                
            }else{
                //   print((Int(self.messageTimeStamp ?? 0)),(Int(objChat.TimeStamp) ?? 0))
                if (Int(objChat.TimeStamp) ?? 0) > (Int(self.messageTimeStamp ?? 0)) {
                    self.arrMessages.append(objChat)
                }else{
                    print("no match")
                }
            }
            //  print("arrmessages count",self.arrMessages.count)
        }
        
        self.arrMessages =  self.arrMessages.sorted(by: { $0.TimeStamp < $1.TimeStamp})
        
        UIView.performWithoutAnimation {
            tableChat.reloadData()
            self.tableViewScrollToBottom(animated: false)
            tableChat.layoutIfNeeded()
        }
        
        if isPullToRefresh && self.arrMessages.count > 50{
            let remain = (self.arrMessages.count+1)%50
            if remain == 0{
                let indexPath = IndexPath(row: 49, section: 0)
                self.tableChat.scrollToRow(at: indexPath, at: .top, animated: false)
                self.tableChat.isHidden = false
            }else{
                let indexPath = IndexPath(row: remain, section: 0)
                self.tableChat.scrollToRow(at: indexPath, at: .top, animated: false)
                self.tableChat.isHidden = false
            }
            self.tableChat.isHidden = false
            
        }else{
            if arrMessages.count > 0{
                if !(self.strPaginationKey.count>0 && arrMessages.count <= 50){
                    self.tableViewScrollToBottom(animated: false)
                }
            }
        }
        self.isPullToRefresh = false
        self.isLoading = false
        
//        self.readAllOpponentChat()
//        self.clearUnreadChatHistory()
//        self.getOpponentUnreadCount()
    
        
        if self.arrMessages.count == 0 {
            self.lblNoMessage.isHidden = false
            self.tableChat.isHidden = true
        }else{
            self.lblNoMessage.isHidden = true
            self.tableChat.isHidden = false
        }
   
    }
    
}


//MARK: - convert time
extension ChatVC {
    func relativePast(for date : Date) -> String {
        let units = Set<Calendar.Component>([.year, .month, .day, .weekOfYear])
        let components = Calendar.current.dateComponents(units, from: date, to: Date())
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let strDateTime = formatter.string(from: date)
        let arrDate = strDateTime.components(separatedBy: " ")
        
        var msgDateDay = 0
        var strDate = ""
        if arrDate.count == 2{
            let date1 = arrDate[0]
            var arrNew = date1.components(separatedBy: "-")
            arrNew = arrNew.reversed()
            msgDateDay = Int(arrNew[0])!
            strDate = arrNew.joined(separator: "/")
        }
        
        let currentDate = Date()
        let strCurrentDateTime = formatter.string(from: currentDate)
        let arrCurrentDate = strCurrentDateTime.components(separatedBy: " ")
        var currentDateDay = 0
        if arrCurrentDate.count == 2{
            let date2 = arrCurrentDate[0]
            var arrCurrentNew = date2.components(separatedBy: "-")
            arrCurrentNew = arrCurrentNew.reversed()
            currentDateDay = Int(arrCurrentNew[0])!
        }
        
        if components.year! > 0 {
            let str = converteDateMsgDay(strDateFromServer: strDate)
            return str
        } else if components.month! > 0 {
            let str = converteDateMsgDay(strDateFromServer: strDate)
            return str
        } else if components.weekOfYear! > 0 {
            let str = converteDateMsgDay(strDateFromServer: strDate)
            return str
        } else if (components.day! > 0) {
            if (components.day! > 1){
                let str = converteDateMsgDay(strDateFromServer: strDate)
                return str
            }else{
                // let str = converteDateMsgDay(strDateFromServer: strDate)
                //return str
                return "Yesterday".localize
            }
        } else {
            if currentDateDay>msgDateDay{
                return "Yesterday".localize
            }else{
                return "Today".localize
            }
        }
    }
    
    // Convert date formate
    func converteDateMsgDay(strDateFromServer: String) -> (String) {
        
        var strConvertedDate : String = ""
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let dateFromServer: Date? = dateFormatter.date(from: strDateFromServer)
        
        if let dateFromServer = dateFromServer {
            
           // dateFormatter.dateFormat = "MMMM dd, yyyy" //EEE, dd MMM"
            dateFormatter.dateFormat = "MMM dd, yyyy" //EEE, dd MMM"
            
            let strDate:String? = dateFormatter.string(from: dateFromServer)
            
            if let strDate = strDate {
                strConvertedDate = strDate
            }
        }
        return strConvertedDate
    }
}

//MARK:- Get Opponent details
extension ChatVC{
    
    func getOpponentDetailsFromFirebase(strOpponentId:String) {
        
        _refHandle = self.ref.child("users").child(strOpponentId).observe(.value, with: { [weak self] (snapshot) -> Void in
            
            guard let strongSelf = self else { return }
            if let dict = snapshot.value as? [String:Any]{
                strongSelf.parseDataOpponentDetail(dictResponce: dict)
            } else {
                
            }
        })
        self.tableChat.reloadData()
    }
    
    
    func parseDataOpponentDetail(dictResponce:[String:Any]){
        
        self.strOpponentName = dictResponce["full_name"] as? String ?? ""
        self.strOpponentUserId = dictResponce["user_id"] as? String ?? ""
        self.strSenderId = dictResponce["last_sender_id"] as? String ?? ""
        self.imgOpponentProfileImage = dictResponce["profile_picture"] as? String ?? ""
        self.showOppenentName()
        self.strOpponentFirebaseToken = dictResponce["firebase_token"] as? String ?? ""
        self.getOnlineStatusOpponent(dict: dictResponce)
        
        if let url = URL(string: self.imgOpponentProfileImage){
            //  self.imgOpponent.af_setImage(withURL: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
            self.imgOpponent.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
        }else{
            self.imgOpponent.image = #imageLiteral(resourceName: "inactive_profile_ico")
        }

        
        if isImagePicked == false {
            objWebServiceManager.StopIndicator()
            
        }
        self.tableChat.reloadData()// new
    }
    
    func showOppenentName(){
        print("self.strOpponentName is \(self.strOpponentName)")
        print("self.strReferenceID is \(self.strReferenceID)")
      
      
          var attr_UserName = NSMutableAttributedString()
          var attr_Event = NSMutableAttributedString()
          let strNameColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
      
      
        attr_UserName = NSMutableAttributedString(string:self.strOpponentName , attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-SemiBold", size: 13.3)!,NSAttributedString.Key.foregroundColor : strNameColor])
          
        attr_Event = NSMutableAttributedString(string: " (# " + self.strReferenceID + ")", attributes: [NSAttributedString.Key.font:UIFont(name: "Poppins-Regular", size: 9.7)!,NSAttributedString.Key.foregroundColor : strNameColor])
          let combination = NSMutableAttributedString()
              combination.append(attr_UserName)
                  combination.append(attr_Event)
      
      self.lblOpponentName.attributedText = combination
    }
      
    
    
    
    func getOnlineStatusOpponent(dict:[String:Any]){
        
        let strOnline = dict["online"] as? String ?? ""
        self.isOnline = strOnline
        
        if strOnline == "Online" {
            self.isOpponentOnline = 0
            
            if self.blockedBy == BlockStatus.kBlockedByMe || self.blockedBy == BlockStatus.kBlockedByBoth || self.blockedBy == BlockStatus.kBlockedByOpponent{
              //  self.viewOpponentOnline.isHidden = true
                //self.lblOrdernumber.text = "InActive"
                 self.lblOrdernumber.text = ""

            }else{
               // self.viewOpponentOnline.isHidden = true
                //self.viewOpponentOnline.isHidden = false
                self.lblOrdernumber.text = "Active_Now".localize
               self.lblOrdernumber.textColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)
            }
            
        }else{
            self.lblOrdernumber.text = ""
             self.isOpponentOnline = 0
        }
        
    }
    
}
//MARK: - keyboard methods
extension ChatVC{
    func observeKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
                
        let info = notification.userInfo
        let kbFrame = info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let animationDuration = (info?[UIResponder.keyboardAnimationDurationUserInfoKey] ?? 0.0) as? TimeInterval
        let keyboardFrame: CGRect? = kbFrame?.cgRectValue
        let height: CGFloat? = keyboardFrame?.size.height
        
        bottem.constant = height!
        UIView.animate(withDuration: animationDuration ?? 0.0, animations: {() -> Void in
            
            if self.arrMessages.count > 0{
            self.tableViewScrollToBottom(animated: false)
            }
     
            self.view.layoutIfNeeded()
        })
           self.vwScroll.isScrollEnabled = false

    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        let info = notification.userInfo
        let animationDuration = (info?[UIResponder.keyboardAnimationDurationUserInfoKey] ?? 0.0) as! TimeInterval
        isFromBlock = false
        bottem.constant = 7
        UIView.animate(withDuration: animationDuration , animations: {() -> Void in
            self.view.layoutIfNeeded()
        })
        
        self.vwScroll.isScrollEnabled = false
    }
}


//MARK: - Update History to firebase
extension ChatVC {
    
    func UpdateHistory(){
        print("self.strOpponentId is on chat vc update histoty \(self.strOpponentId)")
        print("self.strLoginUserId is on chat vc update histoty \(self.strLoginUserId)")
        print("objAppShareData.UserDetail.strRole  is  \(objAppShareData.UserDetail.strRole)")
        print("self.isChatAvaible is on chat vc update histoty \(self.isChatAvaible)")
        print("self.isChatAppearFirst is on chat vc update histoty \(self.isChatAppearFirst)")
        print("objAppShareData.isOnChatScreen is on chat vc update histoty \(objAppShareData.isOnChatScreen)")
       
        var senderId = ""
        if objAppShareData.UserDetail.strRole == "2" || objAppShareData.UserDetail.strRole == "3"  {
            senderId = self.strCustomerId
           // senderId = self.strDriverId
             print("driver type user is login")
        }else {
           senderId = self.strDriverId
           // senderId = self.strCustomerId
             print("customer type user is login")
        }

        let calendarDate = ServerValue.timestamp()
         //For My Side
        let dictSender = [
            "image":self.imgType,
            "image_url":  self.imgUrl,
            "last_message":message,
            "timestamp":calendarDate,
            "reference_id": self.strReferenceID ,
            "order_Id_ride_id": self.strOrderRideId ,
            "last_sender_id": senderId ,
            "unread_count": 0,
            "typing":0,
            "chat_type":"one_to_one"] as [String : Any]
       
        print("dictSender is \(dictSender)")
        self.ref.child("chat_history").child(objAppShareData.UserDetail.strUserID).child(self.strChatRoom).setValue(dictSender)
        
        unreadCount = unreadCount+1
        print(unreadCount)
    
          //For Opponent Side
        let dictOpponent = [
                   "image":self.imgType,
                   "image_url":  self.imgUrl,
                   "last_message":message,
                   "timestamp":calendarDate,
                   "reference_id": self.strReferenceID ,
                   "order_Id_ride_id": self.strOrderRideId ,
                   "last_sender_id": objAppShareData.UserDetail.strUserID ,
                   "unread_count": unreadCount,
                   "typing":0,
                   "chat_type":"one_to_one"] as [String : Any]
        
        print("dictOpponent is \(dictOpponent)")
               
        self.ref.child("chat_history").child(senderId).child(self.strChatRoom).setValue(dictOpponent)
        self.imgUrl = ""
        if isImagePicked == true{
            isImagePicked = false
        }else{
            self.txtViewChat.becomeFirstResponder()
        }
        objWebServiceManager.StopIndicator()
        //self.clearUnreadChatHistory()
         self.ChatNotification()
        // print("self.strChatRoom is \(self.strChatRoom)")
    }
}


//MARK: - Block User Methods
extension ChatVC {
    
    
    func checkBlockStatusForThisChatRoom() {
     
        _refHandle = self.ref.child("block_users").child(self.strChatRoom).observe(.value, with: {
            
            [weak self] (snapshot) -> Void in
            
            guard let strongSelf = self else { return }
            
            strongSelf.setBlockStatusWithData(snapshot: snapshot)
        })
    }
    
    func setBlockStatusWithData(snapshot:DataSnapshot){
        let struserId = objAppShareData.UserDetail.strUserID // var
        let strOpponentId = self.strOpponentId // var
        var strBlockedBy = ""
        
        var BlockedTimeStamp:Double = 0 
        if let dict = snapshot.value as? [String:Any]{
           // self.viewOpponentOnline.isHidden = true
             self.lblOrdernumber.text = ""
            strBlockedBy =  dict["blocked_by"] as? String ?? ""
            BlockedTimeStamp = dict["timestamp"] as? Double ?? 0
            
            switch strBlockedBy{
            case struserId:
                self.strBlockStatus = "1"
                self.blockedBy = BlockStatus.kBlockedByMe
                self.lblBlockTitle.text = "Unblock".localize
                self.vwbottomforBlock.isHidden = false
                self.lblbottomBlock.text = "\("You_have_blocked".localize) " + self.strOpponentName + ". \("Can't_send_any_message.".localize)"
            case strOpponentId:
                self.strBlockStatus = "1"
                self.blockedBy = BlockStatus.kBlockedByOpponent
                self.lblBlockTitle.text = "Block".localize
                self.vwbottomforBlock.isHidden = false
                self.lblbottomBlock.text = "\("You_are_blocked_by".localize) " + self.strOpponentName + ". \("Can't_send_any_message.".localize)"
                
                self.txtViewChat.text = ""
                self.placeholderLabel.isHidden = false
                self.txtViewChat.resignFirstResponder()
            case "Both":
                self.strBlockStatus = "1"
                self.blockedBy = BlockStatus.kBlockedByBoth
                self.lblBlockTitle.text = "Unblock".localize
                self.vwbottomforBlock.isHidden = false
               // self.lblbottomBlock.text = "You have blocked " + self.strOpponentName + " Can't send any message."
                self.lblbottomBlock.text = "You_have_blocked_each_other._Can't_send_\nany_message.".localize
                self.txtViewChat.text = ""
                self.placeholderLabel.isHidden = false
                self.txtViewChat.resignFirstResponder()
            default:
                self.strBlockStatus = ""
                self.blockedBy = BlockStatus.kBlockedByNone
                self.lblBlockTitle.text = "Block".localize
                self.vwbottomforBlock.isHidden = true
            }
            
        }
        else {
            if self.isOnline == "Online" {
               // self.viewOpponentOnline.isHidden = false
                self.lblOrdernumber.text = "Active_Now".localize
                 self.lblOrdernumber.textColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)

            }else{
               // self.viewOpponentOnline.isHidden = true
                 self.lblOrdernumber.text = ""

            }
            self.blockedBy = BlockStatus.kBlockedByNone
             self.vwbottomforBlock.isHidden = true
            self.strBlockStatus = ""
        }
        self.checkStatus()
        self.updateBlockUnblockButtonUI()
    }
    
    func updateBlockUnblockButtonUI(){
        
        if self.blockedBy == BlockStatus.kBlockedByMe || self.blockedBy == BlockStatus.kBlockedByBoth {
            //unblock image
            //               self.lblBlock_Unblock.text = "Unblock"
            //               self.lblBlock_UnblockMsg.text = "Do you want to unblock"
            //               self.lblBlock_UnblockUserName.text = strOpponentName
            
            self.lblBlockTitle.text = "Unblock".localize
        }else{
            //block image
            //               self.lblBlock_Unblock.text = "Block"
            //               self.lblBlock_UnblockMsg.text = "Do you want to block"
            //               self.lblBlock_UnblockUserName.text = strOpponentName
            
            self.lblBlockTitle.text = "Block".localize
        }
    }
    
    
    
    
    func changeBlockStatusOfOpponent(){
        
        if self.blockedBy == BlockStatus.kBlockedByNone || self.blockedBy == BlockStatus.kBlockedByOpponent {
            
            
            self.lblBlockTitle.text = "Block".localize
     
            self.alertforBlockOpponent()
            
        }else if self.blockedBy == BlockStatus.kBlockedByMe || self.blockedBy == BlockStatus.kBlockedByBoth {
            self.lblBlockTitle.text = "Unblock".localize
            //            self.lblBlock_Unblock.text = "Unblock"
            //            self.lblBlock_UnblockMsg.text = "Do you want to unblock"
            //            self.lblBlock_UnblockUserName.text = strOpponentName
            
            //  self.unblockOpponent()
            self.alertforUnBlockOpponent()
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            // objWebServiceManager.StopIndicator()
        }
       // self.getOpponentDetailsFromFirebase(strOpponentId: OpponentId)

    }
    
    
    
    
    func blockOpponent(){
            
        
        var dict = [NSString : Any]()
        //self.viewOpponentOnline.isHidden = true
         self.lblOrdernumber.text = ""
        // self.viewBlockStatus.isHidden = false
        
        
        if self.blockedBy == BlockStatus.kBlockedByOpponent  {
            
            dict = ["blocked_by":  "Both"]
        }else{
            
            dict = ["blocked_by":  objAppShareData.UserDetail.strUserID ]
        }
        self.ref.child("block_users").child(self.strChatRoom).setValue(dict)
        self.lblBlockTitle.text = "Unblock"
        
        self.vwbottomforBlock.isHidden = false
        
    }
    
    func unblockOpponent(){
        // self.viewBlockStatus.isHidden = true
       // self.viewOpponentOnline.isHidden = false
        self.lblOrdernumber.text = "Active_Now".localize
         self.lblOrdernumber.textColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)
        var dict = [NSString : Any]()

        
        if self.blockedBy == BlockStatus.kBlockedByBoth  {
            
            dict = ["blocked_by":  self.strOpponentId]
        }else{
            self.ref.child("block_users").child("blocked_by").setValue(nil)
        }
        //  self.ref.child("block_users").child(strBlockusersId).setValue(dict)
        self.ref.child("block_users").child(self.strChatRoom).setValue(dict)
        self.lblBlockTitle.text = "Block".localize
        self.vwbottomforBlock.isHidden = true
       
    }
}


//MARK:- Clear UnreadChatHistory method
extension ChatVC {
    
    func clearUnreadChatHistory(){
        var strChatHistoryId = ""
        var struserId = ""
        
        
        struserId = self.strLoginUserId
        strChatHistoryId = self.strChatRoom

        self._refHandle = self.ref.child("chat_history").child(self.strOpponentId).child(self.strChatRoom).observe(.value, with: { [weak self] (snapshot) -> Void in // new deepak

            guard let strongSelf = self else { return }
            print(snapshot)

                    if !objAppShareData.isOnChatScreen{
                          print("clearUnreadChatHistory isOnChatScreen")
                               return
                    }else{
                        print("clearUnreadChatHistory not isOnChatScreen")
                    }
                  //  print("clearUnreadChatHistory  update")
            
            
            if snapshot.exists(){
               
                if let dict = snapshot.value as? [String:Any]{
                    if let strMessage = dict["last_message"] as? String {
                        print(strMessage)
                         self?.isChatAvaible = true
                    }else{
                         self?.isChatAvaible = false
                    }
                    let isTyping = dict["typing"] as? Int ?? 0
                    if isTyping == 1 {
                        self?.viewOpponentNumber.isHidden = false
                        self?.lblOrdernumber.text = "typing...".localize
                        self?.lblOrdernumber.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                        
                    }else{
                        self?.lblOrdernumber.text = "Active_Now".localize
                        self?.lblOrdernumber.textColor = #colorLiteral(red: 0.3843137255, green: 0.3843137255, blue: 0.3843137255, alpha: 1)
       
                    }
                }
                strongSelf.ref = Database.database().reference()
                strongSelf.ref.child("chat_history").child(struserId).child(strChatHistoryId).updateChildValues(["unread_count": 0])
            
                
                if let refHandle = strongSelf._refHandle{
                    strongSelf.ref.child("chat_history").child(struserId).child(strChatHistoryId).removeObserver(withHandle: refHandle)

                }
            }else{
               self?.isChatAvaible = false
            }
        })
    }
    
    func getOpponentUnreadCount(){
        
 self.unreadCount = 0
        print(strOpponentId)
        
        
        _refHandle = self.ref.child("chat_history").child(self.strOpponentId).child(self.strChatRoom).observe(.value, with: { [weak self] (snapshot) -> Void in

        
            guard let dict = snapshot.value as? [String:Any] else { return }
            
            self?.unreadCount = dict["unread_count"] as? Int ?? 0
           // print("self?.unreadCount is \(self?.unreadCount)")
        })
    }
   
    
    func readAllOpponentChat() {
        
         self.ref.child("chat").child(self.strChatRoom).child("messages").observe(.childAdded, with: { [weak self]  (snapshot)  -> Void in
                           
               guard let strongSelf = self else { return }
                   
               let dictKey = snapshot.key
                print(dictKey)
            
                  
                   if let dict = snapshot.value as? [String:Any]{
                   
                     
                     let strSenderId = dict["msg_sender_id"] as? String ?? ""
                    
                    
                     print("strSenderId is on chat vc readAllOpponentCht \(strSenderId)")
                    print("self.strOpponentId is on chat vc readAllOpponentCht \(String(describing: self?.strOpponentId))")
                    
                   if !(objAppShareData.isOnChatScreen) {
                       return
                   }
                  
                   if strSenderId == (self?.strOpponentId)!{
                   
                    strongSelf.ref.child("chat").child((self?.strChatRoom)!).child("messages").child(dictKey).updateChildValues(["msg_read_tick":1])
                    
                    
                   }else{
                      return
                   }
                    
           }else {
               if !(self?.isImagePicked)! {
               }
           }
         })
      
    }
}
//MARK: - Webservice For Check Current Status
extension ChatVC{
    func callWsForCheckCurrentStatus(type : String , referenceId: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            //  objAlert.showAlert(message: NoNetwork , title: kAlert , controller: self)
            return
        }
        
        var param: [String: Any] = [:]
        param = [
            WsParam.referenceId: referenceId ,
            WsParam.referenceType: type
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.checkCurrentStatus, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            let status =   (response["status"] as? String)
            var roleformApi =  ""
            if status == "success"{
             
                
                
                if let dic = response["data"] as? [String:Any]{
                   
                   // if let dic = dic1["data"] as? [String:Any]{
                    
                    
                    if let name = dic["full_name"]as? String {
                        self.lblOpponentName.text =  name
                    }
                     
                    if let number = dic["number"]as? String {
                        self.strReferenceID =  number
                    }
                    self.showOppenentName()
                    self.strCurrentStatus = dictToStringKeyParam(dict: dic, key: "current_status")
                   roleformApi = dictToStringKeyParam(dict: dic, key: "role")
                   print("self.strCurrentStatus in string is \(self.strCurrentStatus)")
                   print("roleformApi is \(roleformApi)")
                        
                        
                   // }
                }
                
                self.checkStatus()
            }
            else
            {
                //   objAlert.showAlert(message:message ?? "", title: "Alert", controller: self)
            }
            
            
        }, failure: { (error) in
            print(error)
            // objAlert.showAlert(message:kErrorMessage, title: "Alert", controller: self)
            
        })
    }
    
    
    func checkStatus(){
        if self.strReferenceType == "2" {
            
            if self.strCurrentStatus == "6" {
                if self.strBlockStatus == "1" {
                    self.vwbottomforOrder.isHidden = true
                }else{
                 self.vwbottomforOrder.isHidden = false
                }
                //self.vwbottomforOrder.isHidden = false
                self.lblbottomOrder.text = "Your_order_successfully_completed_thank_you_for_connecting_us.".localize
            } else if self.strCurrentStatus == "7" {
                if self.strBlockStatus == "1" {
                    self.vwbottomforOrder.isHidden = true
                }else{
                 self.vwbottomforOrder.isHidden = false
                }
                
                // self.vwbottomforOrder.isHidden = false
                self.lblbottomOrder.text = "Your_order_cancelled_so_you_can't_send_message!".localize
            }else{
                 self.vwbottomforOrder.isHidden = true
            }
            
        }else  if self.strReferenceType == "1" {
            
            if self.strCurrentStatus == "6" {
                if self.strBlockStatus == "1" {
                    self.vwbottomforOrder.isHidden = true
                }else{
                 self.vwbottomforOrder.isHidden = false
                }
                
               //  self.vwbottomforOrder.isHidden = false
                self.lblbottomOrder.text = "Your ride successfully completed thank you for connecting us.".localize
            } else if self.strCurrentStatus == "7" {
                if self.strBlockStatus == "1" {
                    self.vwbottomforOrder.isHidden = true
                }else{
                 self.vwbottomforOrder.isHidden = false
                }
                
                 //self.vwbottomforOrder.isHidden = false
                self.lblbottomOrder.text = "Your_ride_cancelled_so_you_can't_send_message!".localize
            } else if self.strCurrentStatus == "0" {
                if self.strBlockStatus == "1" {
                    self.vwbottomforOrder.isHidden = true
                }else{
                 self.vwbottomforOrder.isHidden = false
                }
                 //self.vwbottomforOrder.isHidden = false
                self.lblbottomOrder.text = "Driver_cancelled_this_ride_so_you_can't_send_message!".localize
            }else{
                 self.vwbottomforOrder.isHidden = true
            }
            
            
        }
        
    }
    
//    func checkBottomViewStatus(){
//
//        if self.strCurrentStatus == "6" ||  self.strCurrentStatus == "7" {
//            self.vwbottomforOrder.isHidden = false
//        }else{
//            self.vwbottomforOrder.isHidden = true
//        }
//    }
}

//MARK: - Notification method
extension ChatVC{
    //
//MARK:-For badge count
    func getOpponentbadgeCount(){

//        self._refHandle  = self.ref.child("badge_count").child(self.strOpponentId).observe(.value, with: { [weak self] (snapshot) -> Void in
//
//            print("snapshot = \(snapshot)")
//            if snapshot.exists(){
//                if let dict = snapshot.value as? [String:Any] {
//                    self?.badgeCount = dict["count"] as? Int ?? 0
//                }
//            }else{
//            }
//        })
    }
    
    func ChatNotification(){
        
        _refHandle = self.ref.child("users").child(self.strOpponentId).observe(.value, with: { [weak self] (snapshot) -> Void in
            
            guard let strongSelf = self else { return }
            if let dict = snapshot.value as? [String:Any]{
                // strongSelf.parseDataOpponentDetail(dictResponce: dict)
                strongSelf.strOpponentFirebaseToken = dict["firebase_token"] as? String ?? ""
                
            } else {
                
            }
        })
        var count = 0
        var Badgecount = 0
         var Totalcount = 0
               self.ref.child("badge_count").child(self.strOpponentId).observeSingleEvent(of: .value, with: { [weak self] (snapshot) -> Void in
        
                   print("snapshot = \(snapshot)")
                
                   if snapshot.exists(){
                       if let dict = snapshot.value as? [String:Any] {
                            
                         if let dic = dict["chat_count"] as? [String:Any] {
                        count = dic["count"] as? Int ?? 0
//                            if let c = dic["count"] as? Int {
//                                count = c
//                            }else if let c = dic["count"] as? String {
//                                 count = Int(c)!
//                            }
                            
                        }
                        
                    if let dictt = dict["notification_count"] as? [String:Any] {
                     Badgecount = dictt["count"] as? Int ?? 0
                     }
//
                       }
                   }else{
                   }
                
                
                   print("Badgecount  is = \(Badgecount)")
                   print("count  is = \(count)")
                Totalcount = Badgecount + count
                 print("Totalcount  is = \(Totalcount)")
                
                let strNumber = " (# " + self!.strReferenceID + ")"
                
                 count = count + 1
                self!.ref.child("badge_count").child(self!.strOpponentUserId).child("chat_count").setValue(["count": count])
                 //Android
                        let messageDict = ["title":self!.strUserName + strNumber,
                                           "body": self!.strTextNotification,
                                           "senderId":self!.strLoginUserId,
                                           "recevierId":self!.strOpponentId,
                                           "chat_node":self!.strChatRoom,
                                           "reference_id":self!.strReferenceID,
                                           "reference_type": "",
                                           "current_status":"",
                                           "role":"",
                                           "type": "chat",
                                           "click_action":"ChatActivity",
                                           "sound": "default",
                                           "badge": Totalcount + 1] as [String : Any]
                        
                        //IOS
                        let notificationDict = ["title":self!.strUserName + strNumber,
                                                "body": self!.strTextNotification,
                                                "senderId":self!.strLoginUserId,
                                                "recevierId":self!.strOpponentId,
                                                "chat_node":self!.strChatRoom,
                                                "reference_id":self!.strReferenceID,
                                                "reference_type": "",
                                                "current_status":"",
                                                "role":"",
                                                "type": "chat",
                                                "click_action":"ChatActivity",
                                                "sound": "default",
                                                "badge": Totalcount + 1] as [String : Any]
                        let finalDict = ["to":self!.strOpponentFirebaseToken,
                                         "data": messageDict,
                                         "notification":notificationDict] as [String : Any]
                        self!.sendNotificationWithDict(dictNotification:finalDict)

               })
    
       
    }
    
    func sendNotificationWithDict(dictNotification:Dictionary<String, Any>){
        
        print("objAppShareData.kServerKey is on notification \(objAppShareData.kServerKey)")

        let serverKey = "key=" + objAppShareData.kServerKey
        
        
        let strUrl = "https://fcm.googleapis.com/fcm/send"
        var request = URLRequest.init(url: URL.init(string: strUrl)!)
        request.setValue(serverKey, forHTTPHeaderField: "Authorization")

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dictNotification, options: .prettyPrinted)
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { (data, response, err) in
            
        }.resume()
    }
}




