//
//  UpcomingDetailVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 27/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//
import UIKit
import SDWebImage
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON
import GooglePlaces
import PhoneNumberKit
//import HCSStarRatingView

class UpcomingDetailVC: UIViewController , UIGestureRecognizerDelegate , GMSMapViewDelegate , CLLocationManagerDelegate{
   // GMSMapViewDelegate
    //MARK: - Outlets
    @IBOutlet weak var mapView: GMSMapView!

    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    @IBOutlet weak var vwDotted3: UIView!
    @IBOutlet weak var vwDotted4: UIView!
    @IBOutlet weak var vwDotted5: UIView!
    
    @IBOutlet weak var vwRound: UIView!
        
    @IBOutlet weak var vwCall: UIView!
    @IBOutlet weak var vwChat: UIView!

    @IBOutlet weak var vwCustomerProfile: UIView!
    @IBOutlet weak var imgCustomerProfile: UIImageView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblStatus: UILabel!

    @IBOutlet weak var lblDistance: UILabel!
    
    
    @IBOutlet weak var lblTotalItemPrice: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var lblOfferTitle: UILabel!
    @IBOutlet weak var lblRestaurantTitle: UILabel!
    @IBOutlet weak var lblRestaurantCharges: UILabel!
    @IBOutlet weak var lblReferenceId: UILabel!

    @IBOutlet weak var vwScroll: UIScrollView!

    
    @IBOutlet weak var vwImgRating: UIView!
    @IBOutlet weak var btnRating: UIButton!

    @IBOutlet weak var vwRating: UIView!

    @IBOutlet weak var vwDriverInfo: UIView!

    @IBOutlet weak var vwNoData: UIView!

    @IBOutlet weak var vwCancleOrder: UIView!
    @IBOutlet weak var btnCancleOrder: UIButton!
    
    // rohit sir
   //  @IBOutlet weak var viewCreateApointmentNew: UIView!
     @IBOutlet weak var vwCurrentLocation: UIView!
     @IBOutlet weak var ViewCreateBottom: NSLayoutConstraint!
    @IBOutlet weak var viewFullpage: UIView!
    @IBOutlet weak var viewFullPage: UIView!
    // rohit sir
    
    // localisation outlets -
    
    @IBOutlet weak var lblLOKilometer: UILabel!
    @IBOutlet weak var lblLOStatus: UILabel!
    @IBOutlet weak var lblLOItems: UILabel!
    @IBOutlet weak var lblLOBillDetails: UILabel!
    @IBOutlet weak var lblLOTotalItemPrice: UILabel!
    @IBOutlet weak var lblLORestorentCharges: UILabel!
    @IBOutlet weak var lblLODeleiveryFee: UILabel!
    @IBOutlet weak var lblLOtotalPay: UILabel!
    
    //MARK: - Varibles
    var arrItemList:[ItemModel] = []
    var strOrderId = ""
    var strRestaurantImage = ""
    var strCurrentStatus = ""
    var strReferenceID = ""
    var strDriverId = ""
    
    var locationManager = CLLocationManager()
    var strPathSourceLat = ""
    var strPathSourceLong = ""
    var strPathDestinationLat = ""
    var strPathDestinationLong = ""

    var strOriginLatitude = ""
    var strOriginLongitude = ""
    var timer = Timer()
    
    var strDialCode = ""
    var strPhoneNumber = ""
    
    var strDriverLatitude = ""
    var strDriverLongitude = ""
    let marker = GMSMarker.init()
    
    //var objOrderTracking:OrderTracking?
    
     var swipeGesture = UISwipeGestureRecognizer()
    var bottomConstant : CGFloat = 0

    var isFromConfirmation = false
    var isFromForgroundNotification = false
    let phoneNumberKit = PhoneNumberKit()

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblItems.delegate = self
        self.tblItems.dataSource = self
        self.setScroll()
       //  self.mapSetup()
    }

    func setScroll(){
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                swipeGesture.direction = UISwipeGestureRecognizer.Direction.up
                self.vwRound.addGestureRecognizer(swipeGesture)
                
                swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
                swipeGesture.direction = UISwipeGestureRecognizer.Direction.down
                self.vwRound.addGestureRecognizer(swipeGesture)
                self.vwRound.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.Localisation()

        self.vwScroll.isScrollEnabled = false
        objAppShareData.isUpcomingDetailScreen = true
        self.tabBarController?.tabBar.isHidden = true
        
        self.setUI()
        self.vwRound.isHidden = true
        self.vwNoData.isHidden = true
        self.vwCurrentLocation.isHidden = true
        self.callWsForOrderDetail()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshUI"), object: nil, queue: nil) { [weak self](Notification) in
                         self?.isFromForgroundNotification = true
                         self?.callWsForOrderDetail()
                     }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "clearUI"), object: nil, queue: nil) { [weak self](Notification) in
         
           // self?.navigationController?.popViewController(animated: true)
            
            objAppShareData.isUpcomingDetailScreen = false
            if self?.isFromConfirmation == true{
                objAppDelegate.showCustomerTabbar()
                 selected_TabIndex = 2
                self?.isFromConfirmation = false
            }else{
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }

    @objc func refrershUI(){
        self.isFromForgroundNotification = true
        self.callWsForOrderDetail()
    }
    
     override func viewDidAppear(_ animated: Bool) {
          super.viewDidAppear(animated)
      //  self.setBootomView()
      ///  self.runTimer()
      }
    
    override func viewDidDisappear(_ animated: Bool) {
          print("viewDidDisappear is called")
          super.viewDidDisappear(animated)
          /// self.timer.invalidate()
          self.timer.invalidate()
      }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false

            objAppShareData.isUpcomingDetailScreen = false
        }
    
    
    func Localisation(){
        
        self.lblLOKilometer.text = "Kilometer".localize
        self.lblLOStatus.text = "Status".localize
        self.lblLOItems.text = "Items".localize
        self.lblLOBillDetails.text = "Bill_Details".localize
        self.lblLOTotalItemPrice.text = "Total_Items_Price".localize
        self.lblLORestorentCharges.text = "Restaurant_Charges".localize
        self.lblLODeleiveryFee.text = "Delivery_Fee".localize
        self.lblLOtotalPay.text = "Total_Pay".localize

        self.btnCancleOrder.setTitle("Cancel_Order".localize, for: .normal)
        
    }
    
    
    func setUI(){
        
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwDotted3.creatDashedLine(view: vwDotted3)
        self.vwDotted4.creatDashedLine(view: vwDotted4)
        self.vwRound.roundCorners(corners: [.topLeft, .topRight], radius: 20)
         self.vwNoData.roundCorners(corners: [.topLeft, .topRight], radius: 20)
        self.vwCustomerProfile.setProfileVerifyView(vwOuter: self.vwCustomerProfile, img: self.imgCustomerProfile)
       // self.vwRating.setButtonView(vwOuter : self.vwRating , vwImage : self.vwImgRating, btn: self.btnRating )
        
        self.vwCancleOrder.setButtonVerifyView(vwOuter: self.vwCancleOrder, btn: self.btnCancleOrder,viewRadius:Int(25), btnRadius:Int(22.5))
        
      //  self.tblItems.reloadData()
        
    }
    
    func setBootomView(){
     
     DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0)) {

         self.bottomConstant = self.vwRound.frame.size.height - 250

         self.vwRound.isHidden = false
        self.vwCurrentLocation.isHidden = false
         self.ViewCreateBottom.constant = -self.bottomConstant
         UIView.animate(withDuration: 0.5) {
             self.vwRound.layoutIfNeeded()
         }
     }
     
     
     }
        
    
    //MARK: - Button Action
   @IBAction func btnNoData(_ sender: UIButton) {
        self.view.endEditing(true)
    self.vwRound.isHidden = false
     self.vwNoData.isHidden = true
    }
//    @IBAction func btnBack(_ sender: UIButton) {
//        self.view.endEditing(true)
//
//        objAppShareData.isUpcomingDetailScreen = false
//        if self.isFromConfirmation == true{
//            objAppDelegate.showCustomerTabbar()
//             selected_TabIndex = 2
//            self.isFromConfirmation = false
//        }else{
//            self.navigationController?.popViewController(animated: true)
//        }
//
//    }
    
    @IBAction func btnBack(_ sender: UIButton) {
    self.view.endEditing(true)
    // deepak new Testing
    self.backFromVc()
    // deepak new Testing
    }
    // deepak new Testing

    func backFromVc(){
    objAppShareData.isUpcomingDetailScreen = false
    if self.isFromConfirmation == true{
    objAppDelegate.showCustomerTabbar()
    selected_TabIndex = 2
    self.isFromConfirmation = false
    }else{
    self.navigationController?.popViewController(animated: true)
    }
    }// deepak new Testing
    
    
    

    @IBAction func btnCallAction(_ sender: UIButton) {
           self.view.endEditing(true)
//        let number = self.strDialCode + "-" + self.strPhoneNumber
//                           print("number is \(number)")
//
//                           if let url = URL(string: "tel://\(number)"),
//                           UIApplication.shared.canOpenURL(url) {
//                           UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                           }
//
        
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
            
            objAlert.showAlert(message: InvalidAddedNUmber.localize, title: kAlert.localize, controller: self)
            
        }
        
        
        
       }
    @IBAction func btnChatAction(_ sender: UIButton) {
           self.view.endEditing(true)
        let sb = UIStoryboard(name: "Chat", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            detailVC.strCustomerId = objAppShareData.UserDetail.strUserID
            detailVC.strDriverId = self.strDriverId
            detailVC.strOpponentId = self.strDriverId
            detailVC.strDriverType = "3"
            detailVC.strReferenceID = self.strReferenceID
            detailVC.strOrderRideId = self.strOrderId
            detailVC.isFromDriverSide = false
            detailVC.strReferenceType = "2"
        self.navigationController?.pushViewController(detailVC, animated: true)
       }
    
    @IBAction func btnCurrentLocationAction(_ sender: UIButton) {
           self.view.endEditing(true)
        self.getCurrentLocation()

       }
    
    func getCurrentLocation() {
          PlacePicker.shared.getUsersCurrentLocation(success: { (location) in
              self.location(location: location)
          }) { (Error) in
              
          }
      }

    func location(location : CLLocationCoordinate2D){
           let camera = GMSCameraPosition.camera(withLatitude:location.latitude, longitude: location.longitude, zoom: 14.0)
           self.mapView.camera = camera
           self.mapView.delegate = self
        
        //// new
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        let marker = GMSMarker()
        marker.position = location
        print(location.latitude)
        print(location.longitude)
        self.strOriginLongitude = String(location.longitude)
        self.strOriginLatitude = String(location.latitude)
        
       }
    
    @IBAction func btnCancleAction(_ sender: UIButton) {
        self.view.endEditing(true)

        self.vwRound.isHidden = true
           self.vwNoData.isHidden = false
    }
    
    @IBAction func btnCancleOrder(_ sender: UIButton) {
        self.view.endEditing(true)
        self.deleteData()
    }
    
    func deleteData(){
        let alert = UIAlertController(title: kAlert.localize, message: "Are_you_sure_you_want_to_cancel_your_order?".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
          
            self.callWsForCancelOrder(strOrderId: self.strOrderId)
        }))
        self.present(alert, animated: true, completion: nil)
    }
   
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource

extension UpcomingDetailVC : UITableViewDelegate ,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
 DispatchQueue.main.async {
    self.tblHeightConstraint.constant = self.tblItems.contentSize.height
        }
        return self.arrItemList.count

    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as!ItemCell
        let obj = self.arrItemList[indexPath.row]
        let quantity = obj.strQuantity
        cell.lblTitle.text = obj.strMenuName.capitalizingFirstLetter() + " (x" + quantity + ")"
        cell.lblPrice.text = "$" + obj.strMenuPrice
     
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            DispatchQueue.main.async {
                self.tblHeightConstraint.constant = self.tblItems.contentSize.height
                self.tblItems.layoutIfNeeded()
            }
}
    
    
}

//MARK: - Api calling

extension UpcomingDetailVC {
    
    // TODO: Webservice For Order Detail
    
    func callWsForOrderDetail(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
     //   objWebServiceManager.StartIndicator()
        
        if  self.isFromForgroundNotification != true{
               objWebServiceManager.StartIndicator()
        }
        
        var param: [String: Any] = [:]
        param = [
            WsParam.orderID: self.strOrderId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.orderDetail, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        if objAppShareData.isFromBannerNotification == true {
                            objAppShareData.resetBannarData()
                        }
                        self.timer.invalidate()
                        self.arrItemList.removeAll()
                        
                        if let arrItemData = dic?["items_info"] as? [[String: Any]]{
                            for dictItemData in arrItemData
                            {
                                let objData = ItemModel.init(dict: dictItemData)
                                self.arrItemList.append(objData)
                            }
                            print("self.arrItemList.count is \(self.arrItemList.count)")
                            
                        }
                        
                        if let orderDetail = dic?["order_detail"] as? [String:Any]{
                            
                            self.loadOrderDetail(dict : orderDetail)
                        }
                                       
                        self.setBootomView()
                        
                    }
                   
                    else{
                        self.timer.invalidate()
                        self.vwRound.isHidden = true
                    }
                }
                
                self.tblItems.reloadData()
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title:kAlert.localize, controller: self)
            }
            
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
    
    func loadOrderDetail(dict : [String:Any]){
        
        
        self.lblRestaurantTitle.isHidden = true
         self.lblRestaurantCharges.isHidden = true
        
        if let createdAt = dict["time"]as? String{
            
            if createdAt == "" {
                self.lblTime.text = "Order_is_preparing".localize
            }else{
                self.lblTime.text = createdAt.capitalizingFirstLetter() + " \("Away".localize)"
                
            }
               }
        
        
        if let distance = dict["distance"]as? String {
           // self.lblDistance.text =  distance + " KM"
            self.lblDistance.text =  distance
        }
                
        if let profilePic = dict["driver_image"]as? String{
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgCustomerProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_placeholder_img_new"))
            }else{
                self.imgCustomerProfile.image = UIImage.init(named: "user_placeholder_img_new")
            }
        }
        
        if let number = dict["number"]as? String{
            self.lblReferenceId.text = "\("Order_Id".localize) (#" + number + ")"
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
        
        if let cdaLat = dict["cda_lat"]as? String {
            self.strPathDestinationLat =  cdaLat
        }
        
        if let cdaLong = dict["cda_long"]as? String {
            self.strPathDestinationLong =  cdaLong
        }
        
        if let restaurantLat = dict["restaurant_lat"]as? String {
            self.strPathSourceLat =  restaurantLat
        }

        
        if let restaurantLong = dict["restaurant_long"]as? String {
            self.strPathSourceLong =  restaurantLong
            self.drawPath()
            
        }
                if let name = dict["driver_name"]as? String {
                    self.lblCustomerName.text = name.capitalizingFirstLetter()
                    self.vwDriverInfo.isHidden = false
                }else{
                    self.vwDriverInfo.isHidden = true
                }
        
        if let dialCode = dict["driver_dial_code"]as? String {
            self.strDialCode =  dialCode
        }
        if let phoneNumber = dict["driver_phone_number"]as? String {
            self.strPhoneNumber =  phoneNumber
        }
        
        if let driverId = dict["driver_id"]as? String {
            self.strDriverId =  driverId
        }
        
        if let number = dict["number"]as? String {
            self.strReferenceID =  number
        }
        
        if let currentStatus = dict["current_status"]as? String{

    
            if currentStatus == "0"{
                self.vwCancleOrder.isHidden = false
            }else{
                self.vwCancleOrder.isHidden = true
            }
                if currentStatus == "0"{
                    self.timer.invalidate()
                    self.lblStatus.text = " \("Pending".localize) "
                self.lblStatus.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                   }else if currentStatus == "1" {
                    self.timer.invalidate()
                    self.lblStatus.text = " \("Accepted".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1)
                   } else if currentStatus == "2"{
                    self.timer.invalidate()
                    self.lblStatus.text = " \("Cooking".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                   }else if currentStatus == "3" {
                    self.timer.invalidate()
                    self.lblStatus.text = " \("Pickup".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 0.2784313725, green: 0.3254901961, blue: 0.9803921569, alpha: 1)
                   }else if currentStatus == "4" {
                    self.timer.invalidate()
                     //  self.lblStatus.text = " Recived "
                    self.lblStatus.text = " \("Picked_by_driver".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                   } else if currentStatus == "5"{
                    self.runTimerforGetDriverLatLong()
                    self.lblStatus.text = " \("In_Route".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1)
                   }else if currentStatus == "7" {
                    self.timer.invalidate()
                    self.lblStatus.text = " \("Cancelled".localize) "
                       self.lblStatus.textColor = #colorLiteral(red: 1, green: 0.368627451, blue: 0, alpha: 1)
                    
                    
                    // new case
                    self.backFromVc()
                    // new case
            }
        }
    }
    // TODO: Webservice For cancel Order
    func callWsForCancelOrder(strOrderId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
         objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        param = [
            WsParam.orderID: strOrderId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.cancelOrder, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
               // self.navigationController?.popViewController(animated: true)
                // deepak new Testing
                self.backFromVc()
                // deepak new Testing
                                
            } else {
                 objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
             objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
}



//MARK:- extention for Gesture
extension UpcomingDetailVC{
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
                
        self.bottomConstant = self.vwRound.frame.size.height - 250
        self.ViewCreateBottom.constant = -self.bottomConstant
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.left:
                    print("Swiped left")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
                
                self.bottomConstant = self.vwRound.frame.size.height - 230
                 self.vwScroll.isScrollEnabled = false

                    UIView.animate(withDuration: 0.5) {
                        self.vwRound.layoutIfNeeded()
                    }
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
 
                self.vwScroll.isScrollEnabled = true
                DispatchQueue.main.async {
                    self.ViewCreateBottom.constant = 0
                    self.vwRound.layoutIfNeeded()
                   // self.tblItems.reloadData()

                }
                                
//                UIView.animate(withDuration: 0.5) {
//                    self.vwRound.layoutIfNeeded()
//                }
                
            default:
                break
            }
        }
    }
}


extension UpcomingDetailVC {
    
    func mapSetup(){
        self.mapView.isMyLocationEnabled = false
        self.mapView.settings.myLocationButton = false
        self.mapView.delegate = self
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
        let userLocation = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 14);
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = false
        
        
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
                objAlert.showAlert(message: "Location service is disabled!!".localize, title: kAlertTitle.localize, controller: self)
                break
                
            case .denied:
                print("Denied.")
            @unknown default: break
            }
        }
        
    }

    
    
    func runTimer() {
           timer = Timer.scheduledTimer(timeInterval: 30, target: self,   selector: (#selector(UpcomingDetailVC.updateTimer)), userInfo: nil, repeats: true)
       }
       
       @objc func updateTimer() {
     
           self.getCurrentLocation()
           
       }

    
    func drawPath(){
        
        
//        let StrPicklat = (self.strOriginLatitude as NSString).doubleValue
//               let StrPickLong = (self.strOriginLongitude as NSString).doubleValue
        
        let StrPicklat = (self.strPathSourceLat as NSString).doubleValue
        let StrPickLong = (self.strPathSourceLong as NSString).doubleValue
        let StrDellat = (self.strPathDestinationLat as NSString).doubleValue
        let strDellong = (self.strPathDestinationLong as NSString).doubleValue
        
        
        _ = CLLocation(latitude: StrPicklat, longitude: StrPickLong)
        
        //My buddy's location
        _ = CLLocation(latitude: StrDellat, longitude: strDellong)
        
       let source = self.strPathSourceLat + "," + self.strPathSourceLong
        
      //  let source = self.strOriginLatitude + "," + self.strOriginLongitude

        let destination = self.strPathDestinationLat + "," + self.strPathDestinationLong
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: StrPicklat, longitude: StrPickLong, zoom: 14)
        self.mapView.camera = camera
        let position = CLLocationCoordinate2D(latitude: StrDellat, longitude: strDellong)
        let marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "gay_pic_ico")
        
        let position1 = CLLocationCoordinate2D(latitude: StrPicklat, longitude: StrPickLong)
        let marker1 = GMSMarker(position: position1)
        marker1.icon = #imageLiteral(resourceName: "red_pin_ico")
        
        var UserLat:Double = 0
        var UserLong:Double = 0
        
        UserLat = StrPicklat
        UserLong = StrPickLong
        
        let position_1 = CLLocationCoordinate2D(latitude: UserLat, longitude: UserLong)
        let marker_1 = GMSMarker(position: position_1)
        
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving&key=AIzaSyAKkjp3hqOev1vWl4K2m4UWfY-uDLBlBQM"
//        Alamofire.request(url).responseJSON { response in
            
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving&key=AIzaSyBNzeXhR3Hv6U1TgPB1-x27Ic_tiazlTGc"
        Alamofire.request(url).responseJSON { response in
            let json = try! JSON(data: response.data!)
            print(json)
            
            
            let routes = json["routes"].arrayValue
            
            if routes.count == 0{
            }
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                
                // Added by shubham for route in center of view -
                DispatchQueue.main.async
                {
                 if self.mapView != nil
                 {
                  let bounds = GMSCoordinateBounds(path: path!)
                    self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 150.0))
                 }
                }
                
                polyline.map = self.mapView
                //  marker_1.map = self.mapView
                polyline.strokeWidth = 5
                polyline.strokeColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
                 marker_1.icon = #imageLiteral(resourceName: "bike_rider_ico")
            }
        }
        marker.map = self.mapView
        marker1.map = self.mapView
        
    }
    
}


//MARK: - Live Tracking

extension UpcomingDetailVC {
    
    func runTimerforGetDriverLatLong() {
        self.callWsForGetDriverLatLong()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self,   selector: (#selector(UpcomingDetailVC.updateTimerforGetDriverLatLong)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimerforGetDriverLatLong() {
        self.callWsForGetDriverLatLong()
    }
    
    // TODO: Webservice For get Driver lat Long
    
    func callWsForGetDriverLatLong(){
    
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
      //  objWebServiceManager.StartIndicator()

        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.driverId: self.strDriverId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.getFoodDriverLocation  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                
                if message == "No record found".localize{

                    
                }else{
               
                    if let orderDetailData = dict?["orderDetails"] as? [String:Any]{

                        if let lat = orderDetailData["driver_latitude"]as? String{
                            self.strDriverLatitude  = lat
                        }
                        if let long = orderDetailData["driver_longitude"]as? String{
                            self.strDriverLongitude  = long
                        }
                        
                        if let time = orderDetailData["time"]as? String{
                            self.lblTime.text = time.capitalizingFirstLetter() + " \("Away".localize)"
                        }
                        
                        
                        let strDriverlat = (self.strDriverLatitude as NSString).doubleValue
                        let strDriverLong = (self.strDriverLongitude as NSString).doubleValue
                        
                        print("strDriverlat is \(strDriverlat)")
                        print("strDriverLong is \(strDriverLong)")
                        
                        let positionLondon = CLLocationCoordinate2D(latitude: strDriverlat, longitude: strDriverLong)
                       /// let marker = GMSMarker.init()
                        self.marker.position = positionLondon
                        self.marker.icon = #imageLiteral(resourceName: "bike_rider_ico")
                        self.marker.map = self.mapView
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
//                            self.marker.map = nil
//                        }
//

                    }
                }
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
}

