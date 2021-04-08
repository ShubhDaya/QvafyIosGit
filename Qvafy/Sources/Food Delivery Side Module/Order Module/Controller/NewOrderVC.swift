//
//  NewOrderVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 19/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SDWebImage
import PhoneNumberKit
class NewOrderVC: UIViewController ,CLLocationManagerDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var vwNoOrder: UIView!
    @IBOutlet weak var vwOrder: UIView!
    
    @IBOutlet weak var imgNoOrderHeader: UIImageView!
    @IBOutlet weak var imgOrderHeader: UIImageView!
    //@IBOutlet weak var btnChat: UIButton!
    
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwTracking: UIView!
    
    @IBOutlet weak var vwChat: UIView!
    @IBOutlet weak var vwCallRestaurant: UIView!
    @IBOutlet weak var vwCallDriver: UIView!
    @IBOutlet weak var vwDistance: UIView!
    @IBOutlet weak var vwPayment: UIView!
    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    @IBOutlet weak var vwDotted3: UIView!
    @IBOutlet weak var vwDotted4: UIView!
    @IBOutlet weak var vwRound: UIView!
    
    @IBOutlet weak var vwRestaurantProfile: UIView!
    @IBOutlet weak var imgRestaurantProfile: UIImageView!
    @IBOutlet weak var vwDriverProfile: UIView!
    @IBOutlet weak var imgDriverProfile: UIImageView!
    
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantAddress: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblDriverAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var imgPaymentType: UIImageView!
    
    
    @IBOutlet weak var btnChangeStatus: UIButton!
    @IBOutlet weak var vwChangeStatus: UIView!
    @IBOutlet weak var vwImgChangeStatus: UIView!
    
    @IBOutlet weak var lblTotalItemPrice: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var lblOfferTitle: UILabel!
    
     @IBOutlet weak var lblChatCount: UILabel!
     @IBOutlet weak var lblChatCount1: UILabel!
    
    // Localization outlets -
    
    @IBOutlet weak var lblLONewOrderHeader: UILabel!
    @IBOutlet weak var lblLONoOrder: UILabel!
    @IBOutlet weak var lblLONoOrderDetaial: UILabel!
    
    @IBOutlet weak var lblLOOrderHeader: UILabel!
    @IBOutlet weak var lblLOItemInfo: UILabel!
    @IBOutlet weak var lblLOBillDetails: UILabel!
    @IBOutlet weak var lblLOTotalItemPrice: UILabel!
    @IBOutlet weak var lblLODeliveryFees: UILabel!
    @IBOutlet weak var lblLOTotalPay: UILabel!
    @IBOutlet weak var lblLOPaymentType: UILabel!
    @IBOutlet weak var lblLODistance: UILabel!
    @IBOutlet weak var lblChangeStatus: UILabel!
    
    //MARK: - Varibles
    var arrOrderTracking:[OrderTracking] = []
    var arrItemList:[ItemModel] = []
    var strRestaurantImage = ""
    var strCurrentStatus = ""
    //var objOrderTracking:OrderTracking?

       var strDialCode = ""
       var strPhoneNumber = ""
       var strRestaurantDialCode = ""
       var strRestaurantPhoneNumber = ""
    
    var strOrderId = ""
    var strCustomerId = ""
    var strReferenceID = ""
    
     var isFromForgroundNotification = false
    
    
    var strSourceLat = ""
    var strSourceLong = ""
    var strSourceAddress = ""
    var locationManager = CLLocationManager()
    let phoneNumberKit = PhoneNumberKit()

    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapSetup()
//        let isEnable = self.checkForLocation()
//        if !isEnable{
//            self.showAlertForLocation()
//        }else{
//            self.getLocation()
//        }
        
        if objAppShareData.isFromBannerNotification == true {
                
            if  objAppShareData.strBannerNotificationType == "chat"{
                       let sb = UIStoryboard(name: "Chat", bundle: nil)
                       let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
                      self.navigationController?.pushViewController(detailVC, animated: false)
            } else {
            
                let sb = UIStoryboard(name: "Order", bundle: nil)
                       let detailVC = sb.instantiateViewController(withIdentifier: "FoodTrackingVC") as! FoodTrackingVC
                       detailVC.strOrderId = objAppShareData.strBannerReferenceID
                       self.navigationController?.pushViewController(detailVC, animated: false)
        }
            
            }
        
        //        self.vwOrder.isHidden = false
        //        self.vwNoOrder.isHidden = true
        self.vwOrder.isHidden = true
        self.vwNoOrder.isHidden = false
        
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.localization()
        
          objAppShareData.isOnMapScreen = true
         self.tabBarController?.tabBar.isHidden = false
        self.setUI()
                    self.vwNoOrder.isHidden = false
                    self.vwOrder.isHidden = true

        self.callWsForGetNewOrder()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshUI"), object: nil, queue: nil) { [weak self](Notification) in
                         self?.isFromForgroundNotification = true
                         self?.callWsForGetNewOrder()
                     }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
                  super.viewWillDisappear(animated)
          
                  objAppShareData.isOnMapScreen = false
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false

              }
    
    @objc func updateUI(){
        self.isFromForgroundNotification = true
        self.callWsForGetNewOrder()

    }
    
    func setUI(){
        
        
        self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
             self.lblChatCount.clipsToBounds = true
              objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
        
        self.lblChatCount1.layer.cornerRadius = self.lblChatCount1.frame.height/2
        self.lblChatCount1.clipsToBounds = true
         objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount1)
        
     
        
        self.vwHeader.setviewbottomShadow()
        self.vwTracking.setShadowWithCornerRadius()
        self.vwChat.setShadowWithCornerRadius()
        self.vwCallDriver.setShadowWithCornerRadius()
        self.vwCallRestaurant.setShadowWithCornerRadius()
        
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwDotted3.creatDashedLine(view: vwDotted3)
        self.vwDotted4.creatDashedLine(view: vwDotted4)
        
        self.vwPayment.setCornerRadiusBoarder(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 5)
        self.vwDistance.setCornerRadiusBoarder(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 5)
        self.vwChangeStatus.setButtonView(vwOuter : self.vwChangeStatus , vwImage : self.vwImgChangeStatus, btn: self.btnChangeStatus )
       // self.vwDriverProfile.setProfileVerifyView(vwOuter: self.vwDriverProfile, img: self.imgDriverProfile)
        self.vwDriverProfile.setUserProfileView(vwOuter: self.vwDriverProfile, img: self.imgDriverProfile , radius : 4)
        
        //   self.vwRound.setCornerRadBoarder(color : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),cornerRadious : 20)
        
        self.vwRound.setShadowCornerRadius()
       // self.tblItems.contentSize =   CGSize(width: 0.0 , height: self.tblItems.contentSize.height + 200)
       // self.tblItems.layoutIfNeeded()
        self.tblItems.delegate = self
        self.tblItems.dataSource = self
    }
    
    
    //MARK: - get Users CurrentLocation
    
    /*   old code for update location
    func getLocation(){
        
        PlacePicker.shared.getUsersCurrentLocation(success: { (CLLocationCoordinate2D) in
            print(CLLocationCoordinate2D)
            let lat = CLLocationCoordinate2D.latitude
            let long = CLLocationCoordinate2D.longitude
            print(lat)
            print(long)
            let Cordinate = type(of: CLLocationCoordinate2D).init(latitude: lat, longitude: long)
            
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                
                self.strSourceAddress = addressModel.address ?? ""
                self.strSourceLat = addressModel.lat ?? ""
                self.strSourceLong = addressModel.lng ?? ""
                
                
              
                
                print("self.strSourceAddress is \(self.strSourceAddress)")
                print("self.strSourceLat is \(self.strSourceLat)")
                print("self.strSourceLong is \(self.strSourceLong)")
                
                self.callWsForUpdateLocation(lat : self.strSourceLat , long : self.strSourceLong , address : self.strSourceAddress )
                
                self.view.endEditing(true)
            }) { (error) in
                //  SVProgressHUD.dismiss()
            }
        }) { (Error) in
            // SVProgressHUD.dismiss()
            print(Error)
        }
        
    }
    
    func checkForLocation() -> Bool {
        var isEnable = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted:
                print("No access")
            // self.showAlertForLocation()
            case .denied:
                print("No access")
            // self.showAlertForLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
                isEnable = true
            default:
                break
            }
        } else {
            self.showAlertForLocation()
            print("Location services are not enabled")
        }
        return isEnable
    }
    
    func showAlertForLocation(){
        
        objAlert.showAlertCallOneBtnAction(btnHandler: "Settings", title: "Need Authorization", message: "This app is unusable if you don't authorize this app to use your location!", controller: self) {
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:]
                
                , completionHandler: nil)
            
        }
        
    }

    */
    func localization(){
    
        self.lblLONewOrderHeader.text = "New_Order".localize
        self.lblLONoOrder.text = "No_Order".localize
        self.lblLONoOrderDetaial.text = "Right_now_you_do_not_havevany_order_to_delivery._Please_wait_a_while".localize
        self.lblLOOrderHeader.text = "New_Order".localize
        self.lblLOItemInfo.text = "Items_Info".localize
        self.lblLOBillDetails.text = "Bill_Details".localize
        self.lblLOTotalItemPrice.text = "Total_Items_Price".localize
        self.lblLODeliveryFees.text = "Delivery_Fee".localize
        self.lblLOTotalPay.text = "Total_Pay".localize
        self.lblLOPaymentType.text = "Payment_Type".localize
        self.lblLODistance.text = "Distance".localize
        self.lblChangeStatus.text = "Change_Status".localize
        
    }
    
    
    //MARK: - Button Action
    
    @IBAction func btnChatAction(_ sender: UIButton) {
        self.view.endEditing(true)
             let sb = UIStoryboard(name: "Chat", bundle: nil)
                    let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
                    self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    
    @IBAction func btnChatDriverAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Chat", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            detailVC.strCustomerId = self.strCustomerId
            detailVC.strOpponentId = self.strCustomerId
            detailVC.strDriverId = objAppShareData.UserDetail.strUserID
            detailVC.strDriverType = "3"
            detailVC.strReferenceID = self.strReferenceID
            detailVC.strOrderRideId = self.strOrderId
            detailVC.isFromDriverSide = true
            detailVC.strReferenceType = "2"
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        
    }
    
    @IBAction func btnCallRestaurantAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        do {
            print("Current number is \(self.strRestaurantPhoneNumber)")
            print(self.strRestaurantDialCode)
            let phoneNumber = try phoneNumberKit.parse(strRestaurantDialCode + (self.strRestaurantPhoneNumber))
            
            //self.callWsForSignup()
            let number = self.strRestaurantDialCode + "-" + self.strRestaurantPhoneNumber
            print("number is \(number)")
            
            if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
            
        }catch {
            print("Error occured")
            
            objAlert.showAlert(message: InvalidAddedNUmber.localize, title: kAlert.localize, controller: self)
            
        }
//        let number = self.strRestaurantDialCode + "-" + self.strRestaurantPhoneNumber
//        print("number is \(number)")
//
//        if let url = URL(string: "tel://\(number)"),
//        UIApplication.shared.canOpenURL(url) {
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//
//        }
        
    }
    @IBAction func btnCallDriverAction(_ sender: UIButton) {
        self.view.endEditing(true)
//        let number = self.strDialCode + "-" + self.strPhoneNumber
//              print("number is \(number)")
//
//              if let url = URL(string: "tel://\(number)"),
//              UIApplication.shared.canOpenURL(url) {
//              UIApplication.shared.open(url, options: [:], completionHandler: nil)
//              }
        
        do {
            print("Current number is \(self.strPhoneNumber)")
            print(self.strDialCode)
            let phoneNumber = try phoneNumberKit.parse(strDialCode + (self.strPhoneNumber))
            
            //self.callWsForSignup()
            let number = self.strDialCode + "-" + self.strPhoneNumber
            print("number is \(number)")
            
            if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                
            }
            
        }catch {
            print("Error occured")
            
            objAlert.showAlert(message: InvalidPhone.localize, title: kAlert.localize, controller: self)
            
        }
        
        
        
        
    }
    
    @IBAction func btnChangeStatusAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let sb = UIStoryboard.init(name: "Order", bundle:Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier:"ChangeStatusVC") as! ChangeStatusVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.strCurrentStatus = self.strCurrentStatus
        vc.strOrderId = self.strOrderId
        vc.arrOrderTracking = self.arrOrderTracking
        self.tabBarController?.tabBar.isHidden = true
        
        
        vc.closerHideBottambar = {
            isClearListData in
            if isClearListData{
                //  self.tabBarController?.tabBar.isHidden = true
                self.tabBarController?.tabBar.isHidden = false
                self.callWsForGetNewOrder()
            }
        }
        self.present(vc, animated: false, completion: nil)
        
    }
    @IBAction func btnFoodTrackingAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Order", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "FoodTrackingVC") as! FoodTrackingVC
        detailVC.strOrderId = self.strOrderId
     //   detailVC.strRestaurantImage = self.strRestaurantImage
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource

extension NewOrderVC : UITableViewDelegate ,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }

    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {

      self.tblHeightConstraint?.constant = self.tblItems.contentSize.height
      self.view.layoutIfNeeded()
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // self.tblHeightConstraint.constant = CGFloat((self.arrItemList.count * 49))
       // self.tblHeightConstraint.constant = self.tblItems.co
       // self.tblHeightConstraint.constant = self.tblItems.contentSize.height

        return self.arrItemList.count

    }
    
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as!ItemCell
        
    //    cell.lblTitle.text = "strMenuPrice"
        
      //  cell.lblPrice.text = "23312"

        let obj = self.arrItemList[indexPath.row]
        
        let quantity = obj.strQuantity
        cell.lblTitle.text = obj.strMenuName.capitalizingFirstLetter() + " (x" + quantity + ")"
        cell.lblPrice.text = "$" + obj.strMenuPrice

        
        return cell
    }
   
}


extension NewOrderVC {
    
    func mapSetup(){
       
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
    }
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError){
        print("Error" + error.description)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
     //   let userLocation = locations.last
        
//        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 14);
//        self.mapView.camera = camera
//        self.mapView.isMyLocationEnabled = false
        ////
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        ///
        
        //        let marker = GMSMarker(position: center)
        if CLLocationManager.locationServicesEnabled()
        {
            switch(CLLocationManager.authorizationStatus())
            {
            case .authorizedAlways, .authorizedWhenInUse:
                print("Authorize.")
                let latitude: CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
                let longitude: CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
                let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                    if error != nil {
                        return
                    }else if let country = placemarks?.first?.country,
                        let city = placemarks?.first?.subLocality {
                        print(country)
                      //  print("placemarks is \(placemarks)")
                        print("lat is \(String(latitude))")
                        print("long is \(String(longitude))")
                        
                        
                        
                        
                        self.strSourceAddress = city
                        let Lat = String(latitude)
                        let Long = String(longitude)
                        
                        
                        self.callWsForUpdateLocation(lat : Lat , long : Long , address : city )
                        
                    }
                    else {
                    }
                })
                break
                
            case .notDetermined:
                print("Not determined.")
                objAlert.showAlert(message: "Location service is disabled!!".localize, title: kAlertTitle.localize, controller: self)
                break
                
            case .restricted:
                print("Restricted.")
                objAlert.showAlert(message:"Location service is disabled!!".localize, title: kAlertTitle.localize, controller: self)
                break
                
            case .denied:
                print("Denied.")
            @unknown default: break
            }
        }
        
    }
    
}

//MARK: - Api calling

extension NewOrderVC {
    
    // TODO: Webservice For get new Order
    func callWsForGetNewOrder(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
       // objWebServiceManager.StartIndicator()
        if  self.isFromForgroundNotification != true{
               objWebServiceManager.StartIndicator()
               }
        objWebServiceManager.requestGet(strURL: WsUrl.newOrder  ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
          //  let message =  (response["message"] as? String)
            
            if status == "success" {
                
               
                let dic  = response["data"] as? [String:Any]

                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        self.vwOrder.isHidden = false
                        self.vwNoOrder.isHidden = true
                        
                    }else{
                       self.vwNoOrder.isHidden = false
                        self.vwOrder.isHidden = true
                    }
                }
                
                
                
                
                self.arrItemList.removeAll()
                if let arrItemData = dic?["items_info"] as? [[String: Any]]{
                    for dictItemData in arrItemData
                    {
                        let objData = ItemModel.init(dict: dictItemData)
                        self.arrItemList.append(objData)
//                        self.arrItemList.append(objData)
//                        self.arrItemList.append(objData)
//                        self.arrItemList.append(objData)
//                        self.arrItemList.append(objData)
//                        self.arrItemList.append(objData)
                        
                    }
                    print("self.arrItemList.count is \(self.arrItemList.count)")
                    
                }
                
        //////////////////////
                               if let arrTrackingData = dic?["order_tracking"] as? [[String: Any]]{
                                self.arrOrderTracking.removeAll()

                                   for dictTrackingData in arrTrackingData
                                   {
                                       let objData = OrderTracking.init(dict: dictTrackingData)
                                       self.arrOrderTracking.append(objData)
                                   }
                                   print("self.arrOrderTracking.count is \(self.arrOrderTracking.count)")
                                   
                               }
                
                
          //////////////////////
                if let orderDetail = dic?["new_order"] as? [String:Any]{
                    
                    self.loadOrderDetail(dict : orderDetail)
                }
                
                self.tblItems.reloadData()
               // self.tblItems.contentSize =   CGSize(width: 0.0 , height: self.tblItems.contentSize.height + 200)
               // self.tblItems.layoutIfNeeded()
            }else{
                
                
                // objAlert.showAlert(message:message ?? "", title: "Alert", controller: self)
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
    
    func loadOrderDetail(dict : [String:Any]){
        
        
        if let distance = dict["distance"]as? String {
            self.lblDistance.text =  distance + " \("KM".localize)"
        }
        
        if let name = dict["restaurant_name"]as? String {
            self.lblRestaurantName.text = name.capitalizingFirstLetter()
        }
        
        if let address = dict["restaurant_address"]as? String {
            self.lblRestaurantAddress.text = address
        }
        
        
        if let name = dict["customer_name"]as? String {
            self.lblDriverName.text = name.capitalizingFirstLetter()
        }
        
        if let customerId = dict["customer_id"]as? String {
            self.strCustomerId = customerId
        }
        
        
        if let address = dict["cda_address"]as? String {
            self.lblDriverAddress.text = address
        }
                
        if let profilePic = dict["customer_image"]as? String{
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgDriverProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
            }else{
                self.imgDriverProfile.image = UIImage.init(named: "inactive_profile_ico")
            }
        }
        
        
        if let profile = dict["restaurant_image"]as? String{
          ///  self.strRestaurantImage = profile
            if profile != "" {
                let url = URL(string: profile)
                self.imgRestaurantProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
            }else{
                self.imgRestaurantProfile.image = UIImage.init(named: "inactive_profile_ico")
            }
        }
        
        if let paymentMode = dict["payment_mode"]as? String{
            
            if paymentMode == "1" {
                self.lblPaymentType.text = "Cash_On_Delivery".localize
                self.imgPaymentType.image = #imageLiteral(resourceName: "cash_on_delivery")
            }else if paymentMode == "2"{
                self.lblPaymentType.text = "Credit_Card".localize
                self.imgPaymentType.image = #imageLiteral(resourceName: "credit_card")
            }
        }
  
        
        if let totalAmount = dict["total_item_price"]as? String{
            
            self.lblTotalItemPrice.text = "$" + totalAmount
        }
        
        if let shippingPrice = dict["delivery_charge"]as? String{
            self.lblDeliveryFee.text = "$" + shippingPrice
        }else  if let shippingPrice = dict["delivery_charge"]as? Int {
            self.lblDeliveryFee.text = "$" + String(shippingPrice)
        }
        
        
        if let total = dict["total_amount"]as? String{
            self.lblPay.text = "$" + total
        }
        
        
                   if let discountAmount = dict["discount_amount"]as? String {
                         var title = ""
                    print(  "discountAmount is\(discountAmount)")

                    if let discountTitle = dict["discount_title"]as? String{
                        print(  "discountTitle is\(discountTitle)")

                        title = discountTitle
                    }
                       if title == ""{
                           self.lblOffer.isHidden = true
                           self.lblOfferTitle.isHidden = true
        
                       }else{
                           self.lblOffer.isHidden = false
                           self.lblOfferTitle.isHidden = false
        
                           self.lblOffer.text = "-$" + discountAmount
                           self.lblOfferTitle.text = title
        
                       }
                   }
        
        if let orderID = dict["orderID"]as? String{
            self.strOrderId = orderID
            
        }else  if let orderID = dict["orderID"]as? Int {
             self.strOrderId = String(orderID)
        }
        
        
        
        if let number = dict["number"]as? String {
            self.strReferenceID =  number
        }
        
        /////////////////////
        
        if let currentStatus = dict["current_status"]as? String{
            print(  "currentStatus is \(currentStatus)")
              self.strCurrentStatus = currentStatus
        
        }
        
        if let customerCountryCode = dict["customer_country_code"]as? String{
          print(  "customerCountryCode is \(customerCountryCode)")
            
        }
        if let customerDialCode = dict["customer_dial_code"]as? String{
          self.strDialCode =  customerDialCode
            
        }
        if let customerPhoneNumber = dict["customer_phone_number"]as? String{
             self.strPhoneNumber =  customerPhoneNumber
            
        }
        
        
        
        if let restaurantCountryCode = dict["restaurant_country_code"]as? String{
          print(  "restaurantCountryCode is \(restaurantCountryCode)")
            
            
        }
        if let restaurantDialCode = dict["restaurant_dial_code"]as? String{
              self.strRestaurantDialCode =  restaurantDialCode
        }
        if let restaurantPhoneNumber = dict["restaurant_phone_number"]as? String{
          print(  "restaurantPhoneNumber is \(restaurantPhoneNumber)")
            self.strRestaurantPhoneNumber =  restaurantPhoneNumber

            
        }
        
        
    }
    
    
    // TODO: Webservice For update location
    func callWsForUpdateLocation(lat : String , long : String , address : String ) {
        if !objWebServiceManager.isNetworkAvailable(){
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        var param: [String: Any] = [:]
        param = [
            WsParam.address: address ,
            WsParam.latitude: lat ,
            WsParam.longitude: long
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.updateLocation, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
            
        }, failure: { (error) in
            print(error)
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
}


