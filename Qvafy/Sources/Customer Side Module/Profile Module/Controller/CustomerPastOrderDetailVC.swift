//
//  CustomerPastOrderDetailVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 28/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//CustomerPastOrderDetailVC
//PastOrderRatingVC
import UIKit
import SDWebImage
import GoogleMaps
import CoreLocation
import Alamofire
import SwiftyJSON
import HCSStarRatingView

class CustomerPastOrderDetailVC: UIViewController , UIGestureRecognizerDelegate , GMSMapViewDelegate , CLLocationManagerDelegate{
    // GMSMapViewDelegate
    //MARK: - Outlets
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    @IBOutlet weak var vwDotted3: UIView!
    @IBOutlet weak var vwDotted4: UIView!
    @IBOutlet weak var vwDotted5: UIView!
    
    @IBOutlet weak var vwRound: UIView!
    
    @IBOutlet weak var vwCustomerProfile: UIView!
    @IBOutlet weak var imgCustomerProfile: UIImageView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblCustomerRating: UILabel!
    @IBOutlet weak var imgCustomerRating: UIImageView!

    
    @IBOutlet weak var vwRestaurantProfile: UIView!
    @IBOutlet weak var imgRestaurantProfile: UIImageView!
    @IBOutlet weak var lblRestaurantName: UILabel!
    @IBOutlet weak var lblRestaurantRating: UILabel!
    
    @IBOutlet weak var tblItems: UITableView!
    @IBOutlet weak var tblHeightConstraint: NSLayoutConstraint!
   
    @IBOutlet weak var lblTotalItemPrice: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblPay: UILabel!
    @IBOutlet weak var lblOfferTitle: UILabel!
    @IBOutlet weak var lblRestaurantChargeTitle: UILabel!
    
    @IBOutlet weak var lblRestaurantCharge: UILabel!
    
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    

    @IBOutlet weak var btnGiveReview: UIButton!
    @IBOutlet weak var vwGiveReview: UIView!
    @IBOutlet weak var vwImgGiveReview: UIView!
    
    @IBOutlet weak var vwRestaurantRating: HCSStarRatingView!
    @IBOutlet weak var vwCustomerRating: HCSStarRatingView!
    
    @IBOutlet weak var vwRestaurantTxt: UIView!
    @IBOutlet weak var txtRestaurantReview: UITextView!
    @IBOutlet weak var vwCustomerTxt: UIView!
    @IBOutlet weak var txtCustomerReview: UITextView!
    
    
    @IBOutlet weak var vwRestaurantInfo: UIView!
    @IBOutlet weak var vwRestaurantRatingInfo: UIView!
    @IBOutlet weak var vwDriverRatingInfo: UIView!
    
    @IBOutlet weak var vwScroll: UIScrollView!
    @IBOutlet weak var vwStack: UIStackView!
    @IBOutlet weak var vwNoData: UIView!
    
    //Localisation outlets -
    
    @IBOutlet weak var lblLOItems: UILabel!
    
    @IBOutlet weak var lblLOBillDetails: UILabel!
    @IBOutlet weak var lblLOTotalItemprice: UILabel!
    @IBOutlet weak var lblLORestorentCharges: UILabel!
    @IBOutlet weak var lblLODeliveryFee: UILabel!
    @IBOutlet weak var lblLOTotalPay: UILabel!
    
    
    //MARK: - Varibles
    var arrItemList:[ItemModel] = []
    var strOrderId = ""
    var strRestaurantId = ""
    var strDriverId = ""
    var strRestaurantImage  = ""
    var strDriverImage = ""
    var strCurrentStatus = ""
    var strRestaurantName  = ""
    var strDriverName = ""
    var strRestaurantRating  = ""
    var strDriverRating = ""
    var locationManager = CLLocationManager()
    var strPathSourceLat = ""
    var strPathSourceLong = ""
    var strPathDestinationLat = ""
    var strPathDestinationLong = ""

    @IBOutlet weak var ViewCreateBottom: NSLayoutConstraint!
    var swipeGesture = UISwipeGestureRecognizer()
    var bottomConstant : CGFloat = 0
    var isFromForgroundNotification = true
    
    // rohit sir
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setScroll()
      //  self.mapSetup()
    }
    
    
    
    func localisation(){
  
        
        self.lblLOItems.text = "Items".localize
        self.lblLOBillDetails.text = "Bill_Details".localize
        self.lblLOTotalItemprice.text = "Total_Items_Price".localize
        self.lblLORestorentCharges.text = "Restaurant_Charges".localize
        self.lblLODeliveryFee.text = "Delivery_Fee".localize
        self.lblLOTotalPay.text = "Total_Pay".localize
        
        self.btnGiveReview.setTitle("Give_Review".localize, for: .normal)


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
       // self.setScroll()
        self.localisation()
        //self.vwScroll.isScrollEnabled = false

        self.tabBarController?.tabBar.isHidden = true
        self.setUI()
        self.vwRound.isHidden = true
        self.vwNoData.isHidden = true
        //   self.vwCurrentLocation.isHidden = true
        self.callWsForOrderDetail()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)

    }
    
    @objc func refrershUI(){
        self.isFromForgroundNotification = true
        self.callWsForOrderDetail()

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
        }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //  self.setBootomView()
    }
    
    func setUI(){
        
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwDotted3.creatDashedLine(view: vwDotted3)
        self.vwDotted4.creatDashedLine(view: vwDotted4)
        
        self.vwRestaurantTxt.setCornerRadBoarder(color: .clear, cornerRadious: 12)
        self.vwCustomerTxt.setCornerRadBoarder(color: .clear, cornerRadious: 12)
        self.vwNoData.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)

        
        self.vwRound.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        self.vwCustomerProfile.setProfileVerifyView(vwOuter: self.vwCustomerProfile, img: self.imgCustomerProfile)
        self.vwRestaurantProfile.setProfileVerifyView(vwOuter: self.vwRestaurantProfile, img: self.imgRestaurantProfile)

        self.tblItems.reloadData()
        self.tblItems.delegate = self
        self.tblItems.dataSource = self
        
         self.vwGiveReview.setButtonView(vwOuter : self.vwGiveReview , vwImage : self.vwImgGiveReview, btn: self.btnGiveReview )
                
    }
    
    
    func setBootomView(){
        
        //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(0)) {
            
          //  self.bottomConstant = self.vwRound.frame.size.height - 250
            
            self.vwRound.isHidden = false
            //   self.vwCurrentLocation.isHidden = false
//            self.ViewCreateBottom.constant = -self.bottomConstant
//            UIView.animate(withDuration: 0.5) {
//                self.vwRound.layoutIfNeeded()
//            }
        //}
        
        
    }
        
    
    //MARK: - Button Action
    @IBAction func btnNoData(_ sender: UIButton) {
        self.view.endEditing(true)
    self.vwRound.isHidden = false
     self.vwNoData.isHidden = true
        
//        self.vwScroll.isScrollEnabled = true
//                           DispatchQueue.main.async {
//                               self.ViewCreateBottom.constant = 0
//                               self.vwRound.layoutIfNeeded()
//                              // self.tblItems.reloadData()
//
//                           }
    }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSlideUpDown(_ sender: UIButton) {
        self.vwRound.isHidden = true
        self.vwNoData.isHidden = false
    }
    
    @IBAction func btnRatingAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    @IBAction func btnCallAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    @IBAction func btnChatAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    @IBAction func btnCurrentLocationAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //
        //         if !objWebServiceManager.isNetworkAvailable(){
        //                    objAlert.showAlert(message: NoNetwork , title: kAlert , controller: self)
        //                    return
        //         }else{
        //              self.initializeTheLocationManager()
        //         }
        //
        
    }
    
    @IBAction func btnCancleAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.vwRound.isHidden = true
        self.vwNoData.isHidden = false
    }
    
    @IBAction func btnGiveRatingAction(_ sender: Any){
        self.view.endEditing(true)
        
        let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PastOrderRatingVC") as! PastOrderRatingVC
        detailVC.strOrderId = self.strOrderId
        detailVC.strRestaurantId = self.strRestaurantId
        detailVC.strDriverId = self.strDriverId
        detailVC.strRestaurantImage  = self.strRestaurantImage
        detailVC.strDriverImage = self.strDriverImage
        detailVC.strCurrentStatus = self.strCurrentStatus
        detailVC.strRestaurantName  = self.strRestaurantName
        detailVC.strDriverName = self.strDriverName
        detailVC.strRestaurantRating  = self.strRestaurantRating
        detailVC.strDriverRating = self.strDriverRating
        detailVC.modalPresentationStyle = .overCurrentContext
      //  self.tabBarController?.tabBar.isHidden = true
               detailVC.closerDeleteAlertList = {
                   isClearListData in
                   if isClearListData{
                       //self.resetAllData()
                   // self.tabBarController?.tabBar.isHidden = true
                 //   self.setScroll() // new
                    //self.vwScroll.isScrollEnabled = false // new
                    self.mapView.clear()
                    self.callWsForOrderDetail()
                   }
               }
        
        self.present(detailVC, animated: false, completion: nil)
    }
    
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource

extension CustomerPastOrderDetailVC : UITableViewDelegate ,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DispatchQueue.main.async {
               //self.tblHeightConstraint.constant = CGFloat((self.arrItemList.count * 44))
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
                    //self.tblHeightConstraint.constant = CGFloat((self.arrItemList.count * 44))
                    self.tblHeightConstraint.constant = self.tblItems.contentSize.height
                    self.tblItems.layoutIfNeeded()

                }
    }
    
}

//MARK: - Api calling

extension CustomerPastOrderDetailVC {
    
    // TODO: Webservice For Order Detail
    
    func callWsForOrderDetail(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
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
                        self.arrItemList.removeAll()
                        
                        if let arrItemData = dic?["items_info"] as? [[String: Any]]{
                            for dictItemData in arrItemData
                            {
                                let objData = ItemModel.init(dict: dictItemData)
                                self.arrItemList.append(objData)
                            }
                            print("self.arrItemList.count is \(self.arrItemList.count)")
                            
                        }
                        DispatchQueue.main.async {
                            if let orderDetail = dic?["order_detail"] as? [String:Any]{
                                
                                self.loadOrderDetail(dict : orderDetail)
                            }
                        }
                        
                        
                        self.setBootomView()
                        
                    }else{
                        
                        self.vwRound.isHidden = true
                    }
                }
                
                self.tblItems.reloadData()
                
                
                
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
    
    func loadOrderDetail(dict : [String:Any]){
        
        
        self.lblRestaurantChargeTitle.isHidden = true
        self.lblRestaurantCharge.isHidden = true
            
        
        if let driverId = dict["driver_id"]as? String {
                   self.strDriverId =  driverId
               }
        
        if let restaurantId = dict["restaurant_id"]as? String {
                   self.strRestaurantId =  restaurantId
               }
        
        
        if let name = dict["driver_name"]as? String {
            self.lblCustomerName.text = name.capitalizingFirstLetter()
            self.strDriverName = name
            self.lblCustomerName.isHidden = false
            self.vwCustomerProfile.isHidden = false
            self.imgCustomerRating.isHidden = false
            self.lblCustomerRating.isHidden = false
        }else{
             self.lblCustomerName.isHidden = true
            self.vwCustomerProfile.isHidden = true
            self.imgCustomerRating.isHidden = true
            self.lblCustomerRating.isHidden = true
        }
        
        
       
        
        if let avgRating = dict["driver_avg_rating"]as? String{
            let string = NSString(string: avgRating)
            self.lblCustomerRating.text = String(string.doubleValue)
            self.strDriverRating = avgRating
            
        }
        
        
        if let name = dict["restaurant_name"]as? String {
            self.lblRestaurantName.text = name.capitalizingFirstLetter()
            self.strRestaurantName = name
        }
        
        if let avgRating = dict["restaurant_avg_rating"]as? String{
            let string = NSString(string: avgRating)
            self.lblRestaurantRating.text = String(string.doubleValue).capitalizingFirstLetter()
            self.strRestaurantRating = avgRating
        }
        
        if let profilePic = dict["driver_image"]as? String{
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.strDriverImage = profilePic
                self.imgCustomerProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_placeholder_img_new"))
            }else{
                self.imgCustomerProfile.image = UIImage.init(named: "user_placeholder_img_new")
            }
        }
        
        
        if let profile = dict["restaurant_image"]as? String{
            if profile != "" {
                let url = URL(string: profile)
                self.strRestaurantImage = profile
                self.imgRestaurantProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "user_placeholder_img_new"))
            }else{
                self.imgRestaurantProfile.image = UIImage.init(named: "user_placeholder_img_new")
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
        
        if let customerToDriver = dict["customer_review_to_driver"] as? [String:Any]{
            
            if let rating = customerToDriver["rating"]as? String {
                
                if let ratingData = Double(rating) {
                    self.vwCustomerRating.value  = CGFloat(ratingData)
                }
                
                self.vwDriverRatingInfo.isHidden = false
                self.vwCustomerRating.isUserInteractionEnabled = false
                
                
            }else{
                self.vwDriverRatingInfo.isHidden = true
            }
            
            
            if let review = customerToDriver["review"]as? String {
                self.txtCustomerReview.text =  review
                self.vwCustomerTxt.isUserInteractionEnabled = false
                self.txtCustomerReview.layoutIfNeeded()
            }else{
                
            }
           
        }
        var isRatingExist = ""
        
        if let customerToRestaurant = dict["customer_review_to_restaurant"] as? [String:Any]{
            
            if let rating = customerToRestaurant["rating"]as? String {
                
                if let ratingData = Double(rating) {
                    self.vwRestaurantRating.value  = CGFloat(ratingData)
                }
                self.vwRestaurantInfo.isHidden = false
                self.vwRestaurantRatingInfo.isHidden = false
                
                self.vwRestaurantRating.isUserInteractionEnabled = false
                
                self.vwGiveReview.isHidden = true
                isRatingExist = "1"
            }else{
                self.vwRestaurantInfo.isHidden = true
                self.vwRestaurantRatingInfo.isHidden = true
                self.vwGiveReview.isHidden = false
                isRatingExist = ""

            }
            
            
            if let review = customerToRestaurant["review"]as? String {
                self.txtRestaurantReview.text =  review
                self.vwRestaurantTxt.isUserInteractionEnabled = false
                
            }else{
                
            }
            
        }
 
        
        if self.vwGiveReview.isHidden == false{
            self.vwStack.isHidden = true
        }else{
            self.vwStack.isHidden = false
        }
        
        if let currentStatus = dict["current_status"]as? String{
            self.strCurrentStatus = currentStatus
            if currentStatus == "6"{
                self.lblStatus.text = " \("Delivered".localize) "
                self.lblStatus.textColor = #colorLiteral(red: 0, green: 0.5725490196, blue: 0.02745098039, alpha: 1)
                self.vwStatus.backgroundColor = #colorLiteral(red: 0.8470588235, green: 0.9019607843, blue: 0.8509803922, alpha: 1)
                if isRatingExist == "1"{
                    
                }else{
                    self.vwGiveReview.isHidden = false

                }
                
            }else if currentStatus == "7" {
                self.lblStatus.text = " \("Cancelled".localize) "
                self.lblStatus.textColor = #colorLiteral(red: 1, green: 0.368627451, blue: 0, alpha: 1)
                self.vwStatus.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8823529412, blue: 0.8470588235, alpha: 1)
                self.vwGiveReview.isHidden = true
                
                
            }
            
        }
    }
    
}



//MARK:- extention for Gesture
extension CustomerPastOrderDetailVC{
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

//            self.bottomConstant = self.vwRound.frame.size.height - 250
//            self.ViewCreateBottom.constant = -self.bottomConstant
//
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                
                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.right:
                    print("Swiped right")
                case UISwipeGestureRecognizer.Direction.left:
                        print("Swiped left")
                case UISwipeGestureRecognizer.Direction.down:
                    print("Swiped down")
                    
//                    self.bottomConstant = self.vwRound.frame.size.height - 230
//                     //self.vwScroll.isScrollEnabled = false
//
//                        UIView.animate(withDuration: 0.5) {
//                            self.vwRound.layoutIfNeeded()
//                        }
                case UISwipeGestureRecognizer.Direction.up:
                    print("Swiped up")
     
//                    self.vwScroll.isScrollEnabled = true
//                    DispatchQueue.main.async {
//                        self.ViewCreateBottom.constant = 0
//                        self.vwRound.layoutIfNeeded()
//                       // self.tblItems.reloadData()
//
//                    }

                default:
                    break
                }
            }
        }
}


extension CustomerPastOrderDetailVC {
    
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
                    
//                    else if let country = placemarks?.first?.country,
//                        let city = placemarks?.first?.subLocality {
//                        print(country)
//                        print("placemarks is \(placemarks)")
//                        print("lat is \(String(latitude))")
//                        print("long is \(String(longitude))")
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
                objAlert.showAlert(message:"Location service is disabled!!".localize, title: kAlertTitle.localize, controller: self)
                break
                
            case .denied:
                print("Denied.")
            @unknown default: break
            }
        }
        
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

                  //self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
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


