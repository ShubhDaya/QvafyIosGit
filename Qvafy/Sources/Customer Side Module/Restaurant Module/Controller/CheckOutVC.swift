//
//  CheckOutVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 10/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class CheckOutVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var tblCart: UITableView!
    
    @IBOutlet weak var vwChange: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var vwContinue: UIView!
    @IBOutlet weak var vwImgContinue: UIView!
    
    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    
    @IBOutlet weak var lblTotalItemPrice: UILabel!
    @IBOutlet weak var lblRestaurantCharges: UILabel!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var lblPay: UILabel!
    
    @IBOutlet weak var lblOfferTitle: UILabel!
    
    @IBOutlet weak var lblRestaurantChargeTitle: UILabel!
    
    
    //Localization outlets -
    @IBOutlet weak var lblHeaderCheckOut: UILabel!
    @IBOutlet weak var lblLOBillDetails: UILabel!
    @IBOutlet weak var lblLOTotalItemPrice: UILabel!
    @IBOutlet weak var lblLoRestorentCharges: UILabel!
    @IBOutlet weak var lblLOTotalOay: UILabel!
    @IBOutlet weak var lblLODeliveryFees: UILabel!
    @IBOutlet weak var lblLOeliveryTOHome: UILabel!
    @IBOutlet weak var lblLOChange: UILabel!
    
    
    //MARK: - Variables
    
    var arrCartList:[CartModel] = []
    
    var strRestaurantId = ""
    var strDeliveryAddressID = ""
    
    
    var strQuantity:Int = 0
    var strMenuId: String = ""
    
    //Searching & pagination
    var strSearchText = ""
    var isDataLoading:Bool=false
    var isSearching:Bool=false
    var limit:Int=100
    var offset:Int=0
    var totalRecords = Int()
    var strNextPageUrl = ""
    
    
    var strTotalAmount = ""
    var strDiscountAccount = ""
    
    //MARK: LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblCart.delegate = self
        self.tblCart.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localisation()
        self.setUI()
    }
    
    func removeAllData(){
        self.arrCartList.removeAll()
        self.limit = 100
        self.offset = 0
    }
    
    
    //MARK: - Custom Functions
    
    
    func localisation(){
        
        self.lblHeaderCheckOut.text = "Checkout".localize
        self.lblLOBillDetails.text = "Bill_Details".localize
        self.lblLOTotalItemPrice.text = "Total_Items_Price".localize
        self.lblLoRestorentCharges.text = "Restaurant_Charges".localize
        self.lblLOTotalOay.text = "Total_Pay".localize
        self.lblLODeliveryFees.text = "Delivery_Fee".localize
        self.lblLOeliveryTOHome.text = "Deliver_to_Home".localize
        self.lblLOChange.text = "CHANGE".localize

        self.btnContinue.setTitle("Continue".localize, for: .normal)
    
    }
    func setUI(){
        
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwChange.setCornerRadiusBoarder(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 8)
        self.vwHeader.setviewbottomShadow()

        self.vwContinue.setButtonView(vwOuter : self.vwContinue , vwImage : self.vwImgContinue, btn: self.btnContinue )
        
        
        self.tblCart.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        //
        
        self.removeAllData()
        self.callWsForGetCartCheckout()
        
        
        //self.tblCart.reloadData()
        self.lblOffer.isHidden = true
        self.lblOfferTitle.isHidden = true
        
    }
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnContinueAction(_ sender: Any) {
        self.view.endEditing(true)
        //
        
        print("strDeliveryAddressID is \(self.strDeliveryAddressID)")
        print("strRestaurantId is  \(self.strRestaurantId)")
        print("objAppShareData.strPromoCodeId is  \(objAppShareData.strPromoCodeId)")
        print("objAppShareData.strPaymentMethod is  \(objAppShareData.strPaymentMethod)")
        print("objAppShareData.strCardId is  \(objAppShareData.strCardId)")
        
        
        if self.strDeliveryAddressID == ""{
            objAlert.showAlert(message: "Please_select_delivery_address".localize, title: kAlert.localize, controller: self)
        }else{
            self.callWsForPlaceOrder()
            
        }
        
    }
    
    @IBAction func btnChangeAddress(_ sender: Any) {
        self.view.endEditing(true)
        // objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
        
        let sb = UIStoryboard(name: "Restaurant", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "SelectAddressVC") as! SelectAddressVC
        detailVC.strId = self.strDeliveryAddressID
        detailVC.strLoction = self.lblAddress.text ?? "NA"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}


//MARK: - Extension UITableViewDelegate and UITableViewDataSource


extension CheckOutVC : UITableViewDelegate ,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrCartList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tblCart.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as!MenuCell
          
        if self.arrCartList.count > 0 {
            
        
        let obj = self.arrCartList[indexPath.row]
        
        cell.cartListCell(obj: obj )
        
        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self,action:#selector(buttonAddClicked), for: .touchUpInside)
        cell.btnSubstract.tag = indexPath.row
        cell.btnSubstract.addTarget(self,action:#selector(buttonSubstractClicked), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let obj = self.arrCartList[indexPath.row]


        // TODO: For UnfollowAction
        let UnfollowAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlert.localize, message: "Are_you_sure_you_want_to_delete_this_item?".localize, controller: self) {
                self.callWsForDeleteCart(restaurantId : String(obj.strRestaurantID) , menuId : String(obj.strMenuID) )
            }
        })

//        UnfollowAction.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        UnfollowAction.image = UIImage(named: "delete_ico_red")
        /// UnfollowAction.title = "Unfollow"

        UnfollowAction.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        UnfollowAction.image = UIImage(named: "delete_ico_red")

        return UISwipeActionsConfiguration(actions: [UnfollowAction])
    }
    
    
    @objc func buttonAddClicked(sender:UIButton) {
        if self.arrCartList.count == 0{
            
        }else{
            let obj = self.arrCartList[sender.tag]
            self.strQuantity = (Int(obj.strQuantity) ?? 0) + 1
            self.strMenuId = obj.strMenuID
            print("obj.strQuantity is \(obj.strQuantity)")
            print("obj.strMenuID is \(obj.strMenuID)")
            
            self.callWsForAddUpdateCart()
        }
    }
    
    @objc func buttonSubstractClicked(sender:UIButton) {
//        let obj = self.arrCartList[sender.tag]
//        self.strQuantity = (Int(obj.strQuantity) ?? 0) - 1
//        self.strMenuId = obj.strMenuID
//        print("obj.strQuantity is \(obj.strQuantity)")
//        print("obj.strMenuID is \(obj.strMenuID)")
//        self.callWsForAddUpdateCart()
        if self.arrCartList.count == 0{
            
        }else{
          //  objWebServiceManager.StartIndicator()
            let obj = self.arrCartList[sender.tag]
              if obj.strQuantity == "1" || obj.strQuantity > "1"{
               print("obj.strQuantity is i or more then 1 -> \(obj.strQuantity)")
                  self.strQuantity = (Int(obj.strQuantity) ?? 0) - 1
                  self.strMenuId = obj.strMenuID
               self.callWsForAddUpdateCart()

           }else{
               print("obj.strQuantity is less then 1 -> \(obj.strQuantity)")
           }
        }
    }
}

//MARK: - Api Calling

extension CheckOutVC {
    // TODO: Webservice For get Cart Checkout
    
    func callWsForGetCartCheckout(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param =  [:] as [String : Any]
        var strWsUrl = ""
        
        if strNextPageUrl == ""
        {
            strWsUrl  = WsUrl.getCartCheckout
            param = [
                WsParam.limit: self.limit,
                WsParam.offset: self.offset,
                WsParam.restaurantId: self.strRestaurantId,
                WsParam.search: "",
                WsParam.promoCodeId: objAppShareData.strPromoCodeId
                
            ] as [String : Any]
        }
        else
        {
            strWsUrl = strNextPageUrl
        }
        
        print(param)
        
        objWebServiceManager.requestGet(strURL: strWsUrl  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
            
            //        objWebServiceManager.requestGet(strURL:WsUrl.getCartCheckout+"limit="+String(self.limit)+"&offset="+String(self.offset)+"&search="+self.strSearchText+"&promo_code_id="+objAppShareData.strPromoCodeId+"&restaurant_id="+self.strRestaurantId ,Queryparams: [:], body: nil, strCustomValidation: "", success: {response in
            //
            
            print(response)
            
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                
                let dic  = response["data"] as? [String:Any]
                
                if  let  dataFound = dic?["data_found"] as? Int  {
                    if dataFound == 1 {
                        //  self.vwNoRecord.isHidden = true
                        self.tblCart.isHidden = false
                        self.vwChange.isHidden = false
                        
                    }else{
                        // self.vwNoRecord.isHidden = false
                        self.tblCart.isHidden = true
                        self.vwChange.isHidden = true
                        objAppShareData.strCardId = ""
                        objAppShareData.strPaymentMethod = ""
                        objAppShareData.strPromoCodeId = ""
                        objAppShareData.strOfferTitle = ""
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
                
                self.totalRecords = Int(dic!["total_records"] as? String ?? "") ?? 0
                
                
                if   let paging  = dic?["paging"] as? [String:Any]
                {
                    if let strNext  = paging["next"] as? String
                    {
                        self.strNextPageUrl = strNext
                    }
                }
                
                if let arrReviewData = dic?["cart_list"] as? [[String: Any]]{
                    self.arrCartList.removeAll()
                     self.limit = 100
                    self.offset = 0
                    for dictListData in arrReviewData
                    {
                        let objListData = CartModel.init(dict: dictListData)
                        self.arrCartList.append(objListData)
                    }
                    print("self.arrCartList.count is \(self.arrCartList.count)")
                }
                //////
                else{
                    self.navigationController?.popViewController(animated: true)
                    objAppShareData.strCardId = ""
                    objAppShareData.strPaymentMethod = ""
                    objAppShareData.strPromoCodeId = ""
                    objAppShareData.strOfferTitle = ""
                }
                /////
                if let restaurantDetail = dic?["cart_bill_detail"] as? [String:Any]{
                    
                    self.loadRestaurantListDetail(dict : restaurantDetail)
                }
                
                
//                if objAppShareData.isFromSelectAddress == true {
//                    self.strDeliveryAddressID = objAppShareData.deliveryAddressId
//                    self.lblAddress.text =  objAppShareData.strCurrentLoction
//                    objAppShareData.isFromSelectAddress = false
//                }else {
                    
                    if let addressDetail = dic?["delivery_address"] as? [String:Any]{
                        
                        if let address = addressDetail["address"]as? String{
                            self.lblAddress.text =  address
                        }else{
                            //
                            self.lblAddress.text = "Please_select_your_address".localize
                        }
                        
                        if let AddressID  = addressDetail["customerDeliveryAddressID"]as? String{
                            self.strDeliveryAddressID = AddressID
                        }else  if let AddressID  = addressDetail["customerDeliveryAddressID"]as? Int {
                            self.strDeliveryAddressID =  String(AddressID)
                        }
                        
                    }else {
                        self.strDeliveryAddressID = ""
                        self.lblAddress.text = "Please_select_your_address".localize
                    }
              //  }
                
                if self.arrCartList.count == 0{
                    self.navigationController?.popViewController(animated: false)
                    objAppShareData.strCardId = ""
                    objAppShareData.strPaymentMethod = ""
                    objAppShareData.strPromoCodeId = ""
                    objAppShareData.strOfferTitle = ""
                    
                }
                
                self.tblCart.reloadData()
                
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
    
    // TODO: Webservice For Add Update Cart
    
    func callWsForAddUpdateCart(){
        
        if !objWebServiceManager.isNetworkAvailable(){
             objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        let quantity = String(self.strQuantity)
        param = [
            WsParam.restaurantId: self.strRestaurantId,
            WsParam.menuId: self.strMenuId,
            WsParam.quantity: quantity
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.cartAddUpdate, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
             objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            var MenuNotExit = 00
            
            if status == "success"{
                self.removeAllData()
                self.callWsForGetCartCheckout()
            }
            else
            {
                if let errordata = response["error_type"] as? [String:Any]{
                  if let distance = errordata["menu_not_exist"] as? Int{
                      MenuNotExit = distance
                    }
                  }
                  if MenuNotExit == 1{
                      objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: kAlert.localize, message: message ?? "", controller: self) {
                        self.callWsForGetCartCheckout()
                      }
                  }else{
                      objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
                  }
            }
        }, failure: { (error) in
            print(error)
             objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    
    func loadRestaurantListDetail(dict : [String:Any]){
        
        
        self.lblRestaurantChargeTitle.isHidden = true
        self.lblRestaurantCharges.isHidden = true
        
        
        if let totalAmount = dict["total_amount"]as? String{
            
            self.lblTotalItemPrice.text = "$" + totalAmount
            self.strTotalAmount = totalAmount
        }
        if let commissionAmount = dict["commission_amount"]as? String{
            self.lblRestaurantCharges.text = "$" + commissionAmount
        }
        
        if let shippingPrice = dict["shipping_price"]as? String{
            self.lblDeliveryFee.text = "$" + shippingPrice
        }else  if let shippingPrice = dict["shipping_price"]as? Int {
            self.lblDeliveryFee.text = "$" + String(shippingPrice)
        }
        
        
        
        if let total = dict["grand_total"]as? String{
            self.lblPay.text = "$" + total
        }
        
        
        if let discountAmount = dict["discount_amount"]as? String{
            self.strDiscountAccount = discountAmount
            
            if discountAmount == "0"{
                self.lblOffer.isHidden = true
                self.lblOfferTitle.isHidden = true
                
            }else{
                self.lblOffer.isHidden = false
                self.lblOfferTitle.isHidden = false
                
                self.lblOffer.text = "-$" + discountAmount
                self.lblOfferTitle.text = objAppShareData.strOfferTitle
                
            }
        }
        
        
    }
    
    // TODO: Webservice For delete Cart
    
    func callWsForDeleteCart(restaurantId : String , menuId : String ){
        
        
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            
            return
        }
        
        objWebServiceManager.StartIndicator()
        
        
        var strWsUrl = ""
        
        strWsUrl  =   WsUrl.deleteCart  +  restaurantId + "/"  + menuId
        
        print("strWsUrl is \(strWsUrl)")
        
        objWebServiceManager.requestDELETE(strURL: strWsUrl, Queryparams: nil , body: nil , strCustomValidation: "", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                self.removeAllData()
                self.callWsForGetCartCheckout()
                
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
    
    func callWsForClearCart(restaurantId : String ){
    
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //objWebServiceManager.StartIndicator()
        
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
                self.navigationController?.popViewController(animated: true)
                
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
        })
    }
    
    // TODO: Webservice For Place Order
    
    func callWsForPlaceOrder(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        var param: [String: Any] = [:]
        
        param = [
            WsParam.customerDeliveryAddressId: self.strDeliveryAddressID ,
            WsParam.restaurantId: self.strRestaurantId,
            WsParam.promoCodeId: objAppShareData.strPromoCodeId,
            WsParam.cardId: objAppShareData.strCardId,
            WsParam.paymentMode: objAppShareData.strPaymentMethod
        ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.placeOrder, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            var MenuNotExit = 00
            
            if status == "success"{
                objAppShareData.strCardId = ""
                objAppShareData.strPaymentMethod = ""
                objAppShareData.strPromoCodeId = ""
                objAppShareData.strOfferTitle = ""
                
                //  self.updateAlert(msg: message ?? "")
                let sb = UIStoryboard(name: "Restaurant", bundle: nil)
                let detailVC = sb.instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationVC
                let dict  = response["data"] as? [String:Any]
                if let total = dict?["orderID"]as? String{
                    detailVC.strOrderId = total
                }else if let total = dict?["orderID"]as? Int{
                    detailVC.strOrderId = "\(total)"
                }
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            else
            {
                let errorType = response["error_type"] as? String ??  ""
                                
                if errorType == "menu_not_exist"{
                      objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: kAlert.localize, message: message ?? "", controller: self) {
                            self.navigationController?.popViewController(animated: true)
                      }
                }else
                if errorType == "response_no_service_available"{
                    objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: kAlert.localize, message: message ?? "", controller: self) {
                        self.lblAddress.text = "Please_select_your_address".localize
                        self.strDeliveryAddressID  = ""
                        self.lblDeliveryFee.text = "$" +  "5"
                        
                        let discount = "5"
                        
                        let myTotalAmount = (self.strTotalAmount as NSString).floatValue
                        let myDeliveryFee = (discount as NSString).floatValue
                        let MyDiscountAmount = (self.strDiscountAccount as NSString).floatValue
                        print(myTotalAmount)
                        print(myDeliveryFee)
                        print(MyDiscountAmount)

                        let totalPay = myTotalAmount + myDeliveryFee - MyDiscountAmount
                        
                        print(totalPay)
                        self.lblPay.text = "$" + String(totalPay)
                        
                    }
                }else if errorType == "restaurant_closed"{
                    objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: kAlert.localize, message: message ?? "", controller: self) {
                        self.callWsForClearCart(restaurantId: self.strRestaurantId)
                        //self.navigationController?.popViewController(animated: true)
                    }
                }else if errorType == "empty_cart"{
                    objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: kAlert.localize, message: message ?? "", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                  else{
                        objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
                  }
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
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
                
//                let alert = UIAlertController(title:kAlert.localize , message:message ?? "", preferredStyle: UIAlertController.Style.alert)
//                let okAction = UIAlertAction(title:"Ok".localize, style: UIAlertAction.Style.default) {
//                    UIAlertAction in
//                    self.removeAllData()
//                    self.callWsForGetCartCheckout()
//
//                }
//                alert.addAction(okAction)
//                self.present(alert, animated: true, completion: nil)
//
            self.callWsForGetCartCheckout()

                
            }else{
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
                
                
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
    
    
    
    func updateAlert(msg : String){
        let alert = UIAlertController(title: "Success".localize, message: msg , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            let sb = UIStoryboard(name: "Restaurant", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "ConfirmationVC") as! ConfirmationVC
            self.navigationController?.pushViewController(detailVC, animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
/*
//MARK:- Pagination
extension CheckOutVC {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDataLoading = false
    }
    

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y < 0 {
            print("up")
        }else{
            if ((tblCart.contentOffset.y + tblCart.frame.size.height) >= tblCart.contentSize.height)
            {
                if !isDataLoading{
                    isDataLoading = true
                    
                    self.offset = self.offset+self.limit
                    
                    if arrCartList.count != totalRecords {
                        print("self.arrBookingList count is \(self.arrCartList.count)")
                        print("self.totalRecords is \(self.totalRecords)")
                        
                        self.callWsForGetCartCheckout()
                        
                    }else {
                        print("All records fetched")
                    }
                }
            }
        }
    }
}
*/
