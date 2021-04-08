//
//  File.swift
//  Hoggz
//
//  Created by MACBOOK-SHUBHAM V on 26/12/19.
//  Copyright © 2019 MACBOOK-SHUBHAM V. All rights reserved.
//

import UIKit
//import SystemConfiguration
//import CoreLocation
import Firebase
//import MobileCoreServices
import Foundation


import AVFoundation
import AVKit
import Photos


class AppShareData: NSObject{
    
    var backgroundColor: UIColor?
    var fromPasswordreminder = false
    
    var successBlock : ((_ placeInfo: [String: Any])->())?
    var failureBlock : ((_ error: Error)->())?
    var controller: UIViewController?
    var imagePicker = UIImagePickerController()
    var isDriverProfile = false
    var isFromPayment = false
    var isFromZoom = false
    var isFromFilter = false
    var isFromPlacePicker = false
    var isFromCartList = false
    var isFromWallet = false
    var isFromSelectAddress = false
    var isOnChatScreen = false
    var isFromObserverCalled = false
    var isOnMapScreen = false
    var isOnDriverProfileScreen = false
    var isUpcomingDetailScreen = false
    
    var isUpcomingList = false // deepak new testing
    
    var strCardId = ""
    var strPaymentMethod = ""
    var dictUserLoction = [String:Any]()
    var dictRideLoction = [String:Any]()
    var dictVichleInfo = [String:Any]()
    
    var strSelectedVehicleCompanyId : String = ""
    var strSelectedVehicleMetaId : String = ""
    var strSelectedCompanyNames : String = ""
    var strSelectedModelNames : String = ""
    var arrSelectedBusinessId = [Int]()
    var arrSelectedCategoryId = [Int]()
    var arrSelectedLanguageId = [Int]()
    var arrSelectedLanguageName = [String]()
    
    var arrUsers = [user]()

    
    var strCategoryId = ""
    var strBusinessId = ""
    var strSourceLat = ""
    var strSourceLong = ""
    var strLoction = ""
    var strCurrentLoction = ""
    var strCurrentLat = ""
    var strCurrentLong = ""
    var strRadius = "5"
    var strRatingcount = "0"
    var  arrVechicleList        = [VehicleModel]()
    var UserDetail = userDetailModel(dict: [:])
    
    var strPromoCodeId = ""
    var strOfferTitle = ""
    var deliveryAddressId = ""
    var kServerKey = ""
    
    var isFromBannerNotification = false
    var strBannerNotificationType = ""
    var strBannerReferenceType = ""
    var strBannerReferenceID = ""
    var strBannerCurrentStatus = ""
    var strBannerChatRoom = ""
    var notificationBannerDict = [:] as? [String:Any]
    
    var opponentUserId = ""
    var ref: DatabaseReference?
    var refff: DatabaseReference!
    var strChatUnreadCount = 0
    var strAppIconCount = 0
    
    //MARK: - Shared object
    
    private static var sharedManager: AppShareData = {
        let manager = AppShareData()
        return manager
    }()
    
    // MARK: - Accessors
    class func sharedObject() -> AppShareData {
        return sharedManager
    }
    
    
    // MARK: - saveUpdateUserInfoFromAppshareData ---------------------
    func SaveUpdateUserInfoFromAppshareData(userDetail:[String:Any]){
        
        let myData = NSKeyedArchiver.archivedData(withRootObject: userDetail)
        UserDefaults.standard.set(myData, forKey: UserDefaults.KeysDefault.userInfo)
        
    }
    
    func saveDataInDeviceLogin(dict : [String:Any]){
        UserDefaults.standard.setValue(dict["authtoken"], forKey: UserDefaults.KeysDefault.kAuthToken)
        UserDefaults.standard.setValue(dict["onboarding_step"], forKey: UserDefaults.KeysDefault.kOnboardingStep)
        UserDefaults.standard.setValue(dict["profile_complete"], forKey: UserDefaults.KeysDefault.kProfileComplete)
        UserDefaults.standard.setValue(dict["role"], forKey: UserDefaults.KeysDefault.kRole)
        UserDefaults.standard.setValue(dict["userID"], forKey: UserDefaults.KeysDefault.kUserId)
        UserDefaults.standard.setValue(dict["device_token"], forKey: UserDefaults.KeysDefault.deviceToken)
        UserDefaults.standard.setValue(dict["stripe_connect_account_id"], forKey: UserDefaults.KeysDefault.KStripeConnectAccountId)
        // UserDefaults.standard.setValue(dict["account_number"], forKey: UserDefaults.KeysDefault.kAccountNo)
        
    }
    
    
    // MARK: - FetchUserInfoFromAppshareData -------------------------
    func fetchUserInfoFromAppshareData(){
        
        if let unarchivedObject = UserDefaults.standard.object(forKey:UserDefaults.KeysDefault.userInfo) as? NSData {
            let recived =     NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject as Data)
            
            UserDetail = userDetailModel.init(dict: recived as! [String : Any] )
            
        }
    }
    
    func resetDefaultsAlluserInfo(){
        let defaults = UserDefaults.standard
        let myVenderId = defaults.string(forKey:UserDefaults.KeysDefault.strVenderId)
        let fcmDevceToken = defaults.string(forKey:UserDefaults.KeysDefault.deviceToken)
        let userId = defaults.string(forKey:UserDefaults.KeysDefault.kUserId)
        let selectedlanguage =  UserDefaults.standard.string(forKey: "Selectdlanguage")
        
        
        // self.ref.child(pID).child("lock").removeAllObservers()
        self.refff?.child("chat_history").child(userId!).removeAllObservers()
        print("userId in resetDefaultsAlluserInfo in appsharedata \(String(describing: userId))")
        
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
        defaults.set(selectedlanguage, forKey:"Selectdlanguage")
        defaults.set(fcmDevceToken, forKey:UserDefaults.KeysDefault.deviceToken)
        defaults.set(myVenderId ?? "", forKey:UserDefaults.KeysDefault.strVenderId)
        UserDetail = userDetailModel(dict: [:])
        
    }
    
    
    func removeNSNull(from dict: [String: Any]) -> [String: Any] {
        var mutableDict = dict
        
        let keysWithEmptString = dict.filter { $0.1 is NSNull }.map { $0.0 }
        for key in keysWithEmptString {
            mutableDict[key] = ""
            print(key)
            
        }
        return mutableDict
    }
    
    // Array to json formate convert
    func json(from arrayAdtionalEmail:[String]) -> String? {
        
        var myJsonString = ""
        do {
            let data =  try JSONSerialization.data(withJSONObject:arrayAdtionalEmail, options: .prettyPrinted)
            myJsonString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            print(error.localizedDescription)
        }
        return myJsonString
    }
    
    
    func CalculateDays(strDate:String)-> String {
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date1 = dateformatter.date(from: strDate)
        let strDate = date1?.strrigWithFormat(format: "YYYY-MM-dd")
        var days = ""
        let startDate = Date()
        let endDateString = strDate
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        formatter.dateFormat = "YYYY-MM-dd"
        
        if let endDate = formatter.date(from: endDateString!) {
            let components = Calendar.current.dateComponents([.day], from: endDate, to: startDate)
            
            days = String(components.day!)
            //  print("Number of days: \(components.day!)")
        } else {
            days = ""
            //print("\(endDateString) can't be converted to a Date")
        }
        
        return days
    }
    
    func changeDateformat(strDate:String)-> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date1 = dateformatter.date(from: strDate)
        let strDate = date1?.strrigWithFormat(format: "MMM dd, YYYY hh:mm a") ?? ""
        
        let strTime = date1?.strrigWithFormat(format: "hh:mm a") ?? ""
        let strCurrentDate = date1?.strrigWithFormat(format: "MMM dd, YYYY") ?? ""
        
        // get current date
        
        let dateFormatter1 : DateFormatter = DateFormatter()
        dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter1.dateFormat = "MMM dd, YYYY"
        let date = Date()
        let dateString = dateFormatter1.string(from: date)
        
        
        //
        
        var returnDate = ""
        
        if strCurrentDate == dateString {
            returnDate = "\("Today".localize) , \(strTime)"
        }else{
            
            returnDate = strDate
        }
        
        return returnDate
        
        
    }
    
    
    func utcToLocal(strDateTime: String) {
        //   let dateString = "Thu, 22 Oct 2015 07:45:17 +0000"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_GB")
        
        let dateObj = dateFormatter.date(from: strDateTime)
        //  let dateObj = dateFormatter.date(from: createdAt)
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        print("Dateobj: \(dateFormatter.string(from: dateObj!))")
        
        //  let utcDate = Date().toGlobalTime()
        let utcDate = dateObj!.toGlobalTime()
        let localDate = utcDate.toLocalTime()
        
        print("utcDate - \(utcDate)")
        print("localDate - \(localDate)")
        
        
        print("localDate Dateobj: \(dateFormatter.string(from: localDate))")
    }
    
    
    func convertLocalTime(strDateTime: String)-> String{
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //     let date1 = dateFormatter.date(from: createdAt)
        let date1 = dateFormatter.date(from: strDateTime)
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "dd/MM/YYYY, hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        
        let timeStamp = dateFormatter.string(from: date1!)
        print("timeStamp - \(timeStamp)")
        
        return timeStamp
    }
    
    
    func pastTripDateTime(strDateTime:String)-> String{
        
        // create dateFormatter with UTC time format
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        //     let date1 = dateFormatter.date(from: createdAt)
        let date1 = dateFormatter.date(from: strDateTime)
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "MMM dd, YYYY hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        let timeStamp = dateFormatter.string(from: date1!)
        print("timeStamp is -  \(timeStamp)")
        
        let strDate = timeStamp
        
        let strTime = date1?.strrigWithFormat(format: "hh:mm a") ?? ""
        let strCurrentDate = date1?.strrigWithFormat(format: "MMM dd, YYYY") ?? ""
        
        // get current date
        
        let dateFormatter1 : DateFormatter = DateFormatter()
        dateFormatter1.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter1.dateFormat = "MMM dd, YYYY"
        let date = Date()
        let dateString = dateFormatter1.string(from: date)
        var returnDate = ""

        if strCurrentDate == dateString {
            returnDate = "\("Today".localize) , \(strTime)"
        }else{
            
            returnDate = strDate
        }
        
        return returnDate
    }
    
    func changeDateformatWithDate(strDate:String)-> String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date1 = dateformatter.date(from: strDate)
        //  let strDate = date1?.strrigWithFormat(format: "MMM dd, YYYY hh:mm a") ?? ""
        
        let strDate = date1?.strrigWithFormat(format: "dd/MM/YYYY, hh:mm a") ?? ""
        return strDate
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func removeFilter() {
        objAppShareData.strRatingcount = "0"
        objAppShareData.strRadius = "5"
        objAppShareData.strBusinessId = ""
        objAppShareData.strCategoryId = ""
        objAppShareData.isFromFilter = false
        objAppShareData.isFromPlacePicker = false
        objAppShareData.arrSelectedBusinessId = []
        objAppShareData.arrSelectedCategoryId = []
        objAppShareData.strSourceLat = "" // new
        objAppShareData.strSourceLong = "" // new
    }
    
    func resetBannarData(){
        objAppShareData.isFromBannerNotification = false
        objAppShareData.strBannerNotificationType = ""
        objAppShareData.strBannerReferenceType = ""
        objAppShareData.strBannerReferenceID = ""
        objAppShareData.strBannerCurrentStatus = ""
        objAppShareData.strBannerChatRoom = ""
        objAppShareData.notificationBannerDict = [:]
    }
}

//MARK:- Logout Api
extension AppShareData {
    func callWsLogoutApi(){
        
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            
            return
        }
        
        objWebServiceManager.StartIndicator()
        
        objWebServiceManager.requestDELETE(strURL: WsUrl.logout, Queryparams: nil , body: nil , strCustomValidation: "", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            // let message =  (response["message"] as? String)
            
            if status == "success" {
                objAppShareData.write_LogoutStatusToFirebase()
                objAppShareData.resetDefaultsAlluserInfo()
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kAuthToken)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kOnboardingStep)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kProfileComplete)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kRole)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kUserId)
                // UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.deviceToken)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.KStripeConnectAccountId)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kAccountNo)
                objAppDelegate.fromloginNavigation = true
                objAppDelegate.showLogInNavigation()
                
            } else {
                //    objAlert.showAlert(message:message ?? "", title: "Alert", controller: self)
                
                objAppShareData.resetDefaultsAlluserInfo()
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kAuthToken)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kOnboardingStep)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kProfileComplete)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kRole)
                UserDefaults.standard.removeObject(forKey: UserDefaults.KeysDefault.kAccountNo)
                
                objAppDelegate.fromloginNavigation = true
                objAppDelegate.showLogInNavigation()
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            // objAlert.showAlert(message:kErrorMessage, title: "Alert", controller: self)
            
        })
        
    }
    
    
}


//MARK:- save UserDetails On FireBase
extension AppShareData {
    
    func saveUserDetailsOnFireBase(){
        let isOnline:String = "Online"
        let strUserId =  objAppShareData.UserDetail.strUserID
        let strFullname =  objAppShareData.UserDetail.strFullName
        let strEmail =  objAppShareData.UserDetail.strEmail
        let strUserType =  objAppShareData.UserDetail.strRole
        let struserImage =  objAppShareData.UserDetail.strAvatar
        let strFirebasetoken =  objAppShareData.UserDetail.strDeviceToken
        // let timeStamp = Date.currentTimeStamp
        //    print(timeStamp)
        let dict = ["user_id":strUserId,
                    "full_name":strFullname,
                    "email": strEmail,
                    "user_type": strUserType,
                    "profile_picture":struserImage,
                    "online":isOnline,
                    "firebase_token":strFirebasetoken ] as [String : Any]
        
        print("data",dict)
        ref = Database.database().reference()
        ref?.child("users").child(strUserId).setValue(dict){
            (error:Error?, ref:DatabaseReference) in
            
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                print("Data saved successfully!")
            }
        }
    }
    
    func write_LogoutStatusToFirebase() {
        
        let ref = Database.database().reference()
        if  let strUserId = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId) as? String{
            ref.child("users").child(strUserId).updateChildValues(["firebase_token":""])
            ref.child("users").child(strUserId).updateChildValues(["online": ""])
            ref.removeAllObservers()
        }else{
            
        }
    }
    
    
    func write_OnlineStatusToFirebase() {
        //  let strUser = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId) as? String
        //  print("strUserid is \(strUser)")
        
        
        let ref = Database.database().reference()
        let strFirebasetoken = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.deviceToken) as? String ?? ""
        
        if  let strUserId = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId) as? String{
            ref.child("users").child(strUserId).updateChildValues(["firebase_token": strFirebasetoken])
            ref.child("users").child(strUserId).updateChildValues(["online": "Online"])
        }else{
            
        }
        
        
    }
    
    func write_OfflineStatusToFirebase() {
        
        let ref = Database.database().reference()
        if  let strUserId = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId) as? String{
            ref.child("users").child(strUserId).updateChildValues(["online": ""])
        }else{
            
        }
        
    }
    
    //    func removeBadgeCountFromFirebase() {
    //
    //        let ref = Database.database().reference()
    //        if  let strUserId = UserDefaults.standard.value(forKey: UserDefaults.Keys.userID) as? String{
    //        ref.child("badge_count").child(strUserId).updateChildValues(["count": 0])
    //        }else{
    //
    //        }
    //
    //    }
    
    
    func showChatCountFromFirebase(lbl : UILabel){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshChatCount"), object: nil, queue: nil) { [weak self](Notification) in
            
            if objAppShareData.strChatUnreadCount == 0 {
                lbl.isHidden = true
            }else{
                lbl.isHidden = false
                lbl.text = String(objAppShareData.strChatUnreadCount)
            }
        }
        if objAppShareData.strChatUnreadCount == 0 {
            lbl.isHidden = true
        }else{
            lbl.isHidden = false
            lbl.text = String(objAppShareData.strChatUnreadCount)
        }
    }
}

//MARK:- Image Picker

extension AppShareData{
    
    func compressImage(image:UIImage) -> Data? {
        // Reducing file size to a 10th
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = 1600.0
        let maxWidth : CGFloat = 1000.0
        let minHeight : CGFloat = 300.0
        let minWidth : CGFloat = 300.0
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
        
        guard let imageData = img.jpegData(compressionQuality:1.0) else{
            return nil
        }
        return imageData
    }
    
    
    func openImagePicker(controller: UIViewController, success: @escaping ([String: Any])->(), failure: @escaping (Error)-> ()) {
        self.successBlock = success
        self.failureBlock = failure
        self.controller = controller
        self.imagepick()
    }
    
    func imagepick() {
        let alert:UIAlertController=UIAlertController(title: "Choose_Image".localize, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.controller?.modalPresentationStyle = .overCurrentContext
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            // self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = false
            self.imagePicker.delegate = self
            // self.imagePicker.mediaTypes = [kUTTypeImage as String]
            self.imagePicker.modalPresentationStyle = .fullScreen
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}

//MARK:- Image Picker for Video

extension AppShareData{
    func openImagePickerForVideo(controller: UIViewController, success: @escaping ([String: Any])->(), failure: @escaping (Error)-> ()) {
        self.successBlock = success
        self.failureBlock = failure
        self.controller = controller
        self.imagePickForVideo()
    }
    
    func imagePickForVideo() {
        let alert:UIAlertController=UIAlertController(title: "Choose Video".localize, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCameraForVideo()
        }
        let galleryAction = UIAlertAction(title: "Gallery".localize, style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openVideoGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel".localize, style: UIAlertAction.Style.cancel)
        {
            UIAlertAction in
        }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.controller?.present(alert, animated: true, completion: nil)
    }
    
    func openCameraForVideo(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            // self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func openVideoGallery(){
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            // self.imagePicker.mediaTypes = [kUTTypeMovie as String]
            self.controller?.present(self.imagePicker, animated: true, completion: nil)
        }
    }
}


//MARK:- Image picker Controller Delegate

extension AppShareData:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.controller?.dismiss(animated: true, completion: nil)
        self.successBlock = nil
        self.failureBlock = nil
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        self.controller?.dismiss(animated: true, completion: nil)
        var dict  = [String: Any]()
        dict["image"] = info[.originalImage]
        dict["imageUrl"] = info[.mediaURL]
        print("media info",dict)
        self.successBlock?(dict)
        self.successBlock = nil
        self.failureBlock = nil
    }
    
    //MARK:- checkCameraPermissions
    func checkCameraPermissions(handler:(Bool)->Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized:
            print("Allowed")
            handler(true)
        case .denied:
            handler(false)
            alertPromptToAllowCameraAccessViaSetting()
        default:
            print("Allowed")
            handler(true)
        }
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(title: "Camera access required".localize, message: "Camera access is disabled please allow from Settings.".localize, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel".localize, style: .default))
        alert.addAction(UIAlertAction(title: "Settings".localize, style: .default) { (alert) -> Void in
            //UIApplication.shared.openURL(URL(string: UIApplication.UIApplicationOpenSettingsURLString)!)
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options:  [:], completionHandler: nil)
        })
        // alert.show()
    }
}
extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}
