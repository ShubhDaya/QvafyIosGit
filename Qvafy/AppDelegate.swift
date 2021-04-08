

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import SlideMenuControllerSwift
import Stripe
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

let objAppDelegate = AppDelegate.AppDelegateObject()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , CLLocationManagerDelegate {
    
    //MARK: - Varibles
    var window: UIWindow?
    var kDeviceToken = ""
    var navController: UINavigationController?
    var fromloginNavigation  = false
    var locationManager = CLLocationManager()
    var ref: DatabaseReference!
    fileprivate var _refHandle: DatabaseHandle?
    //MARK: - Shared object
    private static var AppDelegateManager: AppDelegate = {
        let manager = UIApplication.shared.delegate as! AppDelegate
        return manager
    }()
    // MARK: - Accessors
    class func AppDelegateObject() -> AppDelegate {
        return AppDelegateManager
    }
    
    // MARK: - AppDelegate lifeCycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        // TODO: getUUID for device Id
        
        let getudid = getUUID()
        let defaults = UserDefaults.standard
        defaults.set(getudid ?? "", forKey:UserDefaults.KeysDefault.strVenderId)
        if let myString = defaults.string(forKey:UserDefaults.KeysDefault.strVenderId) {
            print("Device Id : \(myString)")
        }
        // TODO: setLanguage
        self.setLanguage()
        // TODO: For FireBaseGooglePlistSetUp and Notification
        self.FireBaseGooglePlistSetUp()
        // TODO: For GoogleMap place api key given by himanshu sir

        GMSServices.provideAPIKey("AIzaSyBNzeXhR3Hv6U1TgPB1-x27Ic_tiazlTGc")
        GMSPlacesClient.provideAPIKey("AIzaSyBNzeXhR3Hv6U1TgPB1-x27Ic_tiazlTGc")
        
        //UserDefaults.standard.set("TEST", forKey: "Key") //setObject
        // TODO: For stripe key
        //  Stripe.setDefaultPublishableKey("pk_test_51HICv5AinsnjiJjUSYISltmDLEtRRWVR4W2tGApU9a5pd2dZevwNTcDI5ikh2uWVbsM7l1EF9iIT8HlZK3eVBm6N00BkqBAHBu") // new for dev
        Stripe.setDefaultPublishableKey(pkTest)
        
        // TODO: For Fetch userInfo  and login Status Check
        self.ref = Database.database().reference()
        objAppShareData.fetchUserInfoFromAppshareData()
        self.loginStatusCheck()
        
        // TODO: Get Location Permission Work
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = false
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        //  FirebaseApp.configure()
        Messaging.messaging().delegate = self
        //self.configureNotification()
        self.registerForRemoteNotification()
        self.getUser()
        return true
    }
    
    
    
    func getUser(){
    var ref: DatabaseReference!
    ref = Database.database().reference()
    ref.child("users").observe(.value, with: { [weak self] (snapshot) -> Void in
    guard let strongSelf = self else { return }
    if snapshot.hasChildren(){
    objAppShareData.arrUsers.removeAll()
    for child in snapshot.children {
    let stId = ((child as! DataSnapshot).key)
    let obj = user.init()
    let dict = (child as! DataSnapshot).value as? [String : Any] ?? [:]

    obj.str_Name = dict["full_name"] as? String ?? ""
    obj.str_ProfileImage = dict["profile_picture"] as? String ?? ""
    obj.isOnline = dict["online"] as? String ?? ""
    obj.userType = dict["user_type"] as? String ?? ""
    obj.userId = dict["user_id"] as? String ?? ""
    objAppShareData.arrUsers.append(obj)
    }
    }
    })
    }

    
    // MARK: - FireBaseGooglePlistSetUp
    func registerForRemoteNotification() {
        // iOS 10 support
        if #available(iOS 10, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options:authOptions){ (granted, error) in
                UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
                Messaging.messaging().delegate = self
                let deafultCategory = UNNotificationCategory(identifier: "CustomSamplePush", actions: [], intentIdentifiers: [], options: [])
                let center = UNUserNotificationCenter.current()
                center.setNotificationCategories(Set([deafultCategory]))
            }
        }else {
            
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector:
            #selector(tokenRefreshNotification), name:
            .InstanceIDTokenRefresh, object: nil)
    }
    func FireBaseGooglePlistSetUp(){
        
        if BASE_URL.contains("dev"){
            objAppShareData.kServerKey = "AAAAhXgkG04:APA91bEMySFPBr5jeyxcFPkF7EPHdvHibS9jCq8uAbDpNpnrZOG9k0n_v-FJJqM1feTRoDWFeZPFpkHfvMDJaCuwSceFp96BmQZ3oAHAnxpBrLB6M8E8ytBVwuFywkFXkTd1ycXOkj79"
            let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info_dev", ofType: "plist")
            guard let options = FirebaseOptions(contentsOfFile: firebaseConfig!) else {
                fatalError("Invalid Firebase configuration file.")
            }
            FirebaseApp.configure(options: options)
        }else{
            objAppShareData.kServerKey = "AAAArNs6bpg:APA91bFgzW4Qt0xjsARtndF1D70e4SWiWeIm5ntTtyAX1QxFjy19JOQxWnTn7fMI1Voeuy_5x94gzqp7ioo7rAcfra2bZzgV3EtB3cNsIm_XjYv1NXv8epwtxFxMpUjvkPMc4yOgvb6L"
            let firebaseConfig = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
            guard let options = FirebaseOptions(contentsOfFile: firebaseConfig!) else {
                fatalError("Invalid Firebase configuration file.")
            }
            FirebaseApp.configure(options: options)
        }
        
    }
    
    // MARK: - get UUID id for device id
    
    func getUUID() -> String? {
        // create a keychain helper instance
        let keychain = KeychainAccess()
        // this is the key we'll use to store the uuid in the keychain
        let uuidKey = "DeviceUniqueId"
        // check if we already have a uuid stored, if so return it
        if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey), uuid != nil {
            return uuid
        }
        // generate a new id
        guard let newId = UIDevice.current.identifierForVendor?.uuidString else {
            return nil
        }
        // store new identifier in keychain
        try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
        
        return newId
    }
    
    // MARK: - setLanguage
    func setLanguage(){
        
        let selectedlanguage =  UserDefaults.standard.string(forKey: "Selectdlanguage")
         print(selectedlanguage ?? "")
         // TODO: Selected Language
         if selectedlanguage  == "es"{
         LocalizationSystem.sharedInstance.setLanguage(languageCode: "es")
         }else if selectedlanguage == "en"{
         LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
         }else{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UserDefaults.standard.set("en", forKey: "Selectdlanguage") //setObject

         }
    }
    
    
    //MARK:- Check Navigations
    
    func loginStatusCheck() {
        if objAppShareData.UserDetail.strAuthtoken == "" && objAppShareData.UserDetail.strProfileComplete == "0"{
            self.showLogInNavigation()
            print("showLogInNavigation")
        } else if  objAppShareData.UserDetail.strAuthtoken != "" && objAppShareData.UserDetail.strProfileComplete == "1"{
            print("loginStatusCheck func")
            self.observeProductMessages()
            self.observeAppIconCount()
            self.showTabBarNavigation()
        }
    }
    
    func showLogInNavigation() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "LoginNav")
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func showTabBarNavigation() {
        
        if objAppShareData.UserDetail.strRole == "1"{
                     self.showCustomerTabbar()
                   //  print("showCustomerTabbar")
                 }else if objAppShareData.UserDetail.strRole == "2"{
                     self.showTexiDriverTabbar()
                    // print("showTexiDriverTabbar")
                 }else{
                     self.showFoodDeliveryTabbar()
                    // print("showFoodDeliveryTabbar")
                 }
    }
    
    func showCustomerTabbar(){
        objAppShareData.write_OnlineStatusToFirebase() // new case when login , signup and from any notification
        selected_TabIndex = 0
        let HomeVC = UIStoryboard(name: "CustomerTabbar", bundle: nil).instantiateViewController(withIdentifier: "CustomerNav")  as? UINavigationController
        
        let SideMenuVC = UIStoryboard(name: "Map", bundle: nil).instantiateViewController(withIdentifier: "SideBarMenuVC") as! SideBarMenuVC
        let menuController = SlideMenuController (mainViewController: HomeVC!, leftMenuViewController: SideMenuVC)
        SlideMenuOptions.contentViewScale = 1
        let nav_home = UINavigationController(rootViewController: menuController)
        nav_home.setNavigationBarHidden(true, animated: true)
        self.window?.rootViewController = nav_home
        self.window?.makeKeyAndVisible()
    }
    
    func showTexiDriverTabbar() {
        objAppShareData.write_OnlineStatusToFirebase() // new case when login , signup and from any notification
        selected_TabIndex = 0
        let sb = UIStoryboard(name: "TaxiDriverTabbar", bundle: Bundle.main)
        let nav = sb.instantiateViewController(withIdentifier: "TaxiDriverNav") as? UINavigationController
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    func showFoodDeliveryTabbar() {
        objAppShareData.write_OnlineStatusToFirebase() // new case when login , signup and from any notification

        selected_TabIndex = 0
        let sb = UIStoryboard(name: "FoodDeliveryTabbar", bundle: Bundle.main)
        let nav = sb.instantiateViewController(withIdentifier: "FoodDeliveryNav") as? UINavigationController
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
    }
    
    //MARK:- Get User Current Location Work
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        let latitude = String(locValue.latitude)
        let longitude = String(locValue.longitude)
        getAddressFromLatLon(pdblLatitude: latitude, withLongitude: longitude)
        locationManager.stopUpdatingLocation()
        
    }
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        
        let lon: Double = Double("\(pdblLongitude)")!
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    //   print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if let pm = placemarks{
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        var strfulladdress : String = ""
                        var strCity : String = ""
                        var strCountry : String = ""
                        var strPostalCode : String = ""
                        var strCountryCode : String = ""
                        
                        if pm.subLocality != nil {
                            // addressString = addressString + pm.subLocality! + ", "
                            strfulladdress = pm.subLocality! + ", "
                        }
                        if pm.thoroughfare != nil {
                            // addressString = addressString + pm.thoroughfare! + ", "
                            strfulladdress = strfulladdress + pm.thoroughfare! + ", "
                        }
                        if pm.locality != nil {
                            //addressString = addressString + pm.locality! + ", "
                            strCity = pm.locality!
                            strfulladdress = strfulladdress + pm.locality!
                        }
                        if pm.country != nil {
                            // addressString = addressString + pm.country! + ", "
                            strCountry = pm.country!
                        }
                        if pm.postalCode != nil {
                            // addressString = addressString + pm.postalCode! + " "
                            strPostalCode = pm.postalCode!
                        }
                        if pm.isoCountryCode != nil{
                            strCountryCode = pm.isoCountryCode!
                        }
                        let param = ["latitude":pdblLatitude,"longitude":pdblLongitude,"country":strCountry,"city":strCity,"fullAddress":strfulladdress,"postalCode":strPostalCode,"countryCode":strCountryCode]as [String:Any]
                        AppShareData.sharedObject().dictUserLoction = param
                        // print(objAppShareData.dictUserLoction)
                    }
                }
        })
    }
}


extension AppDelegate : MessagingDelegate,UNUserNotificationCenterDelegate{
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
    func configureNotification() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
       func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("FCM registration token: \(fcmToken)")
        kDeviceToken = fcmToken
        UserDefaults.standard.set(kDeviceToken, forKey: UserDefaults.KeysDefault.deviceToken)
    }
    
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        kDeviceToken = fcmToken
        UserDefaults.standard.set(kDeviceToken, forKey:UserDefaults.KeysDefault.deviceToken)
    }
    
    //MARK: Notification
    @objc func tokenRefreshNotification(_ notification: Notification) {
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                
                self.kDeviceToken = result.token
                UserDefaults.standard.set(self.kDeviceToken, forKey: UserDefaults.KeysDefault.deviceToken)
            }
        }
     }
    
    //TODO: show notification banner and forground notification handling and redirections
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let userInfo = notification.request.content.userInfo as? [String : Any]{
            print(userInfo)
                                var strReferenceType = ""
                                 var strReferenceId = ""
                                 if let type = userInfo["reference_type"] as? Int{
                                     strReferenceType = String(type)
                                     objAppShareData.strBannerReferenceType = String(type)
                                 }else if let type = userInfo["reference_type"] as? String{
                                     strReferenceType = type
                                     objAppShareData.strBannerReferenceType = type
                                 }
                                 if let referenceId = userInfo["reference_id"]as? String{
                                     objAppShareData.strBannerReferenceID = referenceId
                                     strReferenceId = referenceId
                                     
                                 } else  if let referenceId = userInfo["reference_id"] as? Int{
                                     objAppShareData.strBannerReferenceID = String(referenceId)
                                      strReferenceId = String(referenceId)
                                 }
                              if let currentStatus = userInfo["current_status"]as? String{
                                  objAppShareData.strBannerCurrentStatus = currentStatus
                               } else  if let currentStatus = userInfo["current_status"] as? Int{
                                 objAppShareData.strBannerCurrentStatus = String(currentStatus)
                
                                 }

            let notificationType = userInfo["type"] as? String ?? ""
            NotificationCenter.default.post(name: Notification.Name(notificationType), object: nil)
            
              print("notificationType is \(notificationType)")
            if notificationType == "chat"{
                // let opponentUID = userInfo["recevierId"] as? String ?? ""
                let opponentUID = userInfo["senderId"] as? String ?? ""
                
                print("opponentUID is \(opponentUID)")
                print("login user id  is \(objAppShareData.UserDetail.strUserID)")
                print("objAppShareData.opponentUserId is \(objAppShareData.opponentUserId)")
                print("objAppShareData.isOnChatScreen is \(objAppShareData.isOnChatScreen)")
                
                if objAppShareData.opponentUserId == opponentUID && objAppShareData.isOnChatScreen == true{
                    completionHandler([])
                    
                }else if objAppShareData.opponentUserId != opponentUID && objAppShareData.isOnChatScreen == true{
                    completionHandler([.alert,.sound,.badge])
                    
                }
                else  {//if UIApplication.shared.applicationState == .active
                    if objAppShareData.isOnChatScreen != true{
                        
                        completionHandler([.alert,.sound,.badge])
                    }
                }
    }else if notificationType == "new_trip" || notificationType == "past_trip" || notificationType == "doc_verify" || notificationType == "new_order" || notificationType == "upcoming_order" || notificationType == "cancel_trip"{
        
        print("objAppShareData.isUpcomingList is \(objAppShareData.isUpcomingList)")
        
         if objAppShareData.isUpcomingList == true {
            
                  completionHandler([.alert,.sound,.badge])
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshUpcomingUI"), object: nil)
                  self.callWsForReadBannerNotification(type: strReferenceType, referenceId: strReferenceId)
        }  else  if objAppShareData.isOnMapScreen == true || objAppShareData.isOnDriverProfileScreen == true || objAppShareData.isUpcomingDetailScreen == true {
               
              //  completionHandler([])
//                    completionHandler([.alert,.sound,.badge])
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshUI"), object: nil)
                    self.callWsForReadBannerNotification(type: strReferenceType, referenceId: strReferenceId)
                    completionHandler([.alert,.sound,.badge])
                }else if objAppShareData.isOnMapScreen != true || objAppShareData.isOnDriverProfileScreen != true {
                    completionHandler([.alert,.sound,.badge])
                }
                // deepak new testing
                

                
                else{
                            completionHandler([.alert,.sound,.badge])
                } // deepak new testing
        
    }else if notificationType == "past_order"{
        
        if objAppShareData.isUpcomingDetailScreen == true{
                  completionHandler([.alert,.sound,.badge])
                  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "clearUI"), object: nil)
                  self.callWsForReadBannerNotification(type: strReferenceType, referenceId: strReferenceId)
        }
        // deepak new testing
        else if objAppShareData.isUpcomingList == true{
            completionHandler([.alert,.sound,.badge])

            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUpcomingUI"), object: nil)
            self.callWsForReadBannerNotification(type: strReferenceType, referenceId: strReferenceId)
            
        }else{
            completionHandler([.alert,.sound,.badge])
        }
        
        
        // deepak new testing
        
    }else{
                completionHandler([.alert,.sound,.badge])
            }
        }
    }
     //TODO: called When you tap on the notification in background
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        print(response)
        
        
        switch response.actionIdentifier {
            
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDefaultActionIdentifier:
            print("Open Action")
            if let userInfo = response.notification.request.content.userInfo as? [String : Any]{
                print(userInfo)
                self.handleNotificationWithNotificationData(dict: userInfo)
            }
        case "Snooze":
            print("Snooze")
        case "Delete":
            print("Delete")
        default:
            print("default")
        }
        completionHandler()
    }
    
    func handleNotificationWithNotificationData(dict:[String:Any]){
        
        if objAppShareData.UserDetail.strAuthtoken == "" && objAppShareData.UserDetail.strProfileComplete == "0"{
            self.showLogInNavigation()
            print("showLogInNavigation")
        } else if  objAppShareData.UserDetail.strAuthtoken != "" && objAppShareData.UserDetail.strProfileComplete == "1"{
                                    
                       var strReferenceType = ""
                       var strReferenceId = ""
                       if let type = dict["reference_type"] as? Int{
                           strReferenceType = String(type)
                           objAppShareData.strBannerReferenceType = String(type)
                       }else if let type = dict["reference_type"] as? String{
                           strReferenceType = type
                           objAppShareData.strBannerReferenceType = type
                       }
                       
                       if let referenceId = dict["reference_id"]as? String{
                           objAppShareData.strBannerReferenceID = referenceId
                           strReferenceId = referenceId
                           
                       } else  if let referenceId = dict["reference_id"] as? Int{
                           objAppShareData.strBannerReferenceID = String(referenceId)
                            strReferenceId = String(referenceId)
                       }
            
            if let type = dict["type"]as? String{
             objAppShareData.strBannerNotificationType = type
                  print("type is on appdelegate in background \(type)")
            }
            
            if  objAppShareData.strBannerNotificationType == "chat"{
               var strRecevierId = ""
                if let recevierId = dict["recevierId"]as? String{
                 strRecevierId = recevierId
                }
               
                if strRecevierId == objAppShareData.UserDetail.strUserID {
                      print("same user id")
                    objAppShareData.isFromBannerNotification = true
                    objAppShareData.notificationBannerDict = dict
                     self.showTabBarNavigation()
                } else {
                      print("same user id is not")
                }
                
            } else {
                        
            objAppShareData.isFromBannerNotification = true
            objAppShareData.notificationBannerDict = dict
            
            if strReferenceType == "1" || strReferenceType == "2" {
                self.callWsForCheckCurrentStatus(type: strReferenceType , referenceId: strReferenceId)
            }else{
                self.showTabBarNavigation()
                 }
             }
        }
    }
    
    // TODO: Webservice For Check Current Status
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
            
            if status == "success"{
                let dic  = response["data"] as? [String:Any]
                
                if let currentStatus  = dic?["current_status"] as? String {
                    print("self.currentStatus in string is \(currentStatus)")
                    objAppShareData.strBannerCurrentStatus = currentStatus
                }
                 self.showTabBarNavigation()
                self.callWsForReadBannerNotification(type: type, referenceId: referenceId)
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
    
    // TODO: Webservice For Read Banner Notification
    func callWsForReadBannerNotification (type : String , referenceId: String) {
        if !objWebServiceManager.isNetworkAvailable(){
            //  objAlert.showAlert(message: NoNetwork , title: kAlert , controller: self)
            return
        }
        
        var param: [String: Any] = [:]
        param = [
            WsParam.referenceId: referenceId ,
            WsParam.referenceType: type ,
            WsParam.recipientUserId: objAppShareData.UserDetail.strUserID
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.readBannerNotification, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            let status =   (response["status"] as? String)
            
            if status == "success"{
//                let dic  = response["data"] as? [String:Any]
//
//                if let currentStatus  = dic?["current_status"] as? String {
//                    print("self.currentStatus in string is \(currentStatus)")
//                    objAppShareData.strBannerCurrentStatus = currentStatus
//                }
//
//                self.showTabBarNavigation()
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
    
    
    
    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
//}
extension AppDelegate {
    
    func applicationDidEnterBackground(_ application: UIApplication) {
       // objAppShareData.removeBadgeCountFromFirebase()
       UIApplication.shared.applicationIconBadgeNumber = 0
        objAppShareData.write_OfflineStatusToFirebase()
        if objAppShareData.UserDetail.strAuthtoken == "" && objAppShareData.UserDetail.strProfileComplete == "0"{
        } else if  objAppShareData.UserDetail.strAuthtoken != "" && objAppShareData.UserDetail.strProfileComplete == "1"{
            print("applicationDidEnterBackground func")
            self.observeProductMessages()
            self.observeAppIconCount()

        }
        UIApplication.shared.applicationIconBadgeNumber = objAppShareData.strAppIconCount
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       // objAppShareData.removeBadgeCountFromFirebase()
        UIApplication.shared.applicationIconBadgeNumber = 0
        objAppShareData.write_OnlineStatusToFirebase()
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
       // objAppShareData.removeBadgeCountFromFirebase()
       // UIApplication.shared.applicationIconBadgeNumber = 0
        
        objAppShareData.write_OnlineStatusToFirebase()
//        let topController = self.topViewController()
//        print("topController?.restorationIdentifier is \(topController?.restorationIdentifier)")
     
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        
    }
}


extension AppDelegate {

//MARK:- get Chat History from FireBase objAppShareData.UserDetail.strUserID
func observeProductMessages() {
if let strUser = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId) as? String{
print("strUserid is observeProductMessages in \(strUser)")
objAppShareData.fetchUserInfoFromAppshareData()
print("objAppShareData.UserDetail.strUserID \(objAppShareData.UserDetail.strUserID)")
let messageQuery = self.ref.child("chat_history").child(strUser).queryOrdered(byChild: "unread_count").queryStarting(atValue: 1)
//.queryEnding(atValue: nil, childKey: nil)
_refHandle = messageQuery.observe(.value, with: { (snapshot) -> Void in

if snapshot.hasChildren(){
objAppShareData.strChatUnreadCount = 0
for child in snapshot.children {
self.parseChatData(dict: (child as! DataSnapshot).value as? [String : Any] ?? [:])
}

NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshChatCount"), object: nil, userInfo: nil)
self.ref.child("badge_count").child(objAppShareData.UserDetail.strUserID).child("chat_count").setValue(["count": objAppShareData.strChatUnreadCount])
}else{
objAppShareData.strChatUnreadCount = 0
NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshChatCount"), object: nil, userInfo: nil)
self.ref.child("badge_count").child(objAppShareData.UserDetail.strUserID).child("chat_count").setValue(["count": objAppShareData.strChatUnreadCount])
}
})
}
}

func parseChatData(dict:[String:Any]){
print(dict)
let unreadCount = dict["unread_count"] as? Int ?? 0
objAppShareData.strChatUnreadCount = objAppShareData.strChatUnreadCount + unreadCount
print("objAppShareData.strChatUnreadCount = \(objAppShareData.strChatUnreadCount)")
}

//MARK:- get badge_count from FireBase for app icon
func observeAppIconCount() {
if let strUser = UserDefaults.standard.value(forKey: UserDefaults.KeysDefault.kUserId) as? String{
print("strUserid is observeAppIconCount in \(strUser)")
objAppShareData.fetchUserInfoFromAppshareData()
print("objAppShareData.UserDetail.strUserID \(objAppShareData.UserDetail.strUserID)")
// let messageQuery = self.ref.child("badge_count").child(strUser).queryOrdered(byChild: "unread_count").queryStarting(atValue: 1)

let messageQuery = self.ref.child("badge_count").child(strUser)
_refHandle = messageQuery.observe(.value, with: { (snapshot) -> Void in
print("snapshot is \(snapshot)")
objAppShareData.strAppIconCount = 0
var chatCount = 0
var notificationCount = 0

if let dictSnap = snapshot.value as? NSDictionary, let chat_count = dictSnap["chat_count"] as? NSDictionary, let count = chat_count["count"] as? Int {
print("chat_count is ========= \(count)")
chatCount = count
}

if let dictSnap = snapshot.value as? NSDictionary, let chat_count = dictSnap["notification_count"] as? NSDictionary, let count = chat_count["count"] as? Int {
print("notification_count is ========= \(count)")
notificationCount = count
}

objAppShareData.strAppIconCount = chatCount + notificationCount
print("objAppShareData.strAppIconCount is \(objAppShareData.strAppIconCount)")
})
}
}

//func parseAppIconCount(dict:[String:Any]){
//print("parseAppIconCount is dict \(dict)")
//let unreadCount = dict["unread_count"] as? Int ?? 0
//objAppShareData.strAppIconCount = objAppShareData.strAppIconCount + unreadCount
//print("objAppShareData.strAppIconCount = \(objAppShareData.strAppIconCount)")
//}

}
