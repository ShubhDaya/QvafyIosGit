//
//  MapVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 23/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation
import SlideMenuControllerSwift
import Alamofire
import SwiftyJSON
import PhoneNumberKit
var strvehicleMetaID = ""
class MapVC: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate{
    
    
    //MARK: - Outlets
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var vwContinue: UIView!
    @IBOutlet weak var vwInput: UIView!
    @IBOutlet weak var vwCancle: UIView!
    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var vwNext: UIView!
    @IBOutlet weak var vwImgNext: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwOk: UIView!
    @IBOutlet weak var vwStackDetail: UIStackView!
    @IBOutlet weak var lblVehicle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var imgVehicle: UIImageView!
    @IBOutlet weak var vwCollectionVehicle: UICollectionView!
    @IBOutlet weak var vwLeft: UIView!
    @IBOutlet weak var vwRight: UIView!
    @IBOutlet weak var vwData: UIView!
    @IBOutlet weak var vwDelete: UIView!
    @IBOutlet weak var vwDataCollection: UIView!
    @IBOutlet weak var vwInfo: UIView!
    @IBOutlet weak var vwPayReview: UIView!
    
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgStar: UIImageView!
    
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var lblTripCode: UILabel!
    
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var lblUserText: UILabel!
    @IBOutlet weak var vwPay: UIView!
    @IBOutlet weak var btnPayReview: UIButton!
    
    @IBOutlet weak var vwSubProfile: UIView!
    @IBOutlet weak var imgSubProfile: UIImageView!
    @IBOutlet weak var vwDotted: UIView!
    
    @IBOutlet weak var vwCall: UIView!
    @IBOutlet weak var vwChat: UIView!
    @IBOutlet weak var imgChat: UIImageView!
    @IBOutlet weak var imgCall: UIImageView!
    
    
    @IBOutlet weak var vwBlurRating: UIView!
    @IBOutlet weak var vwBlurBottom: UIView!
    @IBOutlet weak var vwRating: UIView!
    @IBOutlet weak var vwRatingProfile: UIView!
    @IBOutlet weak var imgRatingProfile: UIImageView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var txtRating: UITextView!
    @IBOutlet weak var vwSubmit: UIView!
    @IBOutlet weak var vwImgSubmit: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
  
      @IBOutlet weak var txtSource: UILabel!
      @IBOutlet weak var txtDestination: UILabel!

    // localisation outlets -
    
    @IBOutlet weak var lblLOnext: UILabel!
    @IBOutlet weak var lblLOTripCode: UILabel!
    @IBOutlet weak var lblLOCar: UILabel!
    @IBOutlet weak var lblLOYear: UILabel!
    @IBOutlet weak var lblLOStatus: UILabel!
    @IBOutlet weak var lblLOAllDriverBusy: UILabel!
    @IBOutlet weak var lblLoAwsome: UILabel!

    
    // deepu new
    @IBOutlet weak var vwCancelRide: UIView!
    @IBOutlet weak var btnCancelRide: UIButton!
    // deepu new
    
    //MARK: - Variables
    
    var strSourceLat = ""
    var strSourceLong = ""
    var strDestinationLat = ""
    var strDestinationLong = ""
    var strlong : String = ""
    var strlat : String = ""
    var StrCurrentSource : String = ""
    var strSourceAddress = ""
    var strDestinationAddress = ""
    var locationManager = CLLocationManager()
    var arrVehicleList:[VehicleListModel] = []
    var arrDriverList:[DriverListModel] = []
    var strBookingId = ""
    var strPaymentMethod = ""
    var strCardId = ""
    var BookingModelDict = BookingModel(dict: [:])

    var strOriginLatitude = ""
    var strOriginLongitude = ""
    var strDestinationLatitude = ""
    var strDestinationLongitude = ""
    var strCurrentLongitude : CLLocationDegrees!
    var strCurrentLatitude : CLLocationDegrees!
    var timer = Timer()
    
    var strPathSourceLat = ""
    var strPathSourceLong = ""
    var strPathDestinationLat = ""
    var strPathDestinationLong = ""
    var strStatus = ""
    var strPaymentStatus = "0"
    var strSelection = ""
    var userName = ""
    
    var DriverRating = ""
    var strUserId = ""
    var strprofile = ""
    
    var strRating = ""
    var strReview = ""
    var isNoData = false
    var isFromPlacePicker = false
    var isFromDestPlacePicker = false
    var isFromForgroundNotification = false
    
    var strDialCode = ""
    var strPhoneNumber = ""
    
    var strReferenceID = ""
       var strDriverId = ""
    var strCurrentStatus = ""
    
    var strDriverLatitude = ""
    var strDriverLongitude = ""
    let marker = GMSMarker.init()
    let phoneNumberKit = PhoneNumberKit()

    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if objAppShareData.isFromBannerNotification == true {
                if  objAppShareData.strBannerNotificationType == "chat"{
             let sb = UIStoryboard(name: "Chat", bundle: nil)
             let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
            self.navigationController?.pushViewController(detailVC, animated: false)
            }
     }
  
        self.txtSource.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
        self.txtDestination.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
        self.txtSource.text = "Enter_Source".localize
        self.txtDestination.text = "Enter_Destination".localize
        
        
        let isEnable = self.checkForLocation()
        if !isEnable{
            self.showAlertForLocation()
        }else{
            self.getLocation()
        }
        

        
        self.vwBlur.isHidden = true
        self.vwData.isHidden = true
        self.vwDelete.isHidden = true
        self.vwBlurRating.isHidden = true
        self.vwInfo.isHidden = true
        self.vwPayReview.isHidden = true
        self.lblStar.isHidden = true
        self.imgStar.isHidden = true
        self.vwCancelRide.isHidden = true
        self.mapSetUp()
        self.vwCollectionVehicle.delegate = self
        self.vwCollectionVehicle.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localisation()
        print("viewWillAppear is called")
        self.setUI()
        objAppShareData.isOnMapScreen = true
   
        ////
        if self.isFromPlacePicker == true  || self.isFromDestPlacePicker == true{
            //source
            self.isFromPlacePicker = false
            self.isFromDestPlacePicker = false
        }else{
            if  objAppShareData.isFromPayment == true{
                objAppShareData.isFromPayment = false

            }else{
                self.callWsForGetCurrentRide()
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshUI"), object: nil, queue: nil) { [weak self](Notification) in
            self?.isFromForgroundNotification = true
            print("if part refresh")
           // print("self?.strCurrentStatus is \(self?.strCurrentStatus)")
            print("objAppShareData.strBannerCurrentStatus is \(objAppShareData.strBannerCurrentStatus)")
           // if self?.strCurrentStatus != "5" {
            if  objAppShareData.strBannerCurrentStatus != "6" {
                self?.callWsForGetCurrentRide()
                
            }else{
                print("else part refresh")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear is called")
            
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            objAppShareData.isOnMapScreen = false
          NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false

        }

    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear is called")
        super.viewDidDisappear(animated)
        self.timer.invalidate()
    }
    
    @objc func refrershUI(){
        if self.strBookingId != "" {
        self.isFromForgroundNotification = true
        self.callWsForGetCurrentRide()
        }
        else if self.strBookingId == "" {
            self.resetAllData()
            self.txtDestination.text = "Enter_Destination".localize
            self.txtDestination.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
            self.CheckInput()
            self.vwInput.isUserInteractionEnabled = true
        }
        
// new
//         else if self.StrCurrentSource != self.txtSource.text {
//         if self.arrVehicleList.isEmpty == true{
//         self.txtSource.text = self.StrCurrentSource //self.strSourceAddress
//         self.txtDestination.text = ""
//         self.txtDestination.text = "Enter_Destination".localize
//         self.txtDestination.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
//         self.CheckInput()
//         }
//         }
        
        // new


    }
    
    func localisation(){
 
        self.lblLOnext.text = "Next".localize
        self.lblLOTripCode.text = "Trip_Code :".localize
        self.lblLOCar.text = "Car".localize
        self.lblLOYear.text = "Vehicle number".localize
        self.lblLOStatus.text = "Status".localize
        self.lblLoAwsome.text = "AWESOME!".localize
        
        self.btnSubmit.setTitle("Submit".localize, for: .normal)
        self.btnOK.setTitle("OK".localize, for: .normal)
        self.btnPayReview.setTitle("Pay".localize, for: .normal)
        
        self.btnCancelRide.setTitle("Cancel Ride".localize, for: .normal)
    }
    
    func setCurrentLocation(){

        let lat = Double(self.strlat)
        let long = Double(self.strlong)
 
        let camera = GMSCameraPosition.camera(withLatitude: lat ?? 22.75 , longitude: long ?? 75.90 , zoom: 14);
        self.mapView.camera = camera
        
    }
    func mapSetUp(){
        self.mapView.isMyLocationEnabled = true
        self.mapView.settings.myLocationButton = false
        self.mapView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }
    
    func setUI(){
   
        self.CheckInput()
        
        
        if self.arrVehicleList.count > 4{
            self.vwCollectionVehicle.isScrollEnabled = true
        }else{
            self.vwCollectionVehicle.isScrollEnabled = true
            
        }
        self.vwInput.setCornerRadius(radius: 12)
        self.vwInfo.setCornerRadius(radius: 12)
        self.txtRating.setCornerRadius(radius: 12)
        self.vwPayReview.setCornerRadius(radius: 12)
        // self.vwPay.setCornerRadius(radius: 4)
        
        self.payButtonUI(vwOuter: vwPay, btn: self.btnPayReview)
        
        self.vwDotted.creatDashedLine(view: vwDotted)
        self.vwBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.vwLeft.roundCorners(corners: [.topLeft, .bottomLeft], radius: 12.0)
        self.vwRight.roundCorners(corners: [.topRight, .bottomRight], radius: 12.0)
        self.vwBlurBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.vwOk.setButtonVerifyView(vwOuter: vwOk, btn: self.btnOK,viewRadius:20, btnRadius:Int(17.5))
        self.vwNext.setButtonView(vwOuter : self.vwNext , vwImage : self.vwImgNext, btn: self.btnNext )
        self.vwSubmit.setButtonView(vwOuter : self.vwSubmit , vwImage : self.vwImgSubmit, btn: self.btnSubmit )
  
        self.vwCall.setShadowWithCornerRadius()
            self.vwChat.setShadowWithCornerRadius()
        
        self.vwProfile.setUserProfileView(vwOuter: self.vwProfile, img: self.imgProfile , radius : 4)
        self.vwSubProfile.setUserProfileView(vwOuter: self.vwSubProfile, img: self.imgSubProfile ,radius : 4)
        self.btnCancelRide.setCornerRadius(cornerRadious: 8)
        
    }
    
    func payButtonUI(vwOuter : UIView  ,btn :UIButton){
        vwOuter.layer.cornerRadius = 16
        vwOuter.layer.masksToBounds = true;
        vwOuter.layer.shadowColor = UIColor.lightGray.cgColor
        vwOuter.layer.shadowOpacity = 0.8
        vwOuter.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        vwOuter.layer.shadowRadius = 6.0
        vwOuter.layer.masksToBounds = false
        btn.layer.cornerRadius = 12
        
    }
    
    
    
    //MARK: - Button Action
    
    @IBAction func btnProfileAction(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func btnPayAction(_ sender: Any) {
        self.view.endEditing(true)
   
        print("self.strPaymentStatus  is \(self.strPaymentStatus)")
        if self.strPaymentMethod != "1" {
            if self.strPaymentStatus == "0" {
                self.callWsForPay()
            }else{
                self.navigateToRating()
            }
        }else{
            self.navigateToRating()
        }
    }
    
    
    func navigateToRating (){
        let sb = UIStoryboard(name: "Map", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
        detailVC.strBookingId = self.strBookingId
        detailVC.strUserId = self.strUserId
        detailVC.strProfile = self.strprofile
        detailVC.strName = self.userName
        detailVC.isFromMap = true
        detailVC.modalPresentationStyle = .overCurrentContext
        self.tabBarController?.tabBar.isHidden = true
        //
        detailVC.closerDeleteAlertList = {
            isClearListData in
            if isClearListData{
                self.callWsForGetCurrentRide()
                self.tabBarController?.tabBar.isHidden = false

                if self.strBookingId == ""{
                    self.resetAllData()
                    self.txtDestination.text = "Enter_Destination".localize
                    self.txtDestination.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
                    self.CheckInput()
                    self.mapView.clear()
                    self.vwInput.isUserInteractionEnabled = true
                }
            }
        }
        
        self.present(detailVC, animated: false, completion: nil)
    }
    
    
    @IBAction func btnChatAction(_ sender: Any) {
        self.view.endEditing(true)
      ///  self.vwScroll.isUserInteractionEnabled = true
     ///   self.vwSubScroll.isUserInteractionEnabled = true
        
        let sb = UIStoryboard(name: "Chat", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
//        detailVC.strCustomerId = objAppShareData.
//            detailVC.strDriverId = ""
//            detailVC.strDriverType = ""
//            detailVC.strReferenceID = ""
        
                detailVC.strCustomerId = objAppShareData.UserDetail.strUserID
                   detailVC.strDriverId = self.strDriverId
                   detailVC.strOpponentId = self.strDriverId
                   detailVC.strDriverType = "2"
                   detailVC.strReferenceID = self.strReferenceID
                   detailVC.strOrderRideId = self.strBookingId
                   detailVC.isFromDriverSide = false
                    detailVC.strReferenceType = "1"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    @IBAction func btnCallAction(_ sender: Any) {
        self.view.endEditing(true)
     ///   self.vwScroll.isUserInteractionEnabled = true
    ///    self.vwSubScroll.isUserInteractionEnabled = true
        
//        let number = self.strDialCode + "-" + self.strPhoneNumber
//        print("number is \(number)")
//
//        if let url = URL(string: "tel://\(number)"),
//            UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//        }
        
        
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
    
    @IBAction func btnSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.toggleLeft()
    }
    @IBAction func btnPlacePicker(_ sender: UIButton) {
        self.view.endEditing(true)
        
        
        
        if sender.tag == 0{
            
            self.openPlacePickerForSource()
            
            print("source txt field button \(sender.tag)")
        }else{
            print("Destination txt field button \(sender.tag)")
            self.openPlacePickerForDestination()
        }
        
    }
    
    
    func getLocation(){
        
        PlacePicker.shared.getUsersCurrentLocation(success: { (CLLocationCoordinate2D) in
            print(CLLocationCoordinate2D)
            
            print("location dict")
            let lat = CLLocationCoordinate2D.latitude
            let long = CLLocationCoordinate2D.longitude
            print(lat)
            print(long)
            let Cordinate = type(of: CLLocationCoordinate2D).init(latitude: lat, longitude: long)
            
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                
                ////////////////////
                //                    self.address  = addressModel.address ?? ""
                //                    self.strCity = addressModel.city ?? ""
                //                    self.strState = addressModel.state ?? ""
                //                    self.strCountry = addressModel.country ?? ""
                //                    self.strlong = addressModel.lng ?? ""
                //                    self.strlat = addressModel.lat ?? ""
                //
                //                    print(self.address)
                //
                //
                //                    self.strfromLatitude = self.strlat
                //                    print(self.strfromLatitude)
                //                    self.strfromLongitude = self.strlong
                //                    print(self.strfromLongitude)
                //
                //
                //                    self.txtFromLocation.text = self.address
                //////////
                
                self.strSourceAddress = addressModel.address ?? ""
                self.txtSource.text = addressModel.address ?? ""
                self.txtSource.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                
                
                self.StrCurrentSource = addressModel.address ?? ""
                
                
                self.strSourceLat = addressModel.lat ?? ""
                self.strSourceLong = addressModel.lng ?? ""
                
                
                self.strlat = addressModel.lat ?? ""
                self.strlong =  addressModel.lng ?? ""
                
                
                print("self.strSourceAddress is \(self.strSourceAddress)")
              //  print("self.txtSource.text is \(self.txtSource.text)")
                print("self.strSourceLat is \(self.strSourceLat)")
                print("self.strSourceLong is \(self.strSourceLong)")
                print("self.strlat is \(self.strlat)")
                print("self.strlong is \(self.strlong)")
                self.setCurrentLocation()
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
        
        objAlert.showAlertCallOneBtnAction(btnHandler: "Settings".localize, title: "Need_Authorization".localize, message: "This app is unusable if you don't authorize this app to use your location!".localize, controller: self) {
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:]
                
                , completionHandler: nil)
            
        }
        
    }
    func openPlacePickerForSource(){
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            self.txtSource.text = placeDict["formattedAddress"] as? String ?? ""
            self.txtSource.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
            self.strSourceAddress = placeDict["placeName"] as? String ?? ""
            
            self.isFromPlacePicker = true
            
            //self.txtCity.resizeForHeight()
            self.strSourceLat = placeDict["lat"] as? String ?? ""
            print(self.strSourceLat)
            self.strSourceLong = placeDict["long"]
                as? String ?? ""
            print(self.strSourceLong)
            //            self.location = placeDict["formattedAddress"] as? String ?? ""
            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                //  self.txtSource.text = addressModel.address
                
                self.CheckInput()
            }) { (error) in
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
    
    
    func openPlacePickerForDestination(){
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            self.txtDestination.text = placeDict["formattedAddress"] as? String ?? ""
            self.txtDestination.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
            self.strDestinationAddress = placeDict["placeName"] as? String ?? ""
            self.isFromDestPlacePicker = true
            //self.txtCity.resizeForHeight()
            self.strDestinationLat = placeDict["lat"] as? String ?? ""
            print(self.strDestinationLat)
            self.strDestinationLong = placeDict["long"]
                as? String ?? ""
            print(self.strDestinationLong)
            //            self.location = placeDict["formattedAddress"] as? String ?? ""
            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                self.CheckInput()
            }) { (error) in
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
   
    
    func CheckInput(){
        if self.txtSource.text == "Enter_Source".localize {
            self.vwContinue.isHidden = true
        }else if  self.txtDestination.text  ==  "Enter_Destination".localize {
            self.vwContinue.isHidden = true
        }else{
            self.vwContinue.isHidden = false
        }
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        self.view.endEditing(true)
        self.callWsForGetDriverList()
        //        self.isFromPlacePicker = false
        //        self.isFromDestPlacePicker = false
    }
    
    @IBAction func btnOkAction(_ sender: Any) {
        self.view.endEditing(true)
        self.vwBlur.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.txtDestination.text = "Enter_Destination".localize
        self.txtDestination.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
        self.CheckInput()
        self.resetAllData()
        self.vwInput.isUserInteractionEnabled = true
        
    }
    @IBAction func btnNextAction(_ sender: Any) {
        self.view.endEditing(true)
       /// self.vwScroll.isUserInteractionEnabled = true
      ///  self.vwSubScroll.isUserInteractionEnabled = true
        self.isFromPlacePicker = false
        self.isFromDestPlacePicker = false
        objAppShareData.isFromCartList = false
        let sb = UIStoryboard(name: "Map", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    @IBAction func btnCancleAction(_ sender: Any) {
        self.view.endEditing(true)
      ///  self.vwScroll.isUserInteractionEnabled = true
      ///  self.vwSubScroll.isUserInteractionEnabled = true
        self.deleteData()
    }
    
    func resetAllData(){
        self.vwCancelRide.isHidden = true
        self.arrVehicleList.removeAll()
        self.vwData.isHidden = true
        self.vwDataCollection.isHidden = true
        self.vwDelete.isHidden = true
        self.vwInfo.isHidden = true
        self.vwPayReview.isHidden = true
        self.txtSource.text = self.StrCurrentSource
        self.txtSource.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
        self.strSourceAddress = self.StrCurrentSource
        self.strSourceLat = self.strlat
        self.strSourceLong = self.strlong
        self.mapView.clear()
        self.strBookingId = ""
        self.strPaymentStatus = "0"
        self.btnPayReview.setTitle(" \("Pay".localize) ", for: .normal)
       /// self.vwScroll.isUserInteractionEnabled = false
      ///  self.vwSubScroll.isUserInteractionEnabled = false
        self.setCurrentLocation()
        self.txtDestination.text = "Enter_Destination".localize
        self.txtDestination.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
        self.CheckInput()
        
    }
    
    func deleteData(){
        let alert = UIAlertController(title: kAlert.localize, message: "Are you sure you want to cancel your ride booking process?".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            
            self.resetAllData()
            self.txtDestination.text = "Enter_Destination".localize
            self.txtDestination.textColor = #colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7607843137, alpha: 1)
            self.CheckInput()
            self.vwInput.isUserInteractionEnabled = true
        }))
        self.present(alert, animated: true, completion: nil)
    }
    // deepu new
    @IBAction func btnCancleRideAction(_ sender: Any) {
    self.view.endEditing(true)
    self.cancleRide()
    }

    func cancleRide(){
    let alert = UIAlertController(title: kAlert.localize, message: "Are_you_sure_you_want_to_cancel_your_ride?".localize, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
    alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
    self.callWsCancelRide()
    }))
    self.present(alert, animated: true, completion: nil)
    }
    // deepu new
    
}


//extension MapVC {



//    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
//    {
//        print("Error" + error.description)
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let userLocation = locations.last
//
//        //        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude, zoom: 12);
//        //        self.mapView.camera = camera
//        self.mapView.isMyLocationEnabled = true
//
//
//        if CLLocationManager.locationServicesEnabled()
//        {
//            switch(CLLocationManager.authorizationStatus())
//            {
//            case .authorizedAlways, .authorizedWhenInUse:
//                print("Authorize.")
//                let latitude: CLLocationDegrees = (locationManager.location?.coordinate.latitude)!
//                let longitude: CLLocationDegrees = (locationManager.location?.coordinate.longitude)!
//                let location = CLLocation(latitude: latitude, longitude: longitude) //changed!!!
//                CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//                    if error != nil {
//                        return
//                    }else if let country = placemarks?.first?.country,
//                        let city = placemarks?.first?.subLocality {
//                        print(country)
//                        print("placemarks is \(placemarks)")
//                        print("lat is \(String(latitude))")
//                        print("long is \(String(longitude))")
//
//
//                        self.StrCurrentSource = city
//                        self.txtSource.text = city
//                        print("self.city is \(self.StrCurrentSource)")
//                        self.strlat = String(latitude)
//                        self.strlong = String(longitude)
//
//
//                        self.strSourceAddress = city
//                        self.strSourceLat = String(latitude)
//                        self.strSourceLong = String(longitude)
//
//
//                        self.callWsForUpdateLocation(lat : self.strSourceLat , long : self.strSourceLong , address : self.strSourceAddress )
//
//
//                    }
//                    else {
//                    }
//                })
//                break
//
//            case .notDetermined:
//                print("Not determined.")
//                objAlert.showAlert(message: "Location service is disabled!!", title: kAlertTitle, controller: self)
//                break
//
//            case .restricted:
//                print("Restricted.")
//                objAlert.showAlert(message: "Location service is disabled!!", title: kAlertTitle, controller: self)
//                break
//
//            case .denied:
//                print("Denied.")
//            }
//        }
//
//    }
//
//}



//MARK: - Extension Collection View

extension MapVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrVehicleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vwCollectionVehicle.dequeueReusableCell(withReuseIdentifier: "VehicleListCell", for: indexPath) as! VehicleListCell
        let obj = self.arrVehicleList[indexPath.row]
      
        cell.lblModel.text = obj.strVehicleModel
 
        
        let profilePic = obj.strVehicleImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgVehicle.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "car_placeholder_img"))
        }
    
        
        if self.strSelection == obj.strvehicleMetaID{
            cell.selectedHighletedView()
        }else{
            cell.selectedGrayView()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        
        let cell = vwCollectionVehicle.dequeueReusableCell(withReuseIdentifier: "VehicleListCell", for: indexPath) as! VehicleListCell
        let obj = self.arrVehicleList[indexPath.row]
        
        
        cell.selectedHighletedView()
        if indexPath.row == 0{
            cell.selectedGrayView()
            
        }
        
        ///////
        
        self.lblDistance.text = obj.strTotalDistance + " \("km".localize)"
        self.lblPrice.text = "$" + obj.strTotalPrice
        self.lblVehicle.text = obj.strVehicleModel
        self.strSelection = obj.strvehicleMetaID
        strvehicleMetaID = obj.strvehicleMetaID
        
        let profilePic = obj.strVehicleImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            self.imgVehicle.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "car_placeholder_img"))
        }
        ///////
        cell.viewSelected.backgroundColor = UIColor.red
        print("strvehicleMetaID on selection \(strvehicleMetaID)")
        self.vwCollectionVehicle.reloadData()
    }
}

extension MapVC {
    // TODO: Webservice For get DriverList
    
    func callWsForGetDriverList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
 
        param = [
            WsParam.source: self.strSourceAddress,
            WsParam.destination: self.strDestinationAddress,
            WsParam.sourceLat: self.strSourceLat,
            WsParam.sourceLong: self.strSourceLong,
            WsParam.destinationLat: self.strDestinationLat ,
            WsParam.destinationLong: self.strDestinationLong
            ] as [String : Any]
        
        AppShareData.sharedObject().dictRideLoction = param
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.getDriverList, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                

                
                if message == "No record found".localize  ||  message ==  "Sorry! We do not provide service for distance 500 meter or less." || message == "All drivers are looking busy at a moment, Try a bit later."{
                    self.CheckInput()
                    self.vwBlur.isHidden = false
                    self.tabBarController?.tabBar.isHidden = true
                    self.vwInput.isUserInteractionEnabled = true
                    
                    self.lblLOAllDriverBusy.text = message

                    
                }else{
                    self.vwBlur.isHidden = true
                    self.tabBarController?.tabBar.isHidden = false
                    self.vwInput.isUserInteractionEnabled = false
                    self.vwContinue.isHidden = true
              //  }
                
                let dic  = response["data"] as? [String:Any]
                
                
                if let arrDriverData = dic?["driver_list"] as? [[String:Any]]{
                    self.arrDriverList.removeAll()
                    for dictDriverData in arrDriverData{
                        let objDriverData = DriverListModel.init(dict: dictDriverData)
                        self.arrDriverList.append(objDriverData)
                    }
                    
                    print("self.arrDriverList count is \(self.arrDriverList.count)")
                    
                    self.dropPins()
                    
                }
                
                if let arrVehicleData = dic?["vehicle_list"] as? [[String:Any]]{
                    self.arrVehicleList.removeAll()
                    for dictVehicleData in arrVehicleData{
                        let objVehicleData = VehicleListModel.init(dict: dictVehicleData)
                        self.arrVehicleList.append(objVehicleData)
                    }
                    self.lblDistance.text = self.arrVehicleList[0].strTotalDistance + " \("km".localize)"
                    self.lblPrice.text = "$" + self.arrVehicleList[0].strTotalPrice
                    self.lblVehicle.text = self.arrVehicleList[0].strVehicleModel
                    self.strSelection = self.arrVehicleList[0].strvehicleMetaID
                    strvehicleMetaID = self.arrVehicleList[0].strvehicleMetaID
                    // self.strvehicleMetaID = self.arrVehicleList[0].strvehicleMetaID
                    
                    //  cell.selectedView()
     
                    let profilePic = self.arrVehicleList[0].strVehicleImage
                    if profilePic != "" {
                        let url = URL(string: profilePic)
                        self.imgVehicle.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "car_placeholder_img"))
                    }
         
                    self.vwData.isHidden = false
                    self.vwDataCollection.isHidden = false
                    self.vwDelete.isHidden = false
                    ///  self.vwScroll.isUserInteractionEnabled = true
                    /// self.vwSubScroll.isUserInteractionEnabled = true
                    print("self.arrVehicleList count is \(self.arrVehicleList.count)")
                }
                self.vwCollectionVehicle.reloadData()
                
            }//
                
                
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title:kAlert.localize, controller: self)
                self.CheckInput()
            }
            
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            self.CheckInput()
            
        })
    }
    
    // TODO: Webservice For Pay
    
    func callWsForPay(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
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
                
                let dict  = response["data"] as? [String:Any]
                
                if let rideDetailData = dict?["rideDetails"] as? [String:Any]{
                    self.vwDataCollection.isHidden = true
                    self.vwInfo.isHidden = false
                    
                    if let paymentStatus = rideDetailData["payment_status"]as? String{
                        if paymentStatus == "0" {
                            self.strPaymentStatus = "0"
                            self.btnPayReview.setTitle(" \("Pay".localize) ", for: .normal)
                            
                            self.lblUserText.text = "\(self.userName) \("has_safely_dropped_you_on_destination,please pay him.".localize)"
                            
                        }else{
                            self.strPaymentStatus = "1"
                            self.btnPayReview.setTitle(" \("Review".localize) ", for: .normal)
                            
                            self.lblUserText.text = "\(self.userName) \("has_safely_dropped_you_on_destination,_please_rate_him.".localize)"
                            
                        }
                    }
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
            WsParam.userType: "1"
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: WsUrl.myCurrentRide  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                if message == "No record found".localize || message == "No record found"{
                    // self.isNoData = true
                    self.resetAllData()
                    self.vwInput.isUserInteractionEnabled = true
                    if objAppShareData.isFromBannerNotification == true {
                        
                        if  objAppShareData.strBannerReferenceType == "1" {
                            let sb = UIStoryboard(name: "PastTrip", bundle: nil)
                            let detailVC = sb.instantiateViewController(withIdentifier: "PastTripVC") as! PastTripVC
                            detailVC.isFromCustomer = true
                            self.navigationController?.pushViewController(detailVC, animated: false)
                            
                        }else{
                            
                            let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
                            let detailVC = sb.instantiateViewController(withIdentifier: "CustomerPastOrder") as! CustomerPastOrder
                            self.navigationController?.pushViewController(detailVC, animated: false)
                            
                        }
                        
                    }
                    self.timer.invalidate()
                }else{
                    self.timer.invalidate()
                    //self.CheckInput()
                    self.vwContinue.isHidden = true
                    if objAppShareData.isFromBannerNotification == true {
                        objAppShareData.resetBannarData()
                    }
                    self.vwInput.isUserInteractionEnabled = false
                  ///  self.vwScroll.isUserInteractionEnabled = true
                  ///  self.vwSubScroll.isUserInteractionEnabled = true
                    
                    //                     self.isNoData = false
                    if let rideDetailData = dict?["rideDetails"] as? [String:Any]{
                        self.vwDataCollection.isHidden = true
                        self.vwInfo.isHidden = false
                        
                        if let id = rideDetailData["bookingID"]as? String{
                            self.strBookingId  = id
                        }
                        
                        if let source = rideDetailData["source"]as? String{
                            self.txtSource.text = source
                            self.txtSource.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                        }
                        
                        if let destination = rideDetailData["destination"]as? String{
                            self.txtDestination.text = destination
                            self.txtDestination.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                        }
                        
                        if let time = rideDetailData["time"]as? String{
                            self.lblTime.text = "\(time.capitalizingFirstLetter()) \("Away".localize)"
                        }
                        
                        if let tripCode = rideDetailData["trip_code"]as? String{
                            self.lblTripCode.text = tripCode
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
                        
                        if let DriverRating = rideDetailData["driver_avg_rating"]as? String{
                            self.DriverRating = DriverRating
//                            self.lblStar.text = DriverRating
                            
                        }
                        
                        
                        if let paymentStatus = rideDetailData["payment_status"]as? String{
                            self.strPaymentStatus = paymentStatus
                            // new case
                            
                            if paymentStatus == "0" {
                                self.strPaymentStatus = "0"
                                self.btnPayReview.setTitle(" \("Pay".localize) ", for: .normal)
                            }else{
                                self.strPaymentStatus = "1"
                                self.btnPayReview.setTitle(" \("Review".localize) ", for: .normal)
                            }
                        }
                        
                        if let paymentMethod = rideDetailData["payment_method"]as? String{
                            self.strPaymentMethod = paymentMethod
                        }
                        
                        if let rating = rideDetailData["rating"]as? String{
                            self.strRating = rating
                        }
                        if let review = rideDetailData["review"]as? String{
                            self.strReview = review
                        }
                        if let status = rideDetailData["status"]as? String{
                            self.strCurrentStatus = status
                        }else  if let status = rideDetailData["status"]as? Int{
                            self.strCurrentStatus = "\(status)"
                        }
                        // deepu new
                        if self.strCurrentStatus == "1" {
                        self.vwCancelRide.isHidden = false
                        }else{
                        self.vwCancelRide.isHidden = true
                        } // deepu new
                        
                        
                        
                        if let distance = rideDetailData["distance"]as? String{
                            self.lblDistance.text = distance + " \("km".localize)"
                        }
                        if let price = rideDetailData["price"]as? String{
                            self.lblPrice.text = "$" + price
                        }
                        
                        
                        if let driverId = rideDetailData["driver_id"]as? String {
                                   self.strDriverId =  driverId
                               }

                               if let number = rideDetailData["number"]as? String {
                                   self.strReferenceID =  number
                            }
                       /*
                        if let DriverData = self.convertToDictionary(text: rideDetailData["driver_json"] as? String ?? "") {
                    
                            //   if let DriverData = rideDetailData["driver_json"] as? [String:Any]{
                            
                            if let fullName = DriverData["full_name"]as? String{
                                print(fullName)
                                self.lblFullName.text = fullName.capitalizingFirstLetter()
                                self.userName = fullName
                                DispatchQueue.main.async {
                                    self.userName = fullName
                                }
                            }
                            
                            if let dialCode = DriverData["dial_code"]as? String{
                                self.strDialCode =  dialCode
                            }
                            
                            if let phoneNumber = DriverData["phone_number"]as? String{
                                self.strPhoneNumber =  phoneNumber
                            }
                            
                            if let userID = DriverData["userID"]as? String{
                                self.strUserId = userID
                            }
                            
                            if let avatar = DriverData["avatar"]as? String{
                                //let profilePic = avatar
                                self.strprofile = avatar
                                if self.strprofile != "" {
                                    let url = URL(string: self.strprofile)
                                    self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                                    self.imgSubProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                                }else{
                                    self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                                    self.imgSubProfile.image = UIImage.init(named: "inactive_profile_ico")
                                }
                            }
                        }
                        */
                        
                        // new deepak updated testing
                        self.userName = dictToStringKeyParam(dict: rideDetailData, key: "driver_name").capitalizingFirstLetter()
                        self.lblFullName.text = self.userName
                        self.strDialCode = dictToStringKeyParam(dict: rideDetailData, key: "driver_dial_code")
                        self.strPhoneNumber = dictToStringKeyParam(dict: rideDetailData, key: "driver_phone_number")
                        self.strUserId = dictToStringKeyParam(dict: rideDetailData, key: "driver_id")
                        self.strprofile = dictToStringKeyParam(dict: rideDetailData, key: "driver_image")

                        if self.strprofile != "" {
                        let url = URL(string: self.strprofile)
                        self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        self.imgSubProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
                        }else{
                        self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
                        self.imgSubProfile.image = UIImage.init(named: "inactive_profile_ico")
                        }

                        // new deepak updated testing
                        
                        
                        
                        if let vehicleData = self.convertToDictionary(text: rideDetailData["vehicle_info_json"] as? String ?? "") {
                            
                            if let company = vehicleData["company"]as? String{
                                self.lblVehicleType.text = company
                            }
                            
                            if let year = vehicleData["vehicle_number"]as? String{
                                self.lblYear.text = year
                                
                            }
                            if let model = vehicleData["vehicle_model"]as? String{
                                self.lblVehicle.text = model
                                
                            }
                            
                            if let avatar = vehicleData["vehicle_image"]as? String{
                                let profilePic = avatar
                                if profilePic != "" {
                                    let url = URL(string: profilePic)
                                    self.imgVehicle.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "car_placeholder_img"))
                                }
                            }
                        }
                        
                        if let statusText = rideDetailData["status_text"]as? String{
                            self.lblTime.isHidden = false
                            self.imgStar.isHidden = true
                            self.lblStar.isHidden = true
                   
                            if statusText == "pending"{
                                self.lblStatus.textColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                                self.lblStatus.text = "Pending".localize
                                
                            }else if  statusText == "on the way" {
                                self.lblStatus.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                                self.lblStatus.text = "On_the_way".localize
                                self.runTimer()
                            }else if  statusText == "picked" {
                                self.lblStatus.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                                self.lblStatus.text = "Picked".localize
                                self.runTimer()
                            }else if  statusText == "in route" {
                                self.lblStatus.textColor =  #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
                                self.lblStatus.text = "In_Route".localize
                                self.runTimer()
                            }else if  statusText == "dropped" {
                                self.timer.invalidate()
                                self.lblStatus.text = "Completed".localize
                                self.lblStatus.textColor = #colorLiteral(red: 0, green: 0.6352941176, blue: 0.2549019608, alpha: 1)
                                self.strStatus = "Pay".localize
                                self.vwPayReview.isHidden = false
                                print(self.userName)
                                self.lblUserText.text = "\(self.userName) \("has_safely_dropped_you_on_destination,_please_rate_him.".localize)"
                                self.lblTime.isHidden = true
                                self.imgStar.isHidden = false
                                self.lblStar.isHidden = false
                              ///  self.vwScroll.isUserInteractionEnabled = true
                             ///   self.vwSubScroll.isUserInteractionEnabled = true
            
                                let string = NSString(string: self.DriverRating)
                                self.lblStar.text = String(string.doubleValue)
                                
                                if self.strPaymentMethod == "1" && self.strPaymentStatus == "0"{
                                    
                                    self.lblUserText.text = "\(self.userName) \("has_safely_dropped_you_on_destination,_please_rate_him.".localize)"
                                    self.btnPayReview.setTitle(" \("Review".localize) ", for: .normal)
                                }
                                
                                
                                if self.strPaymentMethod == "2" && self.strPaymentStatus == "0"{
                                    
                                    self.lblUserText.text = "\(self.userName) \("has_safely_dropped_you_on_destination,please pay him.".localize)"
                                    self.btnPayReview.setTitle(" \("Pay".localize) ", for: .normal)
                                }else if self.strPaymentMethod == "2" && self.strPaymentStatus == "1"{
                                    self.lblUserText.text = "\(self.userName) \("has_safely_dropped_you_on_destination,_please_rate_him.".localize)"
                                    self.btnPayReview.setTitle(" \("Review".localize) ", for: .normal)
                                    
                                }
     
                                
                                if self.strRating == "" || self.strReview == ""{
                                    self.vwPayReview.isHidden = false
                                }else{
                                    self.vwPayReview.isHidden = true
                                }
                            }
                        }
                        ////////////////////
                        self.vwData.isHidden = false
                        self.drawPath()
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
    
    // deepu new
    // TODO: Webservice For Cancle ride from customer

    func callWsCancelRide(){

    if !objWebServiceManager.isNetworkAvailable(){
    /// objWebServiceManager.StopIndicator()
    objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
    return
    }
    // objWebServiceManager.StartIndicator()
    // var param = [String:Any]()

    var strWsUrl = ""
    let bookingId = strBookingId
    strWsUrl = WsUrl.cancelRide + bookingId
    print("strWsUrl for cancelRide is ", strWsUrl)

    objWebServiceManager.requestPatch(strURL: strWsUrl, params: [:] as [String : AnyObject] , strCustomValidation: "", success: {response in
    print(response)
    /// objWebServiceManager.StopIndicator()
    let status = (response["status"] as? String)
    let message = (response["message"] as? String)

    if status == "success"{
    self.callWsForGetCurrentRide()

    }else{
    objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
    }
    }, failure: { (error) in
    print(error)
    objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
    })
    }
    
    
    
    
    
    // TODO: Webservice For Book Ride
    
    func callWsForBookRide(){
        if !objWebServiceManager.isNetworkAvailable(){
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
   
        var cardId = ""
        var paymentMethod = ""
        var source = ""
        var destination = ""
        var sourceLat = ""
        var sourceLong = ""
        var destinationLat = ""
        var destinationLong = ""
   
        
        if let source1 = objAppShareData.dictRideLoction["source"]as? String{
            source = source1
        }
        if let destina = objAppShareData.dictRideLoction["destination"]as? String{
            destination = destina
        }
        if let sourcelat = objAppShareData.dictRideLoction["source_lat"]as? String{
            sourceLat = sourcelat
        }
        if let sourcelong = objAppShareData.dictRideLoction["source_long"]as? String{
            sourceLong = sourcelong
        }
        if let destinationlat = objAppShareData.dictRideLoction["destination_lat"]as? String{
            destinationLat = destinationlat
        }
        if let destinationlong = objAppShareData.dictRideLoction["destination_long"]as? String{
            destinationLong = destinationlong
        }
        
        if objAppShareData.strPaymentMethod == "1" {
            paymentMethod = "1"
            cardId = ""
            
        }else if  objAppShareData.strPaymentMethod == "2" {
            paymentMethod = "2"
            cardId = objAppShareData.strCardId
            
        }
        
        var param: [String: Any] = [:]
        param = [
            WsParam.source: source ,
            WsParam.destination: destination,
            WsParam.sourceLat: sourceLat,
            WsParam.sourceLong: sourceLong,
            WsParam.destinationLat: destinationLat ,
            WsParam.destinationLong: destinationLong ,
            WsParam.vehicleMetaId: strvehicleMetaID,
            WsParam.paymentMethod: paymentMethod ,
            WsParam.cardId: cardId
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.bookingRide, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            //   objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                print(" sucess in pay ride api ")
                self.callWsForGetCurrentRide()
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title:kAlert.localize, controller: self)
                // self.CheckInput()
            }
            
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            //  self.CheckInput()
            
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
    
    // TODO: Drop markers
    func dropPins(){
        
        for state in self.arrDriverList {
            //the coordinates obtained are string we convert into Double
            let lat = Double(state.strLatitude)
            let long = Double(state.strLongitude)
            // print("lat1 is \(lat)")
            //print("long1 is \(long)")
            
            let state_marker = GMSMarker()
            state_marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            
            let aa = state_marker
            print(aa)
            // state_marker.title = state.place
            // state_marker.snippet = "Hey, this is \(state.place!)"
            
            state_marker.icon = UIImage(named: "pin_ico")
            
            
            state_marker.map = self.mapView
   
        }
    }
}


extension MapVC {

    func changeDateformat(strDate:String)-> String{
        let dateformatter = DateFormatter()
        dateformatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateformatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date1 = dateformatter.date(from: strDate)
        let strDate = date1?.strrigWithFormat(format: "d MMM yyyy") ?? ""
        return strDate
    }
    
    func drawPath(){
        self.mapView.clear()
                
                let StrPicklat = (self.strPathSourceLat as NSString).doubleValue
                let StrPickLong = (self.strPathSourceLong as NSString).doubleValue
  
        let StrDellat = (self.strPathDestinationLat as NSString).doubleValue
        let strDellong = (self.strPathDestinationLong as NSString).doubleValue
        
        
        print("StrPicklat is \(StrPicklat)")
        print("StrPickLong is \(StrPickLong)")
        print("StrDellat is \(StrDellat)")
        print("strDellong is \(strDellong)")
    
        _ = CLLocation(latitude: StrPicklat, longitude: StrPickLong)
        
        _ = CLLocation(latitude: StrDellat, longitude: strDellong)
        
        let source = self.strPathSourceLat + "," + self.strPathSourceLong
        let destination = self.strPathDestinationLat + "," + self.strPathDestinationLong
        
        let camera = GMSCameraPosition.camera(withLatitude: StrPicklat, longitude: StrPickLong, zoom: 14)
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
//        let position_1 = CLLocationCoordinate2D(latitude: UserLat, longitude: UserLong)
      ///  let marker_1 = GMSMarker(position: position_1)
        
//        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(source)&destination=\(destination)&mode=driving&key=AIzaSyBNzeXhR3Hv6U1TgPB1-x27Ic_tiazlTGc"
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
                
                DispatchQueue.main.async
                {
                 if self.mapView != nil
                 {
                  let bounds = GMSCoordinateBounds(path: path!)
                  self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 120))
                 }
                }
                polyline.map = self.mapView
                polyline.strokeWidth = 5
                polyline.strokeColor = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2235294118, alpha: 1)
  
            }
        }
        marker.map = self.mapView
        marker1.map = self.mapView
        
        self.vwDelete.isHidden = true
        self.vwContinue.isHidden = true
        
          
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

extension MapVC {
    
    func runTimer() {
        self.callWsForGetDriverLatLong()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self,   selector: (#selector(MapVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
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
                        self.marker.icon = #imageLiteral(resourceName: "car_left_ico")
                        self.marker.map = self.mapView

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
