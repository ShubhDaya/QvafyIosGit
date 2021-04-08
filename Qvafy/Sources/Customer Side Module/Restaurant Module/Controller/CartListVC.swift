//
//  CartListVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 10/08/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class CartListVC: UIViewController {
    
    //MARK: Outlets
    
    @IBOutlet weak var viewResturentName: UIView!
    
    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var vwAddMore: UIView!
    
    @IBOutlet weak var imgCod: UIImageView!
    @IBOutlet weak var imgCraditcard: UIImageView!
    @IBOutlet weak var vwCod: UIView!
    @IBOutlet weak var vwCraditcard: UIView!
    
    @IBOutlet weak var vwPlaceOrder: UIView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOffer: UILabel!
    @IBOutlet weak var btnRemoveCode: UIButton!
    @IBOutlet weak var btnClearCart: UIButton!

    //Localization Outlets -
    
    @IBOutlet weak var lblLOCartHeader: UILabel!
    @IBOutlet weak var lblLOAddMore: UILabel!
    @IBOutlet weak var lblLOForgotSomeDelicus: UILabel!
    @IBOutlet weak var lblLOPayments: UILabel!
    @IBOutlet weak var lblLOCreditCard: UILabel!
    @IBOutlet weak var lblLOCaseONDelivery: UILabel!
    @IBOutlet weak var lblLOIncTaxes: UILabel!
    @IBOutlet weak var lblLOPlaceOrder: UILabel!
    
    @IBOutlet weak var lblResturentName: UILabel!
    
    //MARK: - Variables
    
    var arrCartList:[CartModel] = []
    var strRestaurantId = ""
    var strQuantity:Int = 0
    var strMenuId: String = ""

    // pagination
      var isDataLoading:Bool=false
      var limit:Int=100
      var offset:Int=0
      var totalRecords = Int()
      
      var strNextPageUrl = ""
    
    
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
//self.arrCartList.removeAll()
       
    }
    //MARK: - Custom Functions
    
    func localisation(){
        
        self.lblLOCartHeader.text = "Cart".localize
        self.lblLOAddMore.text = "ADD_MORE".localize
        self.lblLOForgotSomeDelicus.text = "Forgot_something_delicious?".localize
        self.lblLOPayments.text = "Payment".localize
        self.lblLOCreditCard.text = "Credit_Card".localize
        self.lblLOCaseONDelivery.text = "Cash_On_Delivery".localize
        self.lblLOIncTaxes.text = "(Incl_taxes)".localize
        self.lblLOPlaceOrder.text = "Place_Order".localize
        
    }
    
    func setUI(){
        self.vwPlaceOrder.isHidden = true
        self.viewResturentName.setCornerRadiusBoarder(color: #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1), cornerRadious: 4)
        self.vwAddMore.setCornerRadiusBoarder(color: #colorLiteral(red: 0.9058823529, green: 0.9058823529, blue: 0.9058823529, alpha: 1), cornerRadious: 4)
        self.vwPlaceOrder.setCornerRadiusBoarder(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 8)
        self.vwCod.setCornerRadiusBoarder(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 8)
        self.vwCraditcard.setCornerRadiusBoarder(color: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), cornerRadious: 8)
        
        self.tblCart.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        self.tblCart.reloadData()
        
    
        if objAppShareData.strOfferTitle == "" {
        self.lblOffer.text = "Apply_promo_code".localize
        self.btnRemoveCode.isHidden = true
        }else{
        self.lblOffer.text = objAppShareData.strOfferTitle
        self.btnRemoveCode.isHidden = false
        self.btnRemoveCode.titleLabel?.adjustsFontSizeToFitWidth = true
        self.btnRemoveCode.setTitle("Remove_promo_code".localize, for: .normal)
        }
        
        
        if objAppShareData.strCardId == ""{
            self.imgCraditcard.image = #imageLiteral(resourceName: "inactive_dot_ico")
            self.imgCod.image = #imageLiteral(resourceName: "active_dot_ico")
            objAppShareData.strPaymentMethod = "1"
            objAppShareData.strCardId = ""
        }else{
            self.imgCraditcard.image = #imageLiteral(resourceName: "active_dot_ico")
            self.imgCod.image = #imageLiteral(resourceName: "inactive_dot_ico")
        }
        self.callWsForGetCartList()
        
    }
    
    //MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        self.view.endEditing(true)
        
         objAppShareData.strCardId = ""
         objAppShareData.strPaymentMethod = "1"
         objAppShareData.strPromoCodeId = ""
         objAppShareData.strOfferTitle = ""
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddMore(_ sender: Any) {
        self.view.endEditing(true)
        // new clear offer and credit card when tap add more
        objAppShareData.strCardId = ""
        objAppShareData.strPaymentMethod = "1"
        objAppShareData.strPromoCodeId = ""
        objAppShareData.strOfferTitle = ""
        // new
        self.navigationController?.popViewController(animated: false)
        
    }
    
    @IBAction func btnSelectPromoCard(_ sender: Any) {
        self.view.endEditing(true)
     //   objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
        
                let sb = UIStoryboard(name: "Restaurant", bundle: nil)
                let detailVC = sb.instantiateViewController(withIdentifier: "PromoCodeListVC") as! PromoCodeListVC
                self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func btnRemoveCodeAction(_ sender: Any) {
    self.view.endEditing(true)
    objAppShareData.strPromoCodeId = ""
    objAppShareData.strOfferTitle = ""
    self.lblOffer.text = "Apply_promo_code".localize
    self.btnRemoveCode.isHidden = true
    self.callWsForGetCartList()

    }
    
    @IBAction func btnCraditCard(_ sender: Any) {
        self.view.endEditing(true)
        self.imgCod.image = #imageLiteral(resourceName: "inactive_dot_ico")
        self.imgCraditcard.image = #imageLiteral(resourceName: "active_dot_ico")
        
        objAppShareData.strPaymentMethod = "2"
        
      //  objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
                
        let sb = UIStoryboard(name: "Map", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PaymentMethodVC") as! PaymentMethodVC
        objAppShareData.isFromCartList = true
        self.navigationController?.pushViewController(detailVC, animated: true)

        
    }
    @IBAction func btnCOD(_ sender: Any) {
        self.view.endEditing(true)
        self.imgCod.image = #imageLiteral(resourceName: "active_dot_ico")
        self.imgCraditcard.image = #imageLiteral(resourceName: "inactive_dot_ico")
        
        
        objAppShareData.strPaymentMethod = "1"
        objAppShareData.strCardId = ""

    }
    
    
    @IBAction func btnClearCartItem(_ sender: Any) {
        self.view.endEditing(true)
        
        objAlert.showAlertCallBack(alertLeftBtn: "No".localize, alertRightBtn: "Yes".localize, title: kAlert.localize, message: "Are you sure you want to clear cart?".localize, controller: self) {
            self.callWsForDeleteCart(restaurantId:self.strRestaurantId)
        }
    }
    
    
    
    @IBAction func btnPlaceOrder(_ sender: Any) {
        self.view.endEditing(true)
        
        
        if self.imgCod.image == #imageLiteral(resourceName: "active_dot_ico") {
                
        let sb = UIStoryboard(name: "Restaurant", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
        detailVC.strRestaurantId = self.strRestaurantId
        self.navigationController?.pushViewController(detailVC, animated: true)
            
        } else if self.imgCraditcard.image == #imageLiteral(resourceName: "active_dot_ico") {
                      
              let sb = UIStoryboard(name: "Restaurant", bundle: nil)
              let detailVC = sb.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
              detailVC.strRestaurantId = self.strRestaurantId
              self.navigationController?.pushViewController(detailVC, animated: true)
            
              } else {
                   
                
                objAlert.showAlert(message:"Please_select_atleast_one_payment_option".localize, title: kAlert.localize, controller: self)

                   
               }
        
    }
}


//MARK: - Extension UITableViewDelegate and UITableViewDataSource


extension CartListVC : UITableViewDelegate ,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrCartList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tblCart.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as!MenuCell
        
        let obj = self.arrCartList[indexPath.row]
        
         cell.cartListCell(obj: obj )

        cell.btnAdd.tag = indexPath.row
        cell.btnAdd.addTarget(self,action:#selector(buttonAddClicked), for: .touchUpInside)
        cell.btnSubstract.tag = indexPath.row
        cell.btnSubstract.addTarget(self,action:#selector(buttonSubstractClicked), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let obj = self.arrCartList[indexPath.row]


           // TODO: For UnfollowAction
           let UnfollowAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            objAlert.showAlertCallBack(alertLeftBtn: "No", alertRightBtn: "Yes", title: kAlert.localize, message: "Are_you_sure_you_want_to_delete_this_item?".localize, controller: self) {
                self.callWsForDeleteCart(restaurantId : String(obj.strRestaurantID) , menuId : String(obj.strMenuID) )
            }
            
           })

        UnfollowAction.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
       UnfollowAction.image = UIImage(named: "inactive_mail_ico")
        UnfollowAction.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UnfollowAction.image = UIImage(named: "delete_ico_red")
        
           return UISwipeActionsConfiguration(actions: [UnfollowAction])

       }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
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

            
            if self.arrCartList.count == 0{
                
            }else{
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

extension CartListVC {
    // TODO: Webservice For get Cart List
    
    func callWsForGetCartList(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param =  [:] as [String : Any]
     
//        if strNextPageUrl == ""
//          {
//            strWsUrl  = WsUrl.cartList
//            param = [
//                WsParam.limit: self.limit,
//                WsParam.offset: self.offset,
//                WsParam.restaurantId: self.strRestaurantId,
//                WsParam.search: "",
//                WsParam.promoCodeId: objAppShareData.strPromoCodeId
//                ] as [String : Any]
//            print(param)
//            }
//        else
//        {
//            strWsUrl = strNextPageUrl
//        }
        
        param = [
                       WsParam.limit: self.limit,
                       WsParam.offset: self.offset,
                       WsParam.promoCodeId: objAppShareData.strPromoCodeId
                       ] as [String : Any]
        
      //  print(param)
      
        objWebServiceManager.requestGet(strURL: WsUrl.cartList  ,Queryparams: param, body: param, strCustomValidation: "", success: {response in
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
                        self.vwPlaceOrder.isHidden = false
                    }else{
                       // self.vwNoRecord.isHidden = false
                        self.tblCart.isHidden = true
                        self.vwPlaceOrder.isHidden = true
                        objAppShareData.strCardId = ""
                        objAppShareData.strPaymentMethod = "1"
                        objAppShareData.strPromoCodeId = ""
                        objAppShareData.strOfferTitle = ""
                        self.navigationController?.popViewController(animated: false)
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
                    for dictListData in arrReviewData
                    {
                        let objListData = CartModel.init(dict: dictListData)
                        self.arrCartList.append(objListData)
                    }
                    self.strRestaurantId = self.arrCartList[0].strRestaurantID
                    self.lblResturentName.text = self.arrCartList[0].strRestaurantName.capitalizingFirstLetter()
                    print("self.arrCartList.count is \(self.arrCartList.count)")
                }
                
                if let pricingDetail = dic?["pricing_detail"] as? [String:Any]{
                
                                    if let totalAmount = pricingDetail["total_amount"]as? String{
                                        self.lblPrice.text = "$" + totalAmount
                                        self.vwPlaceOrder.isHidden = false
                                         }
                                    if let totalItems = pricingDetail["total_items"]as? String{
                                        // self.lblItemCount.text = totalItems + " ITEM"
                                        
                                        print("totalItems count is \(totalItems)")
                                        
                                        if totalItems == "1"{
                                            self.lblItemCount.text = totalItems + " \("item".localize)"
                                            
                                        }else{
                                            self.lblItemCount.text = totalItems + " \("items".localize)"
                                        }
                                    }
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
                self.arrCartList.removeAll()
                self.callWsForGetCartList()
            }
            else
            {
              if let errordata = response["error_type"] as? [String:Any]{
                if let distance = errordata["menu_not_exist"] as? Int{
                    MenuNotExit = distance
                }
//                let menuNoExist = errordata["menu_not_exist"]
//                MenuNotExit = Int(menuNoExist as! String) ?? 0
//                print(MenuNotExit)
                }
                
                if MenuNotExit == 1{
                    objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: kAlert.localize, message: message ?? "", controller: self) {
                        
                        // pop specific step in stack
//                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
//                           self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                        
                        //
                        
                        // pop specific controller -
//                        for controller in self.navigationController!.viewControllers as Array {
//                            if controller.isKind(of: RestaurantListVC.self) {
//                                self.navigationController!.popToViewController(controller, animated: true)
//                                break
//                            }
//                        }
                        
                        //
                        self.callWsForGetCartList()
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
    
    // TODO: Webservice For delete Cart

    func callWsForDeleteCart(restaurantId : String , menuId : String ){
        
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
          objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            
            return
        }
        
        objWebServiceManager.StartIndicator()
        
        
        var strWsUrl = ""
//        var menuId = self.strMenuId
//        var restaurantId = self.strMenuId

        strWsUrl  =   WsUrl.deleteCart  +  restaurantId + "/"  + menuId
      //  api/v1/cart/:restaurant_id/:menu_id

print("strWsUrl is \(strWsUrl)")
        
        objWebServiceManager.requestDELETE(strURL: strWsUrl, Queryparams: nil , body: nil , strCustomValidation: "", success: { response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                self.arrCartList.removeAll()
                self.callWsForGetCartList()
                
            }else{
                  objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
             objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
        
    }
    
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
                self.arrCartList.removeAll()
                self.callWsForGetCartList()
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
