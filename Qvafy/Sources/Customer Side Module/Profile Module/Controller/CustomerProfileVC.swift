//
//  CustomerProfileVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 14/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class CustomerProfileVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var vwEdit: UIView!
    @IBOutlet weak var vwImgEdit: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwProfile: UIView!
    
    @IBOutlet weak var vwDotted: UIView!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblDialCode: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPastTrips: UILabel!
    @IBOutlet weak var lblPastOrders: UILabel!
    
    @IBOutlet weak var lblPastTripTitle: UILabel!
    @IBOutlet weak var lblPastOrderTitle: UILabel!
    @IBOutlet weak var imgGender: UIImageView!
    //localisation outlets -
    @IBOutlet weak var lblLOHeaderProfile: UILabel!
 
    var userDetail = userDetailModel(dict: [:])
    var strProfile = ""
    var isFromForgroundNotification = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.localisation()
        self.setUI()
        objAppShareData.isOnDriverProfileScreen = true
        if  objAppShareData.isFromZoom == true {
           objAppShareData.isFromZoom = false
       }else{
           self.callWsForGetCustomerProfile()
       }
        
        //New Shubham -
        NotificationCenter.default.addObserver(self, selector: #selector(self.refrershUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
        //
    }
    
    // Shubham
    @objc func refrershUI(){
        self.isFromForgroundNotification = true
        self.callWsForGetCustomerProfile()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
        objAppShareData.isOnDriverProfileScreen = false
        self.isFromForgroundNotification = false

            NotificationCenter.default.removeObserver(self)
        }
    
    // end 
    
    func localisation(){
        self.lblLOHeaderProfile.text = "Profile".localize
        self.btnEdit.setTitle("Edit_Profile".localize, for: .normal)
        
    }
    
    func setUI(){
        self.vwDotted.creatDashedLine(view: vwDotted)
        self.vwProfile.setProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile)
        self.vwEdit.setButtonView(vwOuter : self.vwEdit , vwImage : self.vwImgEdit, btn: self.btnEdit )
        
    }
    
    //MARK: - Button Action
    
    @IBAction func btnSideMenu(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.toggleLeft()
    }
    
    @IBAction func btnEditAction(_ sender: Any) {
        self.view.endEditing(true)
        
        let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CustomerEditProfileVC") as! CustomerEditProfileVC
        detailVC.userDetail = self.userDetail
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    @IBAction func btnPastTrip(_ sender: Any) {
        self.view.endEditing(true)
        self.slideMenuController()?.closeLeft()
        
        let sb = UIStoryboard(name: "PastTrip", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PastTripVC") as! PastTripVC
        detailVC.isFromCustomer = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    @IBAction func btnPastOrder(_ sender: Any) {
        self.view.endEditing(true)
                
        let sb = UIStoryboard(name: "CustomerProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "CustomerPastOrder") as! CustomerPastOrder
        self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    @IBAction func btnZoomAction(_ sender: Any) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "TaxiDProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ZoomImageVC") as! ZoomImageVC
        detailVC.strUrl = self.strProfile
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: false, completion: nil)
        
    }
}


extension CustomerProfileVC {
    
    // TODO: Webservice For get Customer Profile
    func callWsForGetCustomerProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        
        objWebServiceManager.requestGet(strURL: WsUrl.getCustomerDetails  ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
           // let error =  (response["error_type"] as? String)
            
            if status == "success"
            {
                if objAppShareData.isFromBannerNotification == true {
                    objAppShareData.resetBannarData()
                }
                
                let dict  = response["data"] as? [String:Any]
                
                if let customerData = dict?["customer_details"] as? [String:Any]{
                    
                    self.userDetail = userDetailModel.init(dict: customerData )
                    
                    
                    self.loadData(dict : customerData)
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
    
    func loadData(dict : [String:Any]){
        
        print("email saved in ud  first \(objAppShareData.UserDetail.strEmail)")
        print("email in api  \(self.userDetail.strEmail)")
        
        
        print("strAuthtoken saved in ud in first  \(objAppShareData.UserDetail.strAuthtoken)")
        
        print("role saved in ud in first  \(objAppShareData.UserDetail.strRole)")
        print("strProfileComplete saved in ud in first  \(objAppShareData.UserDetail.strProfileComplete)")
        
        
        if self.userDetail.strEmail == objAppShareData.UserDetail.strEmail {
            
            
            
            objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: dict)
            objAppShareData.fetchUserInfoFromAppshareData()
            objAppShareData.saveUserDetailsOnFireBase()
            self.lblEmail.text = userDetail.strEmail
            self.lblFullName.text  = userDetail.strFullName.capitalizingFirstLetter()
            self.lblPhoneNumber.text  = userDetail.strPhoneNumber
            self.lblPastOrders.text  = userDetail.strPastOrdersCount
            self.lblPastTrips.text  = userDetail.strPastTripCount
                        
            if (userDetail.strPastTripCount == "1") || ( userDetail.strPastTripCount == "0" ){
                self.lblPastTripTitle.text = "Past_Trip".localize
                
            }else{
                self.lblPastTripTitle.text = "Past_Trips".localize
            }
            
            if (userDetail.strPastOrdersCount == "1") || ( userDetail.strPastOrdersCount == "0" ){
                self.lblPastOrderTitle.text = "Past_Order".localize
                
            }else{
                self.lblPastOrderTitle.text = "Past_Orders".localize
            }
            
            
            print("strAuthtoken saved in ud in last  \(objAppShareData.UserDetail.strAuthtoken)")
            
            print("email saved in ud in last  \(objAppShareData.UserDetail.strEmail)")
            print("strProfileComplete saved in ud in last  \(objAppShareData.UserDetail.strProfileComplete)")
            
            print("role saved in ud in last  \(objAppShareData.UserDetail.strRole)")
            
            
            if userDetail.strGender == "1"{
                self.lblGender.text  = "Male".localize
                self.imgGender.image = #imageLiteral(resourceName: "male_ico")
            }else if userDetail.strGender == "2" {
                self.lblGender.text  = "Female".localize
                self.imgGender.image = #imageLiteral(resourceName: "female_ico")
            } else {
                self.lblGender.text  = "NA".localize
                self.imgGender.image = #imageLiteral(resourceName: "male_ico")
            }
            
            if     userDetail.strDialCode == ""{
                self.lblDialCode.text = ""
                
            }else{
                self.lblDialCode.text = "\(userDetail.strDialCode) -"
                
                
            }
            
   
            
            self.strProfile = userDetail.strAvatar

            if self.strProfile != "" {
                let url = URL(string: self.strProfile)
                self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "inactive_profile_ico"))
            }else{
                self.imgProfile.image = UIImage.init(named: "inactive_profile_ico")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTabbarUserImage"), object: nil, userInfo: nil)
            
            // self.tabBarController?.selectedIndex = 4
        }else{
            self.needToLogout()
            
        }
 
    }
    
    func needToLogout(){
//        let alert = UIAlertController(title: "Alert", message: SessionExpired , preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            
        let alert = UIAlertController(title: kAlert.localize, message: "You_need_to_logout_your_account".localize , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in

            if !objWebServiceManager.isNetworkAvailable(){
                objWebServiceManager.StopIndicator()
                objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
                return
            }else{
                objAppShareData.callWsLogoutApi()
                
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
