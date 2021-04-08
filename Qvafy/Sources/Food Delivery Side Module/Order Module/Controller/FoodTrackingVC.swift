//
//  FoodTrackingVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 19/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
import HCSStarRatingView

import SDWebImage
import PhoneNumberKit


class FoodTrackingVC: UIViewController, GMSMapViewDelegate , CLLocationManagerDelegate{
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwBack: UIView!
    
    @IBOutlet weak var vwAway: UIView!
    @IBOutlet weak var vwDistance: UIView!
    
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    
    @IBOutlet weak var btnChangeStatus: UIButton!
    @IBOutlet weak var vwChangeStatus: UIView!
    @IBOutlet weak var vwImgChangeStatus: UIView!
    @IBOutlet weak var vwCallDriver: UIView!
    @IBOutlet weak var vwChatDriver: UIView!
    
    
    //Localization Outlets -
    @IBOutlet weak var lblLODistance: UILabel!
    @IBOutlet weak var lblAway: UILabel!
    @IBOutlet weak var lblLOChangeStatus: UILabel!
    //MARK: - Varibles
 
    var locationManager = CLLocationManager()
    var strPathSourceLat = ""
    var strPathSourceLong = ""
    var strPathDestinationLat = ""
    var strPathDestinationLong = ""
    var strOrderId = ""
    var strRestaurantImage = ""
    var strCurrentStatus = ""
    var isFromForgroundNotification = false
   // var objOrderTracking:OrderTracking?
    var arrOrderTracking:[OrderTracking] = []

    
    var strDialCode = ""
    var strPhoneNumber = ""
    var strCustomerId = ""
    var strReferenceID = ""
    
    var strSourceAddress = ""
    var strDriverLatitude = ""
    var strDriverLongitude = ""
    let marker = GMSMarker.init()
    var timer = Timer()
    let phoneNumberKit = PhoneNumberKit()

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
      //  objAppShareData.isOnMapScreen = true
        self.localization()
        self.setUI()
        self.mapSetup()
        
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear is called")
        super.viewDidDisappear(animated)
       // self.timer.invalidate()
        self.mapView.isMyLocationEnabled = false
    }
    
    func setUI(){
        
        
        //self.vwBack.setCornerRadius(radius: 8)
        self.vwDistance.setCornerRadius(radius: 8)
        self.vwAway.setCornerRadius(radius: 8)
        
        
        self.tabBarController?.tabBar.isHidden = true
       // self.vwProfile.setProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile)
        self.vwProfile.setUserProfileView(vwOuter: self.vwProfile, img: self.imgProfile , radius : 4)

        self.vwCallDriver.setShadowWithCornerRadius()
        self.vwChatDriver.setShadowWithCornerRadius()

        self.vwChangeStatus.setButtonView(vwOuter : self.vwChangeStatus , vwImage : self.vwImgChangeStatus, btn: self.btnChangeStatus )
        self.callWsForDeliveryAddressLocation()

        
    }
    override func viewWillDisappear(_ animated: Bool) {
                  super.viewWillDisappear(animated)

              }
   
    
    func localization(){

        self.lblLODistance.text = "Distance".localize
        self.lblAway.text = "Away".localize
        self.lblLOChangeStatus.text = "Change_Status".localize

    }
    
    //MARK: - Buttons Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnCallDriverAction(_ sender: UIButton) {
        self.view.endEditing(true)
//        if let url = NSURL(string: "tel://\("+91-12345")"), UIApplication.shared.canOpenURL(url as URL) {
//            UIApplication.shared.openURL(url as URL)
//        }
        
//        let number = self.strDialCode + "-" + self.strPhoneNumber
//        print("number is \(number)")
//
//        if let url = URL(string: "tel://\(number)"),
//        UIApplication.shared.canOpenURL(url) {
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
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
    
    @IBAction func btnChangeStatusAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let sb = UIStoryboard.init(name: "Order", bundle:Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier:"ChangeStatusVC") as! ChangeStatusVC
        vc.strCurrentStatus = self.strCurrentStatus
        vc.strOrderId = self.strOrderId
        vc.arrOrderTracking = self.arrOrderTracking
        vc.modalPresentationStyle = .overCurrentContext
        
        vc.closerHideBottambar = {
                  isClearListData in
                  if isClearListData{
                      self.callWsForDeliveryAddressLocation()
                  }
              }
        
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
}

extension FoodTrackingVC {
    
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
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 12); //14
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = false
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
                       // print("placemarks is \(placemarks)")
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
                objAlert.showAlert(message:  "Location service is disabled!!".localize, title: kAlertTitle.localize, controller: self)
                break
                
            case .denied:
                print("Denied.")
            @unknown default: break
            }
        }
        
    }
    
}

extension FoodTrackingVC {
    // TODO: Webservice For get delivery Address Location
    func callWsForDeliveryAddressLocation(){
        
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
            WsParam.orderID: self.strOrderId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.deliveryAddressLocation, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                if objAppShareData.isFromBannerNotification == true {
                    objAppShareData.resetBannarData()
                }
               // self.timer.invalidate()
                self.mapView.isMyLocationEnabled = false
                
                if let addressDetail = dic?["delivery_address"] as? [String:Any]{
                    
                    if let number = addressDetail["number"]as? String {
                        self.strReferenceID =  number
                    }
                    if let customerId = addressDetail["customer_id"]as? String {
                        self.strCustomerId = customerId
                    }
                    
                    if let distance = addressDetail["distance"]as? String {
                        self.lblDistance.text =  distance + " \("Km".localize)"
                    }
                    
                    if let time = addressDetail["time"]as? String {
                        self.lblTime.text =  time
                    }
                    
                    if let restaurantAddress = addressDetail["restaurant_address"]as? String {
                        self.lblSource.text =  restaurantAddress
                    }
                    
                    if let cdaAddress = addressDetail["cda_address"]as? String {
                        self.lblDestination.text =  cdaAddress
                    }
                    
                    if let name = addressDetail["customer_name"]as? String {
                        self.lblDriverName.text =  name.capitalizingFirstLetter()
                    }
                    if let dialCode = addressDetail["customer_dial_code"]as? String {
                        self.strDialCode =  dialCode
                    }
                    if let phoneNumber = addressDetail["customer_phone_number"]as? String {
                        self.strPhoneNumber =  phoneNumber
                    }
                    
                    if let profilePic = addressDetail["customer_image"]as? String{
                        if profilePic != "" {
                            let url = URL(string: profilePic)
                            self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        }else{
                            self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                        }
                    }
                    
                    if let profile = addressDetail["restaurant_image"]as? String {
                                          self.strRestaurantImage = profile
                                          
                                      }
                                      
                                      if let currentStatus = addressDetail["current_status"]as? String{
                                          print(  "currentStatus is \(currentStatus)")
                                          self.strCurrentStatus = currentStatus
                                        if currentStatus == "5"{
                                            self.mapView.isMyLocationEnabled = true
                                           // self.runTimerforGetDriverLatLong()
                                        }else{
                                           // self.timer.invalidate()
                                            self.mapView.isMyLocationEnabled = false
                                        }
                                      }
                    
                    if let cdaLat = addressDetail["cda_lat"]as? String {
                      //  self.strPathDestinationLat =  cdaLat
                        self.strPathSourceLat =  cdaLat
                    }
                    
                    if let cdaLong = addressDetail["cda_long"]as? String {
                      //  self.strPathDestinationLong =  cdaLong
                        self.strPathSourceLong =  cdaLong
                    }
                    
                    if let restaurantLat = addressDetail["restaurant_lat"]as? String {
                       // self.strPathSourceLat =  restaurantLat
                        self.strPathDestinationLat =  restaurantLat
                    }
                                        
                    if let restaurantLong = addressDetail["restaurant_long"]as? String {
                        //self.strPathSourceLong =  restaurantLong
                        self.strPathDestinationLong =  restaurantLong
                        self.drawPath()
                        
                    }
                    
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
    
    
    func drawPath(){
    
        
        let StrPicklat = (self.strPathSourceLat as NSString).doubleValue
        let StrPickLong = (self.strPathSourceLong as NSString).doubleValue
        let StrDellat = (self.strPathDestinationLat as NSString).doubleValue
        let strDellong = (self.strPathDestinationLong as NSString).doubleValue
      
        _ = CLLocation(latitude: StrPicklat, longitude: StrPickLong)
        //My buddy's location
        _ = CLLocation(latitude: StrDellat, longitude: strDellong)
        //        let source = self.strOriginLatitude + "," + self.strOriginLongitude
        //        let destination = self.strDestinationLatitude + "," + self.strDestinationLongitude
                let source = self.strPathSourceLat + "," + self.strPathSourceLong
        let destination = self.strPathDestinationLat + "," + self.strPathDestinationLong
        
        let camera = GMSCameraPosition.camera(withLatitude: StrPicklat, longitude: StrPickLong, zoom: 12) // 14)
        self.mapView.camera = camera
        //        let position = CLLocationCoordinate2D(latitude: StrDellat, longitude: strDellong)
        //        let marker = GMSMarker(position: position)
        //        marker.icon = #imageLiteral(resourceName: "gay_pic_ico")
        self.setDataOnMapWith()
        
        let position1 = CLLocationCoordinate2D(latitude: StrPicklat, longitude: StrPickLong)
        let marker1 = GMSMarker(position: position1)
        marker1.icon = #imageLiteral(resourceName: "home_map_ico")
      
//        var UserLat:Double = 0
//        var UserLong:Double = 0
//        UserLat = StrPicklat
//        UserLong = StrPickLong
//        let position_1 = CLLocationCoordinate2D(latitude: UserLat, longitude: UserLong)
//        let marker_1 = GMSMarker(position: position_1)
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving&key=AIzaSyBNzeXhR3Hv6U1TgPB1-x27Ic_tiazlTGc"
        Alamofire.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            print(json)
            
            
            //let json = JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            if routes.count == 0{
            }
            
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                    //added by shubham for route in center of map vew
                let polyline = GMSPolyline.init(path: path)
                DispatchQueue.main.async
                {
                 if self.mapView != nil
                 {
                  let bounds = GMSCoordinateBounds(path: path!)
                  self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                 }
                }
                // let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                //mapView.moveCamera(update)
            
                polyline.map = self.mapView
                //  marker_1.map = self.mapView
                polyline.strokeWidth = 5
                polyline.strokeColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
                // marker_1.icon = #imageLiteral(resourceName: "car_left_ico")
            }
        }
        ///        marker.map = self.mapView
        marker1.map = self.mapView
        //        self.runTimer()
        
        
     
        
        
    }
    
    func setDataOnMapWith() -> Void {

        
        
        let StrDellat = (self.strPathDestinationLat as NSString).doubleValue
        let strDellong = (self.strPathDestinationLong as NSString).doubleValue
        
        
        
        let position = CLLocationCoordinate2D(latitude: StrDellat, longitude: strDellong)
        let marker = GMSMarker(position: position)
        //  marker.icon = #imageLiteral(resourceName: "gay_pic_ico")
        
        //    marker.icon = nil//UIImage(named: "ico_map_pin_f")
        
        ///////////////
        let DynamicView=UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        DynamicView.backgroundColor=UIColor.clear
        
        
        //Creating Marker Pin imageview for Custom Marker
        var imageViewForPinMarker : UIImageView
        imageViewForPinMarker  = UIImageView(frame:CGRect(x: 0, y: 0, width: 50, height: 50));
        imageViewForPinMarker.image = nil//UIImage(named:"ico_map_pin_f")
        
        //Creating User Profile imageview
        var imageViewForUserProfile : UIImageView
        
        imageViewForUserProfile  = UIImageView(frame:CGRect(x: 12, y: 6, width: 35, height: 35))
        imageViewForUserProfile.layer.cornerRadius = imageViewForUserProfile.frame.size.height/2
        imageViewForUserProfile.layer.masksToBounds = true
        imageViewForUserProfile.layer.borderColor = UIColor.white.cgColor
        imageViewForUserProfile.layer.borderWidth = 3
        
        let image = self.strRestaurantImage
        if image == ""
        {
            imageViewForUserProfile.image = nil//#imageLiteral(resourceName: "home_map_ico")
        }else
        {
            let url = URL(string: image)
            imageViewForUserProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "home_map_ico"))
        }
        
        //Adding userprofile imageview inside Marker Pin Imageview
        imageViewForPinMarker.addSubview(imageViewForUserProfile)
        //Adding Marker Pin Imageview isdie view for Custom Marker
        DynamicView.addSubview(imageViewForPinMarker)
        //Converting dynamic uiview to get the image/marker icon.
        UIGraphicsBeginImageContextWithOptions(DynamicView.frame.size, false, UIScreen.main.scale)
        DynamicView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageConverted: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        marker.icon = imageConverted
        //  arrMarker.append(marker)
        marker.map = self.mapView
        /////////////////////
        
    }
    
    func setRootNavigation(){
        
        for vc in (self.navigationController?.viewControllers) ?? []{
            if vc is NewOrderVC {
                self.navigationController?.popToViewController(vc, animated: false)
                break
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
}
//MARK: - Live Tracking

extension FoodTrackingVC {
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
                self.drawPath()
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
    func runTimerforGetDriverLatLong() {
         self.mapView.isMyLocationEnabled = true
        timer = Timer.scheduledTimer(timeInterval: 15, target: self,   selector: (#selector(FoodTrackingVC.updateTimerforGetDriverLatLong)), userInfo: nil, repeats: true)
    }

    @objc func updateTimerforGetDriverLatLong() {
      
       // self.callWsForGetDriverLatLong()
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
                            self.lblTime.text =  time
                        }
                        
                        let strDriverlat = (self.strDriverLatitude as NSString).doubleValue
                        let strDriverLong = (self.strDriverLongitude as NSString).doubleValue
                        
                        print("strDriverlat is \(strDriverlat)")
                        print("strDriverLong is \(strDriverLong)")
                        
                        let positionLondon = CLLocationCoordinate2D(latitude: strDriverlat, longitude: strDriverLong)
                       /// let marker = GMSMarker.init()
                        self.marker.position = positionLondon
                       // self.marker.icon = #imageLiteral(resourceName: "location_ico")
                        self.mapView.isMyLocationEnabled = true
                       // self.marker.map = self.mapView
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

