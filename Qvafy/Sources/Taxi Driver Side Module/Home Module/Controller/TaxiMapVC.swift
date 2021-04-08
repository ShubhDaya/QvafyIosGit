//
//  TaxiMapVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 03/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
import PhoneNumberKit

class TaxiMapVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate , UITextFieldDelegate{
    
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwCustomer: UIView!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var vwPicked: UIView!
    @IBOutlet weak var vwInRoute: UIView!
    @IBOutlet weak var vwDroped: UIView!
    @IBOutlet weak var vwDottedSource: UIView!
    @IBOutlet weak var vwDottedDestination: UIView!
    @IBOutlet weak var vwDottedOTP: UIView!
    @IBOutlet weak var vwDone: UIView!
    @IBOutlet weak var vwOTP: UIView!
    @IBOutlet weak var vwChangeStatus: UIView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnCancle: UIButton!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnInRoute: UIButton!
    @IBOutlet weak var btnDropped: UIButton!
    @IBOutlet weak var btnPicked: UIButton!
    @IBOutlet weak var imgInRoute: UIImageView!
    @IBOutlet weak var imgDropped: UIImageView!
    @IBOutlet weak var imgPicked: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtOTP: UITextField!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblPickedDate: UILabel!
    @IBOutlet weak var lblInRouteDate: UILabel!
    @IBOutlet weak var vwTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var vwPayment: UIView!
    @IBOutlet weak var vwNotPayment: UIView!
    
    @IBOutlet weak var vwCallCustomer: UIView!
       @IBOutlet weak var vwChatCustomer: UIView!
    
     @IBOutlet weak var lblChatCount: UILabel!
    
    //Localization outlets -
    
    @IBOutlet weak var lblLOTripCode: UILabel!
    @IBOutlet weak var lblLODidYouRecivePayment: UILabel!
    @IBOutlet weak var lblPayemtPendingDec: UILabel!
    @IBOutlet weak var lblLOChangStatus: UILabel!
    
    @IBOutlet weak var lblLOPicked: UILabel!
    @IBOutlet weak var lblLOInRoute: UILabel!
    @IBOutlet weak var lblLODropped: UILabel!
    
    //MARK: - Varibles
    
    //       var strSourceLat = ""
    //       var strSourceLong = ""
    var strDestinationLat = ""
    var strDestinationLong = ""
    var StrCurrentSource : String = ""
    var strSourceAddress = ""
    var strDestinationAddress = ""
    var locationManager = CLLocationManager()
    
    var strStatus = ""
    
    var strPathSourceLat = ""
    var strPathSourceLong = ""
    var strPathDestinationLat = ""
    var strPathDestinationLong = ""
    
    
    var strOriginLatitude = ""
    var strOriginLongitude = ""
    var strDestinationLatitude = ""
    var strDestinationLongitude = ""
    var strCurrentLongitude : CLLocationDegrees!
    var strCurrentLatitude : CLLocationDegrees!
    var timer = Timer()
    
    var strBookingId = ""
    
    var isDropped = false
    
    var strPaymentStatus = ""
    var strPaymentMethod = ""
    
    var strDialCode = ""
     var strPhoneNumber = ""
    
    var strReferenceID = ""
    var strCustomerId = ""
    
      var isFromForgroundNotification = false
    
    var strDriverLatitude = ""
    var strDriverLongitude = ""
    let marker = GMSMarker.init()
    let phoneNumberKit = PhoneNumberKit()

    //MARK: - lifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if objAppShareData.isFromBannerNotification == true {
            if  objAppShareData.strBannerNotificationType == "chat"{
            let sb = UIStoryboard(name: "Chat", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
            self.navigationController?.pushViewController(detailVC, animated: false)
                }
            }
        
        let lat = Double(objAppShareData.UserDetail.strLatitude)
        let long = Double(objAppShareData.UserDetail.strLongitude)
    //    print("lat long is \(lat!) and \(long!)")
        
        let camera = GMSCameraPosition.camera(withLatitude: lat ?? 22.75 , longitude: long ?? 75.90 , zoom: 14);
        
        self.mapView.camera = camera
        self.vwBlur.isHidden = true
        self.vwOTP.isHidden = true
        self.vwBottom.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tabbar\(self.tabBarController?.tabBarItem)")
        self.localization()
          objAppShareData.isOnMapScreen = true
        self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
              self.lblChatCount.clipsToBounds = true
               objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
         self.tabBarController?.tabBar.isHidden = false
        self.setUI()
        self.mapSetup()
//        self.vwPayment.isHidden = true
//        self.vwNotPayment.isHidden = true
        self.callWsForGetCurrentRide()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshUI"), object: nil, queue: nil) { [weak self](Notification) in
                  self?.isFromForgroundNotification = true
                  self?.callWsForGetCurrentRide()
              }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
                
        if self.isDropped == true {
            self.mapView.clear()
        }
    }
    
    @objc func refrershUI(){
        self.isFromForgroundNotification = true
        self.callWsForGetCurrentRide()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // self.runTimer() // stop by deepak
        locationManager.startUpdatingLocation()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
        objAppShareData.isOnMapScreen = false
      }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: - Custom Methods
    
    
    func setUI (){
        self.imgInRoute.image = #imageLiteral(resourceName: "active_check_box_ico")
        self.imgDropped.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        self.vwCustomer.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        self.vwChangeStatus.roundCorners(corners: [.topLeft, .topRight], radius: 25.0)
        self.vwDone.setButtonVerifyView(vwOuter: self.vwDone, btn: self.btnDone,viewRadius:Int(17.5), btnRadius:Int(15))
        self.btnStatus.setCornerRadius(cornerRadious: 4)
        self.vwInRoute.setCornerRadius(radius: 8)
        self.vwDroped.setCornerRadius(radius: 8)
        self.vwPicked.setCornerRadius(radius: 8)
        self.vwCallCustomer.setShadowWithCornerRadius()
        self.vwChatCustomer.setShadowWithCornerRadius()
        self.creatDashedLine(view: vwDottedSource)
        self.creatDashedLine(view: vwDottedDestination)
        self.vwProfile.setSubProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile , radius : 2)
        self.btnYes.setCornerRadius(cornerRadious: 8)
        self.vwPayment.isHidden = true
        self.vwNotPayment.isHidden = true
//        self.vwNotPayment.isUserInteractionEnabled = false
//        self.vwPayment.isUserInteractionEnabled = false
        self.vwStatus.isHidden = true//false
    }
    
    
    func localization(){

        self.lblLOTripCode.text  = "Trip_Code :".localize
        self.lblLODidYouRecivePayment.text  = "Did_you_receive_payment?".localize
        self.lblPayemtPendingDec.text  = "You_complete_your_ride_successfully_but_payment_is_pending.".localize
        self.lblLOChangStatus.text  = "Change_Status".localize
        self.lblLOPicked.text  = "Picked".localize
        self.lblLOInRoute.text  = "In_Route".localize
        self.lblLODropped.text  = "Dropped".localize

        self.btnDone.setTitle("Done".localize, for: .normal)
        self.btnCancle.setTitle("Cancel".localize, for: .normal)

        self.btnYes.setTitle("Yes".localize, for: .normal)
        self.txtOTP.placeholder = "Enter_trip_code".localize
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtOTP{
            
            self.txtOTP.resignFirstResponder()
        }
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
          
        if textField == self.txtOTP{

                    let newText = (self.txtOTP.text! as NSString).replacingCharacters(in: range, with: string) as String
                    if string == "" {
                        self.btnStatus.backgroundColor = #colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1)
                        self.btnStatus.isUserInteractionEnabled = false
                        return true
                    }
                    if newText.count >= 0 && newText.count < 6{
                        self.btnStatus.backgroundColor = #colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1)
                        self.btnStatus.isUserInteractionEnabled = false
                        return true
                    }else if newText.count == 6{
                        self.btnStatus.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.2156862745, alpha: 1)
                        self.btnStatus.isUserInteractionEnabled = true
                        //textField.resignFirstResponder()
                        return true
                    } else {
                        self.btnStatus.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.7725490196, blue: 0.2156862745, alpha: 1)
                        self.btnStatus.isUserInteractionEnabled = true
                        textField.resignFirstResponder()
                        return false
                    }
                }
                return true
      }
    
    
    func creatDashedLine(view: UIView){
        let topPoint = CGPoint(x: view.bounds.minX, y: view.bounds.maxY)
        let bottomPoint = CGPoint(x: view.bounds.maxX, y: view.bounds.maxY)
        view.createDashedLine(from: topPoint, to: bottomPoint, color: .lightGray, strokeLength: 8, gapLength: 4, width: 0.5)
        
        
    }
    

    ////////
    
    func initializeTheLocationManager() {
        print("initializeTheLocationManager called")
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted:
                print("No access")
                
            case . denied:
                showAlertLocation()
                
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                
            default:
                break
                
            }
            
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    
    func showAlertLocation()
    {
        objAlert.showAlertCallOneBtnAction(btnHandler: "Settings".localize, title: "Need_Authorization".localize, message: "This app is unusable if you don't authorize this app to use your location!".localize, controller: self) {
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:]
                
                , completionHandler: nil)
            
        }
        
    }
    
    ////////
    
    //MARK: - Button Actions
    
   
    
    @IBAction func btnCrossAction(_ sender: Any) {
        self.view.endEditing(true)
        self.vwBlur.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        print("self.strStatus is \(self.strStatus)")
      
        
        if strStatus == "5" {
            self.runTimerforGetDriverLatLong()
            //self.strStatus = "in route"
            self.imgDropped.image = #imageLiteral(resourceName: "inactive_check_box_ico")
            self.btnDropped.tag = 0
            self.btnStatus.setTitle("  \("Change_Status".localize)  ", for: .normal)
            self.btnCancle.isHidden = true
            self.isFromForgroundNotification = true
            self.callWsForGetCurrentRide()
        }
    }
    
    
    @IBAction func btnPickedAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    @IBAction func btnInRouteAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        self.imgInRoute.image = #imageLiteral(resourceName: "active_check_box_ico")
        
    }
    
    @IBAction func btnDroppedAction(_ sender: UIButton) {
        self.view.endEditing(true)

        if sender.tag == 0 {
            self.imgDropped.image = #imageLiteral(resourceName: "active_check_box_ico")
            sender.tag = 1
            self.strStatus = "5"
            print("strStatus is  \(self.strStatus)")
            
        }else{
            self.imgDropped.image = #imageLiteral(resourceName: "inactive_check_box_ico")
            sender.tag = 0
        }
        self.btnStatus.setTitle("  \("On_the_way".localize)  ", for: .normal)
        
    }
    
    @IBAction func btnDoneAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if  self.imgDropped.image != #imageLiteral(resourceName: "active_check_box_ico") {
            objAlert.showAlert(message: "Please_select_dropped_option".localize, title: kAlert.localize, controller: self)
        }else{
            self.callWsChangeRideStatus(code: "5")
            self.vwBlur.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            
            self.vwBottom.isHidden = true
            self.mapView.clear()
            
        }
        
    }
    
    @IBAction func btnProfileAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancleAction(_ sender: Any) {
        self.view.endEditing(true)
        self.strStatus = "0"
        self.btnStatus.setTitle("  \("On_the_way".localize)  ", for: .normal)
        print("strStatus is  \(self.strStatus)")
        self.callWsChangeRideStatus(code: "0")
        
    }
    
    @IBAction func btnChangeStatus(_ sender: UIButton) {
        self.view.endEditing(true)
        
        print(sender.tag)
        
        if self.strStatus == "pending" {
            
            self.callWsChangeRideStatus(code: "2")
            
        }else if self.strStatus == "on the way" {
            self.callWsChangeRideStatus(code: "3")
        }
            //
        else if self.strStatus == "in route" {
            self.vwBlur.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            
        }
        
    }
    
    @IBAction func btnPaymentAction(_ sender: Any) {
        self.view.endEditing(true)
        print("self.strPaymentStatus  is \(self.strPaymentStatus)")
        print("self.strPaymentMethod  is \(self.strPaymentMethod)")
        
        self.callWsForPay()
    }
    
    @IBAction func btnChatAction(_ sender: Any) {
        self.view.endEditing(true)
       let sb = UIStoryboard(name: "Chat", bundle: nil)
              let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
              self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    @IBAction func btnChatCustomerAction(_ sender: UIButton) {
           self.view.endEditing(true)
           let sb = UIStoryboard(name: "Chat", bundle: nil)
           let detailVC = sb.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
               detailVC.strCustomerId = self.strCustomerId
               detailVC.strOpponentId = self.strCustomerId
               detailVC.strDriverId = objAppShareData.UserDetail.strUserID
               detailVC.strDriverType = "2"
               detailVC.strReferenceID = self.strReferenceID
               detailVC.strOrderRideId = self.strBookingId
               detailVC.isFromDriverSide = true
                detailVC.strReferenceType = "1"
           self.navigationController?.pushViewController(detailVC, animated: true)


       }

       @IBAction func btnCallCustomerAction(_ sender: UIButton) {
           self.view.endEditing(true)
//
//           let number = self.strDialCode + "-" + self.strPhoneNumber
//           print("number is \(number)")
//
//           if let url = URL(string: "tel://\(number)"),
//           UIApplication.shared.canOpenURL(url) {
//           UIApplication.shared.open(url, options: [:], completionHandler: nil)
//           }
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
    
    @IBAction func btnCurrentLocation(_ sender: Any) {
        self.view.endEditing(true)
        print("btnCurrentLocations tapped")
      // self.initializeTheLocationManager()
       // self.getCurrentLocation()
        
        PlacePicker.shared.getUsersCurrentLocation(success: { (location) in
            self.locationOnButton(location: location)
        }) { (Error) in
        }
    }
    // TODO:Get Current Location
    

    func locationOnButton(location : CLLocationCoordinate2D){
           let camera = GMSCameraPosition.camera(withLatitude:location.latitude, longitude: location.longitude, zoom: 14)
           self.mapView.camera = camera
      //  mapView.settings.myLocationButton = false
      //  self.mapView.delegate = self
        
       }
}
//MARK: - Map Setup

extension TaxiMapVC {
    
    func mapSetup(){
        self.mapView.isMyLocationEnabled = true
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
      ///  let userLocation = locations.last
        //        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        //        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 12);
        //        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        
        
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
                     //   print("placemarks is \(placemarks)")
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
                objAlert.showAlert(message: "Location service is disabled!!".localize, title: kAlertTitle.localize, controller: self)
                break
                
            case .denied:
                print("Denied.")
            @unknown default: break
                
            }
        }
    }
}

//MARK: - ApiCalling

extension TaxiMapVC {
    
    // TODO: Webservice For Change Ride Status
    
    func callWsChangeRideStatus(code: String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            ///   objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
         objWebServiceManager.StartIndicator()
        //  var param = [String:Any]()
        var Body = [String:Any]()
        var strWsUrl = ""
        let bookingId = strBookingId
        strWsUrl  =   WsUrl.changeRideStatus  +  bookingId
        
        Body = ["status" : code , "tripe_code" :self.txtOTP.text ?? ""]
        print(Body)
        
        objWebServiceManager.requestPatch(strURL: strWsUrl, params: Body as [String : AnyObject] , strCustomValidation: "", success: {response in
            print(response)
            /// objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                self.callWsForGetCurrentRide()
                
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    // TODO: Webservice For get current Ride
    func callWsForGetCurrentRide(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if  self.isFromForgroundNotification != true{
        objWebServiceManager.StartIndicator()
        }
        
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.userType: "2"
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.myCurrentRide  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
               // self.drawPath()

                let dict  = response["data"] as? [String:Any]
                if message == "No record found".localize || message == "No record found"{
                    self.timer.invalidate()
                    self.vwBottom.isHidden = true
                    self.mapView.clear()
                    
                }else{
                    self.timer.invalidate()
                    self.vwBottom.isHidden = false
                   
                    if objAppShareData.isFromBannerNotification == true {
                        objAppShareData.resetBannarData()
                    }
                    
                    if let rideDetailData = dict?["rideDetails"] as? [String:Any]{
                        
                        
                        if let time = rideDetailData["time"]as? String{
                            
                            
                            self.lblTime.text = "\(time.capitalizingFirstLetter()) \("Away".localize)"
                        }
                        if let id = rideDetailData["bookingID"]as? String{
                            self.strBookingId  = id
                        }
                        
                        if let number = rideDetailData["number"]as? String{
                                           self.strReferenceID =  number
                        }
                        if let customerId = rideDetailData["customer_id"]as? String{
                                           self.strCustomerId =  customerId
                        }
                        
                        
                        if let distance = rideDetailData["distance"]as? String{
                            self.lblDistance.text = "\(distance) \("Km".localize)"
                        }
                        
                        if let source = rideDetailData["source"]as? String{
                            self.lblSource.text = source
                        }
                        
                        if let destination = rideDetailData["destination"]as? String{
                            self.lblDestination.text = destination
                        }
                        
                        if let dLat = rideDetailData["d_latitude"]as? String{
                            self.strPathDestinationLat = dLat
                        }
                        if let dLong = rideDetailData["d_longitude"]as? String{
                            self.strPathDestinationLong = dLong
                        }
                        
                        if let dLat = rideDetailData["s_latitude"]as? String{
                            self.strPathSourceLat = dLat
                        }
                        if let SLong = rideDetailData["s_longitude"]as? String{
                            self.strPathSourceLong = SLong
                        }
                        
                        if let createdAt = rideDetailData["created_at"]as? String{
                           // let date = objAppShareData.changeDateformatWithDate(strDate: createdAt )
                            let date = objAppShareData.convertLocalTime(strDateTime: createdAt)

                            self.lblPickedDate.text = date
                            self.lblInRouteDate.text = date
                            
                        }
                        
                        
                        if let paymentStatus = rideDetailData["payment_status"]as? String{
                            self.strPaymentStatus = paymentStatus
                        }
                        
                        if let paymentMethod = rideDetailData["payment_method"]as? String{
                            self.strPaymentMethod = paymentMethod
                        }
                        
                        
                        
                        if let statusText = rideDetailData["status_text"]as? String{
                            
                            if statusText == "pending" {
                                self.vwNotPayment.isHidden = true
                                self.btnStatus.setTitle("  \("On_the_way".localize) ", for: .normal)
                                self.strStatus = "pending"
                                self.btnCancle.isHidden = false
                                self.vwStatus.isHidden = false // shubham
                            }else if statusText == "on the way" {
                                self.runTimerforGetDriverLatLong()
                                self.btnStatus.setTitle("     \("Pickup".localize)     ", for: .normal)
                                self.strStatus = "on the way"
                                self.vwOTP.isHidden = false
                                self.btnStatus.backgroundColor = #colorLiteral(red: 0.6705882353, green: 0.6705882353, blue: 0.6705882353, alpha: 1)
                                self.btnStatus.isUserInteractionEnabled = false
                                self.btnCancle.isHidden = true
                                self.vwStatus.isHidden = false // shubham
                            }else if statusText == "picked" {
                                self.runTimerforGetDriverLatLong()
                                //
                                self.strStatus = "picked"
                                 self.callWsChangeRideStatus(code: "4")
                                //
                                self.txtOTP.text = ""
                                self.vwOTP.isHidden = true
                                self.btnCancle.isHidden = true
                               // self.strStatus = "in route"
                                //    self.btnStatus.setTitle("  In route  ", for: .normal)
                                self.btnStatus.setTitle("  \("Change_Status".localize)  ", for: .normal)
                                self.vwStatus.isHidden = false // shubham
                                ////////////////////////////
                            }else if statusText == "in route" {
                                self.runTimerforGetDriverLatLong()
                                self.strStatus = "in route"
                                self.btnStatus.setTitle("  \("Change_Status".localize)  ", for: .normal)
                                self.btnCancle.isHidden = true
                                self.vwStatus.isHidden = false // shubham
                                ////////////////////////////////////////////////////////////////
                            }else if  statusText == "dropped" {
                                self.timer.invalidate()
                                self.vwBlur.isHidden = true
                                self.tabBarController?.tabBar.isHidden = false
                                
                                print("self.strPaymentMethod is \(self.strPaymentMethod)")
                                 print("self.strPaymentStatus is \(self.strPaymentStatus)")
                                if self.strPaymentMethod == "1" && self.strPaymentStatus == "0"{
                                    self.vwStatus.isHidden = true
                                    self.vwPayment.isHidden = false
                                    self.vwNotPayment.isHidden = true
                                    //self.vwNotPayment.isUserInteractionEnabled = true
                                   
                                } else if self.strPaymentMethod == "2" && self.strPaymentStatus == "0"{
                                    self.vwStatus.isHidden = true
                                    self.vwPayment.isHidden = true
                                    self.vwNotPayment.isHidden = false
                                     //self.vwPayment.isUserInteractionEnabled = true
                                }else{
                                       self.vwBottom.isHidden = true
                                       self.mapView.clear()
                                       self.isDropped = true
                                }
                            }
                            
                            print("strStatus is  \(self.strStatus)")
                        }
                        
                        /*
                        if let customerData = self.convertToDictionary(text: rideDetailData["customer_info_json"] as? String ?? "") {
                            
                            if let customerDialCode = customerData["dial_code"]as? String{
                                 self.strDialCode =  customerDialCode
                            }
                            
                            if let customerPhoneNumber = customerData["phone_number"]as? String{
                                self.strPhoneNumber =  customerPhoneNumber
                            }
                            
                            if let fullName = customerData["customer_name"]as? String{
                                self.lblFullName.text = fullName.capitalizingFirstLetter()
                             }
                            
                            if let avatar = customerData["avatar"]as? String{
                                let profilePic = avatar
                                if profilePic != "" {
                                    let url = URL(string: profilePic)
                                    self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                                }else{
                                    self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                                }
                            }
                        }
                        
                        */
                        
                        
                        // new deepak updated testing

                        self.lblFullName.text = dictToStringKeyParam(dict: rideDetailData, key: "customer_name").capitalizingFirstLetter()
                        self.strDialCode = dictToStringKeyParam(dict: rideDetailData, key: "customer_dial_code")
                        self.strPhoneNumber = dictToStringKeyParam(dict: rideDetailData, key: "customer_phone_number")
                        let profilePic = dictToStringKeyParam(dict: rideDetailData, key: "customer_image")

                        if profilePic != "" {
                        let url = URL(string: profilePic)
                        self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        }else{
                        self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                        }

                        // new deepak updated testing
                        
                        self.drawPath()
                    }
                }
                objWebServiceManager.StopIndicator()
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
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
    
    
    // TODO: Webservice For Pay
    
    func callWsForPay(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork .localize, title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param = [String:Any]()
        
        param = [ "bookingId": self.strBookingId ]
        
        print(param)
        
        
        objWebServiceManager.requestPut(strURL: WsUrl.payRide, Queryparams:[:], body:param,strCustomValidation: "", success: {response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                
                //  self.callWsForGetCurrentRide()
                
               
                self.vwPayment.isHidden = true
                self.vwStatus.isHidden = false
                self.vwBottom.isHidden = true
                self.mapView.clear()
                self.isDropped = true
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


//////////////


//MARK: - timer & path and update Location


extension TaxiMapVC {
    
    func runTimer() {
        //timer = Timer.scheduledTimer(timeInterval: 30, target: self,   selector: (#selector(MapVC.updateTimer)), userInfo: nil, repeats: true)
         self.getCurrentLocation()
    }
    
    @objc func updateTimer() {
        //  print("Timer")
        //        let lookingLocation = CLLocation(latitude: CLLocationDegrees(self.strCurrentLatitude), longitude: CLLocationDegrees(self.strCurrentLongitude))
        //        let leavingLocation = CLLocation(latitude: CLLocationDegrees(self.strDestinationLatitude)!, longitude: CLLocationDegrees(self.strDestinationLongitude)!)
        //        var distance:CLLocationDistance =
        //            lookingLocation.distance(from: leavingLocation)
        //        if distance < 0 {
        //        distance = (distance * -1)
        //        }
        //        var strDistance = String(format: "%0.2f", distance)
        //        strDistance = String(format: "%0.2f", Double(strDistance)! * 0.000621371)
        //        let distanceDouble = Double(strDistance)!
        //        let eventDistance: Float = Float(distanceDouble * 1609.34)
        //        if eventDistance <= 100{
        //        }else{
        //            self.getCurrentLocation()
        //
        //        }
        //
        self.getCurrentLocation()
        
    }
    
    
    
    func getCurrentLocation() {
        PlacePicker.shared.getUsersCurrentLocation(success: { (location) in
            self.location(location: location)
        }) { (Error) in
            
        }
        // Do any additional setup after loading the view.
    }
    
    func location(location : CLLocationCoordinate2D){
//        let camera = GMSCameraPosition.camera(withLatitude:location.latitude, longitude: location.longitude, zoom: 12.0)
//        self.mapView.camera = camera
//        self.mapView.delegate = self
//        mapView.isMyLocationEnabled = true
//        mapView.settings.myLocationButton = false
//        let marker = GMSMarker()
//        marker.position = location
//        print(location.latitude)
//        print(location.longitude)
//        self.strOriginLongitude = String(location.longitude)
//        self.strOriginLatitude = String(location.latitude)
        
        //// update location api calling
        
        
        //    self.callWsForUpdateLocation()
        // get driver location
        //  self.drawPath()
        
    }
    
    func drawPath(){
        
        let StrPicklat = (self.strPathSourceLat as NSString).doubleValue
        let StrPickLong = (self.strPathSourceLong as NSString).doubleValue
        
//        let StrPicklat = (self.strOriginLatitude as NSString).doubleValue
//        let StrPickLong = (self.strOriginLongitude as NSString).doubleValue
        
        let StrDellat = (self.strPathDestinationLat as NSString).doubleValue
        let strDellong = (self.strPathDestinationLong as NSString).doubleValue
        
        //groundAnchor = CGPoint(x: 0.5, y: 1)
        _ = CLLocation(latitude: StrPicklat, longitude: StrPickLong)
        _ = CLLocation(latitude: StrDellat, longitude: strDellong)
        
        let source = self.strPathSourceLat + "," + self.strPathSourceLong
        let destination = self.strPathDestinationLat + "," + self.strPathDestinationLong
        
        let camera = GMSCameraPosition.camera(withLatitude: StrDellat, longitude: strDellong, zoom: 14)

        self.mapView.camera = camera
        let position = CLLocationCoordinate2D(latitude: StrDellat, longitude: strDellong)
        let marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "gay_pic_ico")
        
        let position1 = CLLocationCoordinate2D(latitude: StrPicklat, longitude: StrPickLong)
        let marker1 = GMSMarker(position: position1)
        marker1.icon = #imageLiteral(resourceName: "red_pin_ico")
        
//        var UserLat:Double = 0
//        var UserLong:Double = 0
//        UserLat = StrPicklat
//        UserLong = StrPickLong
      ///  let position_1 = CLLocationCoordinate2D(latitude: UserLat, longitude: UserLong)
       /// let marker_1 = GMSMarker(position: position_1)
        
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
                polyline.map = self.mapView
                polyline.strokeWidth = 5
                polyline.strokeColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
               // marker_1.map = self.mapView
               // marker_1.icon = #imageLiteral(resourceName: "taxi_ico")
                DispatchQueue.main.async
                {
                 if self.mapView != nil
                 {
                  let bounds = GMSCoordinateBounds(path: path!)
                    self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 150.0))
                  //self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                  }
                }
            }
        }
        marker.map = self.mapView
        marker1.map = self.mapView
        
     
       
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
}


//MARK: - Live Tracking

extension TaxiMapVC {
    
    func runTimerforGetDriverLatLong() {
        self.callWsForGetDriverLatLong()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self,   selector: (#selector(TaxiMapVC.updateTimerforGetDriverLatLong)), userInfo: nil, repeats: true)
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
            WsParam.driverId: objAppShareData.UserDetail.strUserID
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.getTaxiDriverLocation  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                
                if message == "No record found".localize{

                    
                }else{
               
                    if let rideDetailData = dict?["rideDetails"] as? [String:Any]{

                        if let time = rideDetailData["time"]as? String{
                            self.lblTime.text = "\(time.capitalizingFirstLetter()) \("Away".localize)"
                        }
                        
                        if let lat = rideDetailData["driver_latitude"]as? String{
                            self.strDriverLatitude  = lat
                        }
                        if let long = rideDetailData["driver_longitude"]as? String{
                            self.strDriverLongitude  = long
                        }

                        
                        let strDriverlat = (self.strDriverLatitude as NSString).doubleValue
                        let strDriverLong = (self.strDriverLongitude as NSString).doubleValue
                        
                        print("strDriverlat is \(strDriverlat)")
                        print("strDriverLong is \(strDriverLong)")
                        
                        let positionLondon = CLLocationCoordinate2D(latitude: strDriverlat, longitude: strDriverLong)
                       /// let marker = GMSMarker.init()
                        self.marker.position = positionLondon
                        self.marker.icon = #imageLiteral(resourceName: "taxi_ico")
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
