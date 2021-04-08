//
//  RestaurantListVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 01/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation
import SlideMenuControllerSwift
import GoogleMaps

class RestaurantListVC: UIViewController ,CLLocationManagerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSearch: UIView!
    @IBOutlet weak var vwTable: UIView!
    @IBOutlet weak var vwNoData: UIView!
    //  @IBOutlet weak var vwDataCollection: UIView!
    @IBOutlet weak var vwCollection: UICollectionView!
    @IBOutlet weak var tblRestaurant: UITableView!
    @IBOutlet weak var vwBottom: UIView!
    // Added cart item
    @IBOutlet weak var vwAddedCartList: UIView!
    @IBOutlet weak var lblitemCount: UILabel!
    @IBOutlet weak var lblAddedItemPrice: UILabel!
    // Localization Outlets -
    
    @IBOutlet weak var lblLOChange: UILabel!
    // text field
    
    // @IBOutlet weak var lblLOCode: UILabel!
    @IBOutlet weak var lblLONORestorent: UILabel!
    
      @IBOutlet weak var vwScroll: UIScrollView!
    
    //MARK: - Variables
    
    var arrRestaurant:[RestaurantModel] = []
    var arrPromoCode:[PromoCodeModel] = []
    //    var strSourceLat = ""
    //    var strSourceLong = ""
    
    var locationManager = CLLocationManager()
    // var StrCurrentSource : String = ""
    
    //Searching & pagination
    var strSearchText = ""
    var isDataLoading:Bool=false
    var isSearching:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    var isOpen = "1"
    // Refresh
    var pullToRefreshCtrl:UIRefreshControl!
    var isRefreshing = false
    
    var strRestaurantId = ""
    
    // when no data found
    var refreshControl: UIRefreshControl!
    
    
    //MARK: LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwCollection.delegate = self
        self.vwCollection.dataSource = self
        self.txtSearch.delegate = self
        self.setPullToRefresh()
        self.setPullToRefreshNoDataFound()
        
        // txtSearch.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwAddedCartList.isHidden = true

        self.localization()
        print("viewWillAppear is called")
        //self.vwNoData.isHidden = true
        self.lblLONORestorent.isHidden = true
        self.vwScroll.isHidden = true
        self.vwCollection.isHidden = true
        self.vwTable.isHidden = true
        self.vwHeader.setviewbottomShadow()
        self.vwSearch.setShadowWithCornerRadius()
        self.vwAddedCartList.setCornerRadiusBoarder(color:  #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 8)
        
        // self.vwSearch.setShadowListCornerRadius(cornerRadious: 5)
        self.txtSearch.attributedPlaceholder = NSAttributedString(string: "Search_for_restaurant".localize, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.7)!])
        
        if !objWebServiceManager.isNetworkAvailable(){
            return
        }else{
            self.removeAllData()
            if objAppShareData.isFromFilter == true || objAppShareData.isFromPlacePicker == true{
                self.lblLocation.text = objAppShareData.strLoction
                self.checkLocation()
            }else{
                
                let isEnable = self.checkForLocation()
                if !isEnable{
                    self.showAlertForLocation()
                }else{
                    self.getLocation()
                }
            }
        }
        
        // self.removeAllData()
        self.callWsGetPromoCodeList()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    
    @objc func refrershUI(){
        self.txtSearch.resignFirstResponder()
        self.removeAllData()
        self.strSearchText = ""
        objAppShareData.strRadius =  "5"
        objAppShareData.strRatingcount = "0"
        objAppShareData.strCategoryId = ""
        objAppShareData.strBusinessId = ""
        objAppShareData.strSourceLat = ""
        objAppShareData.strSourceLong = ""
        
        
//        objAppShareData.isFromFilter = false
        objAppShareData.isFromPlacePicker = false
        objAppShareData.arrSelectedBusinessId = []
        objAppShareData.arrSelectedCategoryId = []
        //
        
        let isEnable = self.checkForLocation()
        if !isEnable{
            self.showAlertForLocation()
        }else{
            self.getLocation()
        }
    }
    func checkLocation(){
        if objAppShareData.strSourceLat != "" || objAppShareData.strSourceLat != ""{
            print("objAppShareData.strSourceLong is present")
            
            //   if self.arrRestaurant.count == self.totalRecords {
            
            //  if self.totalRecords != 0 {
            if self.arrRestaurant.count != 0 {
                print("arrRestaurant count is \(self.arrRestaurant.count)")
                print("self.totalRecords count is \(self.totalRecords)")
                
                print("self.arrRestaurant.count == self.totalRecords is equal")
                
            }else {
                print("self.arrRestaurant.count == self.totalRecords is not equal")
                self.removeAllData()
                self.callWsGetRestaurantList()
            }
            
        }else{
            print("objAppShareData.strSourceLong is present not")
            self.removeAllData()
            self.callWsGetRestaurantList()
        }
    }
    
    func localization(){
        
        self.lblLOChange.text = "CHANGE".localize
        self.lblLONORestorent.text = "No_restaurants_here".localize
        self.txtSearch.placeholder = "Search_for_restaurant".localize
    }
    
    
    func removeAllData(){
        self.arrRestaurant.removeAll()
        self.limit = 10
        self.offset = 0
        self.strSearchText = ""
        self.txtSearch.text = ""
        //self.txtSearch.text = "Mindii"
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisappear is called")
        self.removeAllData()
        NotificationCenter.default.removeObserver(self)

    }
    
    //MARK: - Button Action
    
    @IBAction func btnSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnChangeLocation(_ sender: Any) {
        self.view.endEditing(true)
        self.openPlacePickerForSource()
        
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Restaurant", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        detailVC.StrCurrentSource = self.lblLocation.text ?? objAppShareData.strLoction
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    @IBAction func btnViewCart(_ sender: Any) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Restaurant", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CartListVC") as! CartListVC
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    @IBAction func btnDeleteCart(_ sender: Any) {
        self.view.endEditing(true)
        
        objAlert.showAlertCallBack(alertLeftBtn: "No".localize, alertRightBtn: "Yes".localize, title: kAlert.localize, message: "Are you sure you want to clear cart?".localize, controller: self) {
            self.callWsForDeleteCart(restaurantId : self.strRestaurantId )
        }
    }
    
    //MARK:- open Place Picker For Source
    
    func openPlacePickerForSource(){
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            
            self.lblLocation.text = placeDict["formattedAddress"] as? String ?? ""
            
            objAppShareData.strLoction =  placeDict["formattedAddress"] as? String ?? ""
            
            objAppShareData.isFromPlacePicker = true
            objAppShareData.strSourceLat = placeDict["lat"] as? String ?? ""
            objAppShareData.strSourceLong = placeDict["long"] as? String ?? ""
            
            
            print("objAppShareData.strSourceLat is \(objAppShareData.strSourceLat)")
            print("objAppShareData.strSourceLong is \(objAppShareData.strSourceLong)")
            
            
            
            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                
            }) { (error) in
                print("error in getting address.")
            }
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
    
    //MARK:- Get User Current Location Work
    
    // TODO: Get Current Location new same as mapvc
    func getLocation(){
        
        PlacePicker.shared.getUsersCurrentLocation(success: { (CLLocationCoordinate2D) in
            print(CLLocationCoordinate2D)
            
            print("getLocation dict")
            let lat = CLLocationCoordinate2D.latitude
            let long = CLLocationCoordinate2D.longitude
            
            
            let Cordinate = type(of: CLLocationCoordinate2D).init(latitude: lat, longitude: long)
            
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                objAppShareData.strSourceLat = addressModel.lat ?? ""
                objAppShareData.strSourceLong = addressModel.lng ?? ""
                self.lblLocation.text = addressModel.address ?? ""
                objAppShareData.strLoction = addressModel.address ?? ""
                print("objAppShareData.strSourceLat 1 is  \(objAppShareData.strSourceLat)")
                print("objAppShareData.strSourceLong 1 is \(objAppShareData.strSourceLong)")
                print("self.lblLocation is \(String(describing: self.lblLocation.text))")
                print("self.lblLocation is \(objAppShareData.strLoction)")
                print("api calling in  Get User Current Location")
                self.checkLocation()
                
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
}


extension RestaurantListVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrRestaurant.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tblRestaurant.dequeueReusableCell(withIdentifier: "RestaurantTableCell")as! RestaurantTableCell
        
        print("arrRestaurant count is \(self.arrRestaurant.count)")
        if self.arrRestaurant.count == 0 {
            return UITableViewCell()
        }
        
        if self.arrRestaurant.count > 0 {
            let obj = self.arrRestaurant[indexPath.row]
            cell.lblName.text = obj.strFullName.capitalizingFirstLetter()
            cell.lblCetagory.text = obj.strBusinessType
            cell.lblDistance.text = obj.strDistance + " km " + "Away".localize
            //cell.lblRating.text = obj.strAvgRating
            let string = NSString(string: obj.strAvgRating)
            cell.lblRating.text = String(string.doubleValue)
            let profilePic = obj.strAvatar
            if profilePic != "" {
                let url = URL(string: profilePic)
                cell.imgRestaurant.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "squre_placeholder_img"))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if arrRestaurant.count > 0 {
        
        let obj = arrRestaurant[indexPath.row]
        print("obj.strUserID in didselect \(obj.strUserID)")
        let sb = UIStoryboard(name: "Restaurant", bundle: nil)
        //  let detailVC = sb.instantiateViewController(withIdentifier: "RestaurantDetailVC") as! RestaurantDetailVC
        let detailVC = sb.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        detailVC.strRestaurantId = obj.strUserID
        detailVC.strlatitude = objAppShareData.strSourceLat
        detailVC.strlongitude = objAppShareData.strSourceLong
        self.txtSearch.resignFirstResponder()
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    }
}

//MARK: - Extension Collection View

extension RestaurantListVC: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPromoCode.count
        //  return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = vwCollection.dequeueReusableCell(withReuseIdentifier: "RestaurantCVCell", for: indexPath) as! RestaurantCVCell
        
        let obj = self.arrPromoCode[indexPath.row]
        cell.lblPercentage.text = obj.strPercentage + "%"
        cell.lblOFF.text = "OFF".localize // obj.strTitle
        cell.lblLOCode.text = "\("Code".localize) :"
        cell.lblCode.text = obj.strPromoCode
        
        let profilePic = obj.strPromoImage
        if profilePic != "" {
            let url = URL(string: profilePic)
            cell.imgOffer.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "offer_placeholder_img"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj = arrPromoCode[indexPath.row]
        print("obj.strPercentage in didselect \(obj.strPercentage)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 100 )
    }
}

extension RestaurantListVC {
    // TODO: Webservice For getPromoCodeList
    func callWsGetPromoCodeList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        objWebServiceManager.requestGet(strURL: WsUrl.getPromoCodeList  ,Queryparams: [:], body: [:], strCustomValidation: "", success: {response in
            print(response)
            //  objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                if  let  dataFound = dict?["data_found"] as? Int  {
                    if dataFound == 1 {
                        self.vwCollection.isHidden = false
                        if let arrPromoCodeData = dict?["booking_list"] as? [[String:Any]]{
                            self.arrPromoCode.removeAll()
                            for dictPromoCodeData in arrPromoCodeData{
                                let objPromoCodeData = PromoCodeModel.init(dict: dictPromoCodeData)
                                self.arrPromoCode.append(objPromoCodeData)
                            }
                            print("arrPromoCode count is \(self.arrPromoCode.count)")
                        }
                    }else{
                        self.vwCollection.isHidden = true
                    }
                }
                self.vwCollection.reloadData()
            }else
            {
                objAlert.showAlert(message:message ?? "", title:kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    
    // TODO: Webservice For getRestaurantList
    func callWsGetRestaurantList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        if isRefreshing{
            objWebServiceManager.StopIndicator()
        }else if self.isSearching{
            objWebServiceManager.StopIndicator()
        }else{
            objWebServiceManager.StartIndicator()
            
        }
        self.tabBarController?.tabBar.isUserInteractionEnabled = false
  
        objWebServiceManager.requestGet(strURL:WsUrl.getRestaurantList+"limit="+String(self.limit)+"&offset="+String(self.offset)+"&search="+self.strSearchText+"&radius="+objAppShareData.strRadius+"&rating="+objAppShareData.strRatingcount+"&category_ids="+objAppShareData.strCategoryId+"&business_ids="+objAppShareData.strBusinessId+"&latitude="+objAppShareData.strSourceLat+"&longitude="+objAppShareData.strSourceLong,
                                        Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
                                            
                                            self.tabBarController?.tabBar.isUserInteractionEnabled = true
                                            print(response)
                                            objWebServiceManager.StopIndicator()
                                      
                                            let status =   (response["status"] as? String)
                                            let message =  (response["message"] as? String)
                                            
                                            if self.isRefreshing{
                                                self.arrRestaurant.removeAll()
                                            }
                                            self.isRefreshing = false
                                            self.pullToRefreshCtrl.endRefreshing()
                                            self.vwAddedCartList.isHidden = true
                                            if status == "success"
                                            {
                                                let dict  = response["data"] as? [String:Any]
                                                
                                                //  self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                if  let  dataFound = dict?["data_found"] as? Int  {
                                                    if dataFound == 1 {
                                                        self.callWsForGetCartList()
                                                        //working shubham
                                                    //    self.vwAddedCartList.isHidden = true
                                                       // self.vwNoData.isHidden = true
                                                        self.lblLONORestorent.isHidden = true
                                                        self.vwScroll.isHidden = true
                                                        self.vwTable.isHidden = false
                                                        //   self.totalRecords = Int(dict?["total_records"] as? String ?? "") ?? 0
                                                        self.totalRecords = dict?["total_records"] as? Int ?? 0
                                                        if let arrRestaurantData = dict?["restaurant_list"] as? [[String:Any]]{
                                                            for dictRestaurantData in arrRestaurantData{
                                                                let objRestaurantData = RestaurantModel.init(dict: dictRestaurantData)
                                                             
                                                                let arr = self.arrRestaurant.filter({$0.strUserID == objRestaurantData.strUserID})
                                                                if arr.count == 0{
                                                                    self.arrRestaurant.append(objRestaurantData)
                                                                }
                                                                
                                                              //  self.arrRestaurant.append(objRestaurantData)
                                                                
                                                            }
                                                            //  print("arrRestaurant count is \(self.arrRestaurant.count)")
                                                        }
                                                        print("self.totalRecords count is \(self.totalRecords)")
                                                        
                                                        if self.arrRestaurant.count != 0 {
                                                            self.tblRestaurant.reloadData()
                                                            
                                                            DispatchQueue.main.async {
                                                            self.tblRestaurant.contentSize = CGSize(width: 0.0 , height: self.tblRestaurant.contentSize.height + 150)
                                                            self.view.layoutIfNeeded()
                                                            }
                                                            
                                                        }
                                                    }else{
                                                       // self.vwAddedCartList.isHidden = false
                                                       // self.vwNoData.isHidden = false
                                                        self.lblLONORestorent.isHidden = false
                                                        self.vwScroll.isHidden = false
                                                        self.vwTable.isHidden = true
                                                        self.callWsForGetCartList()

                                                    }
                                                    
                                                }
                                                //                print("self.totalRecords count is \(self.totalRecords)")
                                                //                self.tblRestaurant.reloadData()
                                            }else
                                            {
                                                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
                                            }
                                        }, failure: { (error) in
                                            print(error)
                                            objWebServiceManager.StopIndicator()
                                            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
                                            
                                        })
        
    }
    
    // TODO: Webservice For get Cart List
    func callWsForGetCartList(){
        self.vwAddedCartList.isHidden = true

        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        // objWebServiceManager.StartIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.cartList ,Queryparams: [:], body: [:], strCustomValidation: "", success: {response in
            print(response)
            
            objWebServiceManager.StopIndicator()
            let status = (response["status"] as? String)
            let message = (response["message"] as? String)
            
            if status == "success"{
                
                let dic = response["data"] as? [String:Any]
                
                if let dataFound = dic?["data_found"] as? Int {
                    if dataFound == 1 {
                        self.vwAddedCartList.isHidden = false
                        
                        if let arrCartList = dic?["cart_list"] as? [[String:Any]]{
                            for dictRestaurantData in arrCartList{
                                let RestuarentId = dictRestaurantData["restaurant_id"]
                                print(RestuarentId ?? 0)
                                self.strRestaurantId = RestuarentId as! String
                            }
                        }
                        
                        if let pricingDetail = dic?["pricing_detail"] as? [String:Any]{
                            self.lblAddedItemPrice.text = ""
                            
                            if let totalAmount = pricingDetail["total_amount"]as? String{
                                self.lblAddedItemPrice.text = "$" + totalAmount
                                
                            }
                            if let totalItems = pricingDetail["total_items"]as? String{
                                print("totalItems count is \(totalItems)")
                                
                                if totalItems == "1"{
                                    self.lblitemCount.text = totalItems + " \("item".localize)"
                                    
                                }else{
                                    self.lblitemCount.text = totalItems + " \("items".localize)"
                                }
                            }
                            
                            
                            if let restaurantOpen = pricingDetail["restaurant_open"]as? String{
                                self.isOpen = restaurantOpen
                                
                            }
                            
                             if self.isOpen == "1"{
                                self.vwAddedCartList.isHidden = false
                             }else{
                                self.vwAddedCartList.isHidden = true
                             }
                        }
                    }else{
                        self.vwAddedCartList.isHidden = true
                        
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
    
    // TODO: Webservice For delete Cart
    
    func callWsForDeleteCart(restaurantId : String ){
    
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var strWsUrl = ""
        strWsUrl  =   WsUrl.deleteCart  +  restaurantId
        print("strWsUrl is \(strWsUrl)")
        
        objWebServiceManager.requestDELETE(strURL: strWsUrl, Queryparams: nil , body: nil , strCustomValidation: "", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                self.vwAddedCartList.isHidden = true
                //self.arrRestaurant.removeAll()
                //self.callWsGetRestaurantList()()
                
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

//MARK:- Pagination
extension RestaurantListVC {
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((self.tblRestaurant.contentOffset.y + self.tblRestaurant.frame.size.height) >= self.tblRestaurant.contentSize.height)
            {
                if ((self.vwCollection.contentOffset.y + self.vwCollection.frame.size.height) >= self.vwCollection.contentSize.height) {
                    return
                }
                else if ((self.vwScroll.contentOffset.y + self.vwScroll.frame.size.height) >= self.vwScroll.contentSize.height) {
                    return
                }
                
                if !isDataLoading{
                    isDataLoading = true               
                    self.offset = self.offset+self.limit
                    
                    if self.arrRestaurant.count == self.totalRecords {
                        
                    }else {
                        print("api calling in pagination ")
                        self.callWsGetRestaurantList()
                    }
                }
                
            }
        }
    }
}

//MARK: - searching operation
extension RestaurantListVC : UITextFieldDelegate{
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        //        let text = textField.text! as NSString
        //
        //        if (text.length == 1) && (string == "") {
        //            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        //            strSearchText = ""
        //            self.arrRestaurant.removeAll()
        //            self.limit = 10
        //            self.offset = 0
        //            //self.reload()
        //            self.isSearching = true
        //            self.perform(#selector(self.reload), with: nil, afterDelay: 0.8)
        //
        //        }else{
        //            var substring: String = textField.text!
        //            substring = (substring as NSString).replacingCharacters(in: range, with: string)
        //            substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        //            self.isSearching = true
        //
        //            searchAutocompleteEntries(withSubstring: substring)
        //        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let text = textField.text! as NSString
        
        if (text.length == 1) && (string == "") {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            strSearchText = ""
            self.arrRestaurant.removeAll()
            self.limit = 10
            self.offset = 0
            //self.reload()
            self.isSearching = true
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.8)
            
        }else{
            var substring: String = textField.text!
            substring = (substring as NSString).replacingCharacters(in: range, with: string)
            substring = substring.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            self.isSearching = true
            
            searchAutocompleteEntries(withSubstring: substring)
        }
        return true
    }
    
    func searchAutocompleteEntries(withSubstring substring: String) {
        if substring != "" {
            strSearchText = substring
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.8)
        }
    }
    
    @objc func reload() {
        self.arrRestaurant.removeAll()
        self.limit = 10
        self.offset = 0
        print("api calling in searching")
        self.callWsGetRestaurantList()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //
        //        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        //        self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        //
        
        return true
    }
    
}



//MARK: - Pull to refresh list
extension RestaurantListVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblRestaurant.refreshControl = pullToRefreshCtrl
        } else {
            self.tblRestaurant.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
        self.resetFilter()
        limit = 10
        offset = 0
       // self.callWsGetRestaurantList()
        self.vwAddedCartList.isHidden = true
    }
    
    func setPullToRefreshNoDataFound(){
    self.vwScroll.alwaysBounceVertical = true
    self.vwScroll.bounces = true
    refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    self.vwScroll.addSubview(refreshControl)
    }

    @objc func didPullToRefresh() {

        refreshControl?.endRefreshing()
        isRefreshing = true
        self.resetFilter()
        limit = 10
        offset = 0
      //  self.callWsGetRestaurantList()
        self.vwAddedCartList.isHidden = true
    }
   
    
    func resetFilter(){
        self.removeAllData()
        self.strSearchText = ""
        objAppShareData.strRadius =  "5"
        objAppShareData.strRatingcount = "0"
        objAppShareData.strCategoryId = ""
        objAppShareData.strBusinessId = ""
        objAppShareData.strSourceLat = ""
        objAppShareData.strSourceLong = ""
        
        
//        objAppShareData.isFromFilter = false
        objAppShareData.isFromPlacePicker = false
        objAppShareData.arrSelectedBusinessId = []
        objAppShareData.arrSelectedCategoryId = []
        //
        
        let isEnable = self.checkForLocation()
        if !isEnable{
            self.showAlertForLocation()
        }else{
            self.getLocation()
        }
    }
    
}


