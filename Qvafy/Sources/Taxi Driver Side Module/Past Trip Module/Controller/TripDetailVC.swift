//
//  TripDetailVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 10/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import GoogleMaps
//import GooglePlaces
import CoreLocation
import Alamofire
import SwiftyJSON
import HCSStarRatingView



class TripDetailVC: UIViewController, GMSMapViewDelegate , CLLocationManagerDelegate{
    
    //MARK: - Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwBack: UIView!
    
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var vwPrice: UIView!
    @IBOutlet weak var vwDistance: UIView!
    
    
    @IBOutlet weak var vwBlurRating: UIView!
    @IBOutlet weak var vwBlurBottom: UIView!
    @IBOutlet weak var vwRating: HCSStarRatingView!
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSource: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblDriverRating: UILabel!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblRatingText: UILabel!
    @IBOutlet weak var lblDriverCustomerInfo: UILabel!
    @IBOutlet weak var vwDriverCustomerRating: UIView!
    
    
    @IBOutlet weak var btnGiveReview: UIButton!
    @IBOutlet weak var vwGiveReview: UIView!
    @IBOutlet weak var vwImgGiveReview: UIView!
    
    @IBOutlet weak var vwReviewRating: UIView!
    @IBOutlet weak var vwGiveReviewRating: UIView!
    
    @IBOutlet weak var vwTxt: UIView!
    
    // Localization outlets -
    @IBOutlet weak var lblLODateTime: UILabel!
    @IBOutlet weak var lblLOKiliMeter: UILabel!
    @IBOutlet weak var lblLOPrice: UILabel!
    @IBOutlet weak var lblLOStatus: UILabel!
    @IBOutlet weak var lblLoDriverInformation: UILabel!
    @IBOutlet weak var lblGiveReview: UILabel!
    
    // deepak new work
    @IBOutlet weak var vwReviewRequest: UIView!
    @IBOutlet weak var lblReviewRequest: UILabel!
    @IBOutlet weak var btnReviewRequest: UIButton!
    @IBOutlet weak var vwDotted: UIView!
    
    // deepak new work
    
    //MARK: - Varibles
    var strBookingId = ""
    var strUserId = ""
    var strName = ""
    var strprofile = ""
    var strUserType = "1"
    var isFromCustomer = false
    
    
    var locationManager = CLLocationManager()
    var strPathSourceLat = ""
    var strPathSourceLong = ""
    var strPathDestinationLat = ""
    var strPathDestinationLong = ""
    var strStatus = ""
    
    var isFromForgroundNotification = false
    
    var strIsRemind = ""
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.vwReviewRating.isHidden = true
        self.vwGiveReviewRating.isHidden = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.localization()
        self.setUI()
        // self.mapSetup()
        if self.isFromCustomer == true {
            //  self.tabBarController?.tabBar.isHidden = true
            self.lblDriverCustomerInfo.text = "Driver_Information".localize
            self.vwDriverCustomerRating.isHidden = false
            self.callWsForGetBookingDetails()
        }else{
            //self.tabBarController?.tabBar.isHidden = false
            self.vwDriverCustomerRating.isHidden = true
            self.lblDriverCustomerInfo.text = "Customer_Information".localize
            self.strUserType = "2"
            self.callWsForGetBookingDetails()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        
    }
    
    @objc func refrershUI(){
        self.isFromForgroundNotification = true
        if self.isFromCustomer == true {
            //  self.tabBarController?.tabBar.isHidden = true
            self.lblDriverCustomerInfo.text = "Driver_Information".localize
            self.vwDriverCustomerRating.isHidden = false
            self.callWsForGetBookingDetails()
        }else{
            //self.tabBarController?.tabBar.isHidden = false
            self.vwDriverCustomerRating.isHidden = true
            self.lblDriverCustomerInfo.text = "Customer_Information".localize
            self.strUserType = "2"
            self.callWsForGetBookingDetails()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
        
        objAppShareData.isUpcomingDetailScreen = false
    }
    
    
    func localization(){
        self.btnReviewRequest.setCornerRadius(cornerRadious: 8)
        self.lblLODateTime.text = "Date_&_Time".localize
        self.lblLOKiliMeter.text = "Kilometer".localize
        self.lblLOPrice.text = "Price".localize
        self.lblLOStatus.text = "Status".localize
        self.lblLoDriverInformation.text = "Driver_Information".localize
        self.lblGiveReview.text = "Give_Review".localize
        self.vwReviewRequest.isHidden = true
        self.btnReviewRequest.setTitle("Request_Review".localize, for: .normal)
        self.lblReviewRequest.text  = "Ask_customer_for_Reviews".localize
        
    }
    
    
    func setUI(){
        
        //self.vwTxt.setCornerRadBoarder(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: 8)
        
        self.vwBack.setCornerRadius(radius: 8)
        self.vwPrice.setCornerRadius(radius: 5)
        self.vwDistance.setCornerRadius(radius: 5)
        self.vwStatus.setCornerRadius(radius: 5)
        
        self.vwGiveReview.setButtonView(vwOuter : self.vwGiveReview , vwImage : self.vwImgGiveReview, btn: self.btnGiveReview )
        // self.vwProfile.setSubProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile , radius : 4)
        
        
        self.vwProfile.setProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile)
        //  self.vwProfile.setShadowWithCornerRadius()
        
    }
    
    //MARK: - Buttons Action
    
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnGiveRatingAction(_ sender: Any){
        self.view.endEditing(true)
        
        let sb = UIStoryboard(name: "Map", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
        detailVC.strBookingId = self.strBookingId
        detailVC.strUserId = self.strUserId
        detailVC.strProfile = self.strprofile
        detailVC.strName = self.strName
        
        //
        detailVC.closerDeleteAlertList = {
            isClearListData in
            if isClearListData{
                self.callWsForGetBookingDetails()
            }
        }
        
        //
        detailVC.modalPresentationStyle = .overCurrentContext
        self.present(detailVC, animated: false, completion: nil)
    }
    
    // deepak new work
    @IBAction func btnReviewRequestAction(_ sender: Any) {
        self.vwReviewRequest.isHidden = true
     //   print("btnReviewRequestAction pressed \(self.strStatus)")
        self.callWsChangeRequestReview()
    }
    // deepak new work
}

extension TripDetailVC {
    
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
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 14); // zoom: 14
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
                    //                    else if let country = placemarks?.first?.country,
                    //                        let city = placemarks?.first?.subLocality {
                    //                        print(country)
                    //                       // print("placemarks is \(placemarks)")
                    //                        print("lat is \(String(latitude))")
                    //                        print("long is \(String(longitude))")
                    //
                    //
                    //
                    //
                    //                        //                        self.strSourceAddress = city
                    //                        //                        var Lat = String(latitude)
                    //                        //                        var Long = String(longitude)
                    //                        //
                    //                        //
                    //                        //                        self.callWsForUpdateLocation(lat : Lat , long : Long , address : city )
                    //
                    //                    }
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

extension TripDetailVC {
    
    // TODO: Webservice For get Booking Details
    func callWsForGetBookingDetails(){
        
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
            WsParam.bookingID: self.strBookingId
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.getBookingDetails  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            var ratingValue =  ""
            
            if status == "success"
            {
                
                if objAppShareData.isFromBannerNotification == true {
                    objAppShareData.resetBannarData()
                }
                
                
                
                
                let dict  = response["data"] as? [String:Any]
                
                if let rideDetailData = dict?["rideDetails"] as? [String:Any]{
                    
                    var strGivenReview = ""
                    
                    if let createdAt = rideDetailData["created_at"]as? String{
                        
                        if createdAt != ""{
                            // let date = objAppShareData.changeDateformat(strDate: createdAt )
                            let date = objAppShareData.pastTripDateTime(strDateTime: createdAt ) // convert local for today check
                            
                            self.lblTime.text = date
                            
                        }
                    }
                    
                    if let distance = rideDetailData["distance"]as? String{
                        self.lblDistance.text = distance
                    }
                    
                    if let price = rideDetailData["price"]as? String{
                        
                        self.lblPrice.text = "$" + price
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
                    
                    
                    if let driveRating = rideDetailData["driver_avg_rating"]as? String{
                        //  self.lblDriverRating.text = driveRating
                        let string = NSString(string: driveRating)
                        self.lblDriverRating.text = String(string.doubleValue)
                    }
                    
                    
                    if let rating = rideDetailData["rating"]as? String{
                        
                        ratingValue = rating
                    }
                    
                    if let ratingData = Double(ratingValue) {
                        self.vwRating.value  = CGFloat(ratingData)
                    }
                    if let review = rideDetailData["review"]as? String{
                        self.lblRatingText.text = review
                        strGivenReview = review
                    }
                    
                    if self.isFromCustomer == true {
                        
                        if ratingValue != "" {
                            self.vwReviewRating.isHidden = false
                            self.vwGiveReviewRating.isHidden = true
                        }else{
                            self.vwGiveReviewRating.isHidden = false
                            self.vwReviewRating.isHidden = true
                            
                        }
                        /*
                         if let driverrData = objAppShareData.convertToDictionary(text: rideDetailData["driver_json"] as? String ?? "") {
                         
                         
                         if let fullName = driverrData["full_name"]as? String{
                         self.lblDriverName.text = fullName.capitalizingFirstLetter()
                         self.strName = fullName
                         
                         }
                         if let avatar = driverrData["avatar"]as? String{
                         //  let profilePic = avatar
                         self.strprofile = avatar
                         if self.strprofile != "" {
                         let url = URL(string: self.strprofile)
                         self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                         }else{
                         self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                         }
                         
                         }
                         if let userID = driverrData["userID"]as? String{
                         self.strUserId = userID
                         
                         }
                         
                         }
                         */
                        // new deepak updated testing
                        
                        self.strName = dictToStringKeyParam(dict: rideDetailData, key: "driver_name").capitalizingFirstLetter()
                        self.strUserId = dictToStringKeyParam(dict: rideDetailData, key: "driver_id")
                        self.strprofile = dictToStringKeyParam(dict: rideDetailData, key: "driver_image")
                        self.lblDriverName.text = self.strName
                        
                        if self.strprofile != "" {
                            let url = URL(string: self.strprofile)
                            self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        }else{
                            self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                        }
                        // new deepak updated testing
                        
                    }else{
                        
                        if ratingValue != "" {
                            self.vwReviewRating.isHidden = false
                            // self.vwGiveReviewRating.isHidden = true
                        }else{
                            // self.vwGiveReviewRating.isHidden = false
                            self.vwReviewRating.isHidden = true
                            
                        }
                        
                        
                        // self.vwReviewRating.isHidden = false
                        /*
                         if let customerData = objAppShareData.convertToDictionary(text: rideDetailData["customer_info_json"] as? String ?? "") {
                         
                         
                         if let fullName = customerData["customer_name"]as? String{
                         self.lblDriverName.text = fullName.capitalizingFirstLetter()
                         self.strName = fullName
                         
                         }
                         if let avatar = customerData["avatar"]as? String{
                         //  let profilePic = avatar
                         self.strprofile = avatar
                         if self.strprofile != "" {
                         let url = URL(string: self.strprofile)
                         self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                         }else{
                         self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                         }
                         
                         }
                         
                         }
                         */
                        
                        // new deepak updated testing
                        self.strName = dictToStringKeyParam(dict: rideDetailData, key: "customer_name").capitalizingFirstLetter()
                        self.strprofile = dictToStringKeyParam(dict: rideDetailData, key: "customer_image")
                        
                        self.lblDriverName.text = self.strName
                        
                        if self.strprofile != "" {
                            let url = URL(string: self.strprofile)
                            self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        }else{
                            self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                        }
                        
                        self.strStatus = dictToStringKeyParam(dict: rideDetailData, key: "status")
                        
                        let remind = dictToStringKeyParam(dict: rideDetailData, key: "is_remind")
                        if remind == "1" {
                            
                            if ratingValue != "" && strGivenReview != "" && self.strStatus == "0"{
                                self.vwReviewRequest.isHidden = true
                                self.btnReviewRequest.isUserInteractionEnabled = false
                                self.btnReviewRequest.backgroundColor = UIColor.lightGray
                                self.lblReviewRequest.textColor = UIColor.lightGray
                                self.lblReviewRequest.backgroundColor = .clear

                                self.btnReviewRequest.setTitle("Requested_Review".localize, for: .normal)
                                self.lblReviewRequest.text  = "You already sent request for the review. Please wait for the customer's response.".localize
                                
                                
                            }else if ratingValue == "" && strGivenReview == "" && self.strStatus != "0"{
                                self.vwReviewRequest.isHidden = false
                                self.btnReviewRequest.isUserInteractionEnabled = false
                                self.btnReviewRequest.backgroundColor = UIColor.lightGray
                                self.lblReviewRequest.textColor = UIColor.lightGray
                                self.lblReviewRequest.backgroundColor = .clear

                                self.btnReviewRequest.setTitle("Requested_Review".localize, for: .normal)
                                self.lblReviewRequest.text  = "You already sent request for the review. Please wait for the customer's response.".localize
                                
                            }
                    
                        }else if remind == "0"  && self.strStatus != "0"{
                            self.vwReviewRequest.isHidden = false
                            self.btnReviewRequest.isUserInteractionEnabled = true
                            self.btnReviewRequest.backgroundColor = #colorLiteral(red: 0.9994242787, green: 0.7029308677, blue: 0, alpha: 1)
                            self.lblReviewRequest.textColor = #colorLiteral(red: 0.9994242787, green: 0.7029308677, blue: 0, alpha: 1)
                            self.btnReviewRequest.setTitle("Request_Review".localize, for: .normal)
                            self.lblReviewRequest.text  = "Ask_customer_for_Reviews".localize
                        }
               
                        // new deepak updated testing
                    }
                    
                    if let statusText = rideDetailData["status_text"]as? String{
                        
                        if statusText == "cancelled" {
                            self.lblStatus.text = "Cancelled".localize
                            self.vwReviewRating.isHidden = true
                            self.vwGiveReviewRating.isHidden = true
                        }else if  statusText == "dropped" || statusText == "completed"   {
                            self.lblStatus.text = "Completed".localize
                            
                        }
                        
                    }
                    
                    
                    self.drawPath()
                    
                }
                
                
            }else{
                objAlert.showAlert(message:message ?? "", title: "Alert".localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: "Alert".localize, controller: self)
            
        })
        
    }
    
    // TODO: Webservice For request review
    
    func callWsChangeRequestReview(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        // var param = [String:Any]()
        // var Body = [String:Any]()
        var strWsUrl = ""
        let bookingId = self.strBookingId
        strWsUrl = WsUrl.ratingRemind + bookingId
        
        print("strWsUrl of request review is \(strWsUrl)")
        
        objWebServiceManager.requestPatch(strURL: strWsUrl, params: [:] as [String : AnyObject] , strCustomValidation: "", success: {response in
            print(response)
            /// objWebServiceManager.StopIndicator()
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            
            if status == "success"{
                let dict  = response["data"] as? [String:Any]
                if let rideDetailData = dict?["rideDetails"] as? [String:Any]{
                    let remind = dictToStringKeyParam(dict: rideDetailData, key: "is_remind")
                    if remind == "1"{
                        objAlert.showAlert(message: message ?? "", title: kAlert.localize, controller: self)
                       // self.vwReviewRequest.isHidden = true
                        
                        self.vwReviewRequest.isHidden = false
                        self.btnReviewRequest.isUserInteractionEnabled = false
                        self.btnReviewRequest.backgroundColor = UIColor.lightGray
                        self.lblReviewRequest.textColor = UIColor.lightGray
                        self.btnReviewRequest.setTitle("Requested_Review".localize, for: .normal)
                        self.lblReviewRequest.text  = "You already sent request for the review. Please wait for the customer's response.".localize
                    }else{
                        self.vwReviewRequest.isHidden = false
                        self.btnReviewRequest.isUserInteractionEnabled = true
                        self.btnReviewRequest.backgroundColor = #colorLiteral(red: 0.9994242787, green: 0.7029308677, blue: 0, alpha: 1)
                        self.lblReviewRequest.textColor = #colorLiteral(red: 0.9994242787, green: 0.7029308677, blue: 0, alpha: 1)
                       
                        self.btnReviewRequest.setTitle("Request_Review".localize, for: .normal)
                        self.lblReviewRequest.text  = "Ask_customer_for_Reviews".localize
                        
                        objAlert.showAlert(message: message ?? "", title: kAlert.localize, controller: self)
                        
                    }
                }
                  
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
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
        
        let source = self.strPathSourceLat + "," + self.strPathSourceLong
        let destination = self.strPathDestinationLat + "," + self.strPathDestinationLong
        
        let camera = GMSCameraPosition.camera(withLatitude: StrPicklat, longitude: StrPickLong, zoom: 14) // zoom: 14
        self.mapView.camera = camera
        let position = CLLocationCoordinate2D(latitude: StrDellat, longitude: strDellong)
        let marker = GMSMarker(position: position)
        marker.icon = #imageLiteral(resourceName: "gay_pic_ico")
        
        let position1 = CLLocationCoordinate2D(latitude: StrPicklat, longitude: StrPickLong)
        let marker1 = GMSMarker(position: position1)
        marker1.icon = #imageLiteral(resourceName: "red_pin_ico")
        
        // mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        
        
        //        var UserLat:Double = 0
        //        var UserLong:Double = 0
        //        UserLat = StrPicklat
        //        UserLong = StrPickLong
        //        let position_1 = CLLocationCoordinate2D(latitude: UserLat, longitude: UserLong)
        //        let marker_1 = GMSMarker(position: position_1)
        
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
                polyline.map = self.mapView
                //  marker_1.map = self.mapView
                polyline.strokeWidth = 5
                polyline.strokeColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
                
                DispatchQueue.main.async
                {
                    if self.mapView != nil
                    {
                        let bounds = GMSCoordinateBounds(path: path!)
                        self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                    }
                }
                
                
                
                // marker_1.icon = #imageLiteral(resourceName: "car_left_ico")
            }
        }
        marker.map = self.mapView
        marker1.map = self.mapView
        
        //        self.runTimer()
    }
}

