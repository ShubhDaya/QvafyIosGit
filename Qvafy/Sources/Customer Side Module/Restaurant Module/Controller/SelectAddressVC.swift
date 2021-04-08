


//
//  SelectAddressVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 17/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import CoreLocation

class SelectAddressVC: UIViewController , CLLocationManagerDelegate {
    
    //MARK: Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var vwSearch: UIView!
    
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnAddAddress: UIButton!
    
    @IBOutlet weak var imgCurrentLocation: UIImageView!
    
    @IBOutlet weak var imgAddAdrresss: UIImageView!
    @IBOutlet weak var vwNoData: UIView!
    @IBOutlet weak var tblAddressList: UITableView!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var vwContinue: UIView!
    @IBOutlet weak var vwImgContinue: UIView!
    
    // Localisation outlets -
    @IBOutlet weak var lblLOSelectAddressHeader: UILabel!
    @IBOutlet weak var lblLONoAddressHere: UILabel!
    
    // @IBOutlet weak var vwCurrentLocation :CustomDashedView!
    //MARK: - Variables
    var arrAddress:[deliveryAddressModel] = []
    var strId = ""
    var strSavedId = ""
    var strSourceLat = ""
    var strSourceLong = ""
    var strLoction = ""
    var isFromCurrentLocation = false
    var isFromPlacePicker = false
    var isCurrentLocation = false
    var locationManager = CLLocationManager()
    
    //Searching & pagination
    var strSearchText = ""
    var isDataLoading:Bool=false
    var isSearching:Bool=false
    var limit:Int=10
    var offset:Int=0
    var totalRecords = Int()
    
    // Refresh
    var pullToRefreshCtrl:UIRefreshControl!
    var isRefreshing = false
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setPullToRefresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.localosation()
        self.vwNoData.isHidden = false
        self.vwContinue.setButtonView(vwOuter : self.vwContinue , vwImage : self.vwImgContinue, btn: self.btnContinue )
        
        self.vwHeader.setviewbottomShadow()
        self.vwSearch.setShadowListCornerRadius(cornerRadious: 5)
        self.txtSearch.attributedPlaceholder = NSAttributedString(string: "Search_Address".localize, attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1), NSAttributedString.Key.font: UIFont(name: "Poppins-Regular", size: 11.7)!])
        
        self.isFromCurrentLocation = false
        self.imgCurrentLocation.image = UIImage(named: "current_loction_inactive".localize)
        if self.isFromPlacePicker == false {
            
            self.removeAllData()
            self.callWsForGetDeliveryAddress()
        }else{
            
        }
        
        self.txtSearch.delegate = self
        
    }
    
    
    func removeAllData(){
        self.arrAddress.removeAll()
        self.limit = 10
        self.offset = 0
        self.strSearchText = ""
        self.txtSearch.text = ""
    }
    
    func localosation(){
        
        self.imgAddAdrresss.image = UIImage(named: "Add_Address_image".localize)
        self.lblLOSelectAddressHeader.text = "Select_Address".localize
        self.lblLONoAddressHere.text = "No_address_here".localize
        
        self.txtSearch.placeholder = "Search_Address".localize
        self.btnContinue.setTitle("Continue".localize, for: .normal)
        
    }
    
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        self.view.endEditing(true)
        
        if self.strId != "" {
            
            self.callWsForMakeDefaultAddress(deliveryAddressId: self.strId)
        } else {
            
            objAlert.showAlert(message: "Please_select_address".localize, title: kAlert.localize, controller: self)
            
        }
        
    }
    
    func selectButton(){
        
        // new running code
        let isEnable = self.checkForLocation()
        if !isEnable{
            self.showAlertForLocation()
        }else{
            self.getLocation()
        }
        
    }
    
    
    @IBAction func btnCurrentLocationAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.isFromPlacePicker = false
        //  objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork , title: kAlert , controller: self)
            
            return
        }else{
            self.selectButton()
            
            
        }
    }
    
    
    @IBAction func btnAddAddressAction(_ sender: Any) {
        self.view.endEditing(true)
        self.isFromCurrentLocation = false
        self.openPlacePickerForAddAddress()
        
    }
    
    //MARK:- open Place Picker For Source
    
    func openPlacePickerForAddAddress(){
        PlacePicker.shared.openPicker(controller: self, success: { (placeDict) in
            print("place info = \(placeDict)")
            self.isFromPlacePicker = true
            self.strLoction =  placeDict["formattedAddress"] as? String ?? ""
            self.strSourceLat = placeDict["lat"] as? String ?? ""
            self.strSourceLong = placeDict["long"] as? String ?? ""
            
            print("self.strSourceLat is \(self.strSourceLat)")
            print("self.strSourceLong is \(self.strSourceLong)")
            
            let coordLat = placeDict["clat"] as? CLLocationDegrees ?? 0.0
            let coordLong = placeDict["clong"] as? CLLocationDegrees ?? 0.0
            
            let Cordinate = CLLocationCoordinate2D.init(latitude: coordLat, longitude: coordLong)
            PlacePicker.shared.reverseGeocodeCoordinate(Cordinate, success: { (addressModel) in
                
            }) { (error) in
                print("error in getting address.")
            }
            //
            self.removeAllData() // new
            self.callWsForAddAddress()
        }) { (error) in
            print("error = \(error.localizedDescription)")
        }
    }
    
}

//MARK: - use current location

extension SelectAddressVC {
    
    // new running code
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
                
                ///
                
                self.strLoction = addressModel.address ?? ""
                self.strSourceLat = String(addressModel.lat ?? "")
                self.strSourceLong = String(addressModel.lng ?? "")
                self.imgCurrentLocation.image = UIImage(named: "current_loction_active_img".localize)
                //#imageLiteral(resourceName: "current_loction_active_img")
                self.strSavedId = self.strId
                self.strId = ""
                ///     self.tblAddressList.reloadData()
                self.isFromCurrentLocation = true
                
                self.removeAllData() // new
                self.callWsForAddAddress()
                
                
                print("self.strSourceLat is \(self.strSourceLat)")
                print("self.strSourceLong is \(self.strSourceLong)")
                print("self.strLoction is \(self.strLoction)")
                print("self.arrAddress.count is current location \(self.arrAddress.count)")
                ///
                
                
                //                self.strSourceAddress = addressModel.address ?? ""
                //                self.txtSource.text = addressModel.address ?? ""
                //                self.txtSource.textColor = #colorLiteral(red: 0.07058823529, green: 0.07058823529, blue: 0.07058823529, alpha: 1)
                //
                //
                //                self.StrCurrentSource = addressModel.address ?? ""
                //
                //
                //                self.strSourceLat = addressModel.lat ?? ""
                //                self.strSourceLong = addressModel.lng ?? ""
                //
                //
                //                self.strlat = addressModel.lat ?? ""
                //                self.strlong =  addressModel.lng ?? ""
                //
                //
                //                print("self.strSourceAddress is \(self.strSourceAddress)")
                //              //  print("self.txtSource.text is \(self.txtSource.text)")
                //                print("self.strSourceLat is \(self.strSourceLat)")
                //                print("self.strSourceLong is \(self.strSourceLong)")
                //                print("self.strlat is \(self.strlat)")
                //                print("self.strlong is \(self.strlong)")
                //                self.setCurrentLocation()
                //                self.callWsForUpdateLocation(lat : self.strSourceLat , long : self.strSourceLong , address : self.strSourceAddress )
                
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
        
        objAlert.showAlertCallOneBtnAction(btnHandler: "Settings", title: "Need_Authorization".localize, message: "This app is unusable if you don't authorize this app to use your location!".localize, controller: self) {
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:]
                                      
                                      , completionHandler: nil)
        }
    }
    // new running code
}

//MARK: - Extension UITableViewDelegate and UITableViewDataSource


extension SelectAddressVC : UITableViewDelegate ,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAddress.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicInfoCell", for: indexPath) as!BasicInfoCell
        let obj = self.arrAddress[indexPath.row]
       
        cell.lblTitle.text = obj.strAddress.capitalizingFirstLetter()
        if self.strId == obj.strDeliveryAddID {
            cell.imgCheck.image = #imageLiteral(resourceName: "selected_ico")
            obj.isSelect = true
        }else{
            cell.imgCheck.image = #imageLiteral(resourceName: "inactive_tick_ico")
            obj.isSelect = false
        }
        
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self,action:#selector(buttonClicked(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let obj = self.arrAddress[indexPath.row]
        
        
        // TODO: For DeleteAction
        let DeleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            
            let alert = UIAlertController(title: kAlert, message: "Are_you_sure_you_want_to_delete_this_address?".localize, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
            alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
                
                self.callWsForDeleteAddress(deliveryAddressId : String(obj.strDeliveryAddID))
                
            }))
            self.present(alert, animated: true, completion: nil)
        })
        
        DeleteAction.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        DeleteAction.image = UIImage(named: "delete_ico_red")
        
        //        DeleteAction.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        DeleteAction.image = UIImage(named: "delete_ico_red")
        /// DeleteAction.title = "Unfollow"
        
        return UISwipeActionsConfiguration(actions: [DeleteAction])
    }
    
    @objc func buttonClicked(sender:UIButton) {
        
        
        
        if self.arrAddress.count > 0 {
        let obj = self.arrAddress[sender.tag]
        self.strId = obj.strDeliveryAddID
        self.strLoction = obj.strAddress
        print("Id is availabele")
        print("self.arrAddress.count is in button click  \(self.arrAddress.count)")
        self.tblAddressList.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 70
    }
}


//MARK: - Api Calling


extension SelectAddressVC  {
    
    //    // TODO: Webservice For get Delivery Address list
    //
    func callWsForGetDeliveryAddress(){
        
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
        
        
        objWebServiceManager.requestGet(strURL:WsUrl.getDeliveryAddress+"limit="+String(self.limit)+"&offset="+String(self.offset)+"&search="+self.strSearchText+"&is_default="+"2",Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
            print(response)
            
            
            objWebServiceManager.StopIndicator()
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            if self.isRefreshing{
                self.arrAddress.removeAll()
            }
            self.isRefreshing = false
            self.pullToRefreshCtrl.endRefreshing()
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        self.vwNoData.isHidden = true
                        self.tblAddressList.isHidden = false
                        ///    self.vwChange.isHidden = false
                        
                        self.totalRecords = dic?["total_records"] as? Int ?? 0
                        print("self.totalRecords is \(self.totalRecords)")
                        
                        if let arrReviewData = dic?["delivery_address_list"] as? [[String: Any]]{
                            //self.arrAddress.removeAll()
                            for dictListData in arrReviewData
                            {
                                let objListData = deliveryAddressModel.init(dict: dictListData)
                                self.arrAddress.append(objListData)
                                if objListData.strIsDefault == "1"{
                                    self.strId = objListData.strDeliveryAddID
                                }
                            }
                            print("self.arrAddress.count is main api \(self.arrAddress.count)")
                        }
                        
                    }else{
                        self.vwNoData.isHidden = false
                        self.tblAddressList.isHidden = true
                        //   self.vwChange.isHidden = true
                    }
                }
                self.tblAddressList.reloadData()
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
    
    
    // TODO: Webservice For Add Address
    
    func callWsForAddAddress(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
         objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        param = [
            WsParam.address: self.strLoction ,
            WsParam.latitude: self.strSourceLat,
            WsParam.longitude: self.strSourceLong
        ] as [String : Any]
        
        print("Add address param - \(param)")
        
        objWebServiceManager.requestPost(strURL: WsUrl.addDeliveryAddress, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            // objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                if self.isFromCurrentLocation == true{
                    let dic  = response["data"] as? [String:Any]
                    
//                    if let deliveryAddressId = dic?["delivery_address_id"]as? Int{
//                        objAppShareData.deliveryAddressId = String(deliveryAddressId)
//                        print("deliveryAddressId in current location is \(deliveryAddressId)")
//                        objAppShareData.strCurrentLoction =  self.strLoction
//                        objAppShareData.isFromSelectAddress = true
//                        self.navigationController?.popViewController(animated: false)
//                    }
                    
                    let deliveryAddressId = dictToStringKeyParam(dict: dic ?? [:], key: "delivery_address_id")
                    self.callWsForMakeDefaultAddress(deliveryAddressId: deliveryAddressId)
             
                 //   print(dictToStringKeyParam(dict: dic ?? [:], key: "delivery_address_id"))
                  //  print("self.isFromCurrentLocation is \(self.isFromCurrentLocation)")
//                        objAppShareData.deliveryAddressId = deliveryAddressId
//                        print("deliveryAddressId in current location is \(deliveryAddressId)")
//                        objAppShareData.strCurrentLoction =  self.strLoction
//                        objAppShareData.isFromSelectAddress = true
//                        self.navigationController?.popViewController(animated: false)
                }else{
                    self.removeAllData()
                    self.callWsForGetDeliveryAddress()
                    
                }
                
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
            
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
    
    // TODO: Webservice For delete Delivery Address
    
    func callWsForDeleteAddress(deliveryAddressId : String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            
            return
        }
        
        objWebServiceManager.StartIndicator()
        
        var strWsUrl = ""
        
        strWsUrl  =   WsUrl.deleteDeliveryAddress  +  deliveryAddressId
        
        print("strWsUrl is \(strWsUrl)")
        
        objWebServiceManager.requestDELETE(strURL: strWsUrl, Queryparams: nil , body: nil , strCustomValidation: "", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                
                let alert = UIAlertController(title:kAlert.localize , message:message ?? "", preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title:"Ok".localize, style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.removeAllData()
                    self.callWsForGetDeliveryAddress()
                    
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
                
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
                
                
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
    
    
    // TODO: Webservice For make Default Address
    func callWsForMakeDefaultAddress(deliveryAddressId:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //  objWebServiceManager.StartIndicator()
        
        
        var strWsUrl = ""
        
        strWsUrl  =   WsUrl.makeDefaultAddress  +  deliveryAddressId
        print("strWsUrl for make default address - \(strWsUrl)")
        
        objWebServiceManager.requestPut(strURL: strWsUrl, Queryparams:nil , body:nil ,strCustomValidation: "", success: {response in
            
            print(response)
            //  objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                self.navigationController?.popViewController(animated: false)
                
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
}

//MARK:- Pagination
extension SelectAddressVC {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((self.tblAddressList.contentOffset.y + self.tblAddressList.frame.size.height) >= self.tblAddressList.contentSize.height)
            {
                
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if self.arrAddress.count == self.totalRecords {
                        
                    }else {
                        print("api calling in pagination ")
                        self.callWsForGetDeliveryAddress()
                    }
                }
            }
        }
    }
}

//MARK: - searching operation
extension SelectAddressVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let text = textField.text! as NSString
        
        if (text.length == 1) && (string == "") {
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
            strSearchText = ""
            self.arrAddress.removeAll()
            self.limit = 10
            self.offset = 0
            //self.reload()
            self.isSearching = true
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
            
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
            self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
        }
    }
    
    @objc func reload() {
        self.arrAddress.removeAll()
        self.limit = 10
        self.offset = 0
        print("api calling in searching")
        self.callWsForGetDeliveryAddress()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
}



//MARK: - Pull to refresh list
extension SelectAddressVC{
    func setPullToRefresh(){
        pullToRefreshCtrl = UIRefreshControl()
        pullToRefreshCtrl.addTarget(self, action: #selector(self.pullToRefreshClick(sender:)), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.tblAddressList.refreshControl = pullToRefreshCtrl
        } else {
            self.tblAddressList.addSubview(pullToRefreshCtrl)
        }
    }
    
    @objc func pullToRefreshClick(sender:UIRefreshControl) {
        isRefreshing = true
        limit = 10
        offset = 0
        self.callWsForGetDeliveryAddress()
    }
}
