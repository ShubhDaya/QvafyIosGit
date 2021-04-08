//
//  TaxiDriverProfileVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 20/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import HCSStarRatingView

class TaxiDriverProfileVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgStatus: UIImageView!
    @IBOutlet weak var imgLicense: UIImageView!
    @IBOutlet weak var imgRegistration: UIImageView!
    @IBOutlet weak var imgStatusLicense: UIImageView!
    @IBOutlet weak var imgStatusRegistration: UIImageView!
    @IBOutlet weak var imgOnline: UIImageView!
    @IBOutlet weak var lblFullName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblDialCode: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblVehicleNumber: UILabel!
    @IBOutlet weak var lblVehicleType: UILabel!
    @IBOutlet weak var lblMake: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblBasicInfo: UILabel!
    @IBOutlet weak var lblVehicleInfo: UILabel!
    @IBOutlet weak var btnVehicleInfo: UIButton!
    @IBOutlet weak var btnBasicInfo: UIButton!
    @IBOutlet weak var btnOnline: UIButton!
    @IBOutlet weak var vwRating: HCSStarRatingView!
    @IBOutlet weak var vwDotted: UIView!
    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    @IBOutlet weak var vwOnline: UIView!
    @IBOutlet weak var vwProfile: UIView!
    @IBOutlet weak var vwLicense: UIView!
    @IBOutlet weak var vwRegistration: UIView!
    @IBOutlet weak var vwBasicInfo: UIView!
    @IBOutlet weak var vwVehicleInfo: UIView!
    @IBOutlet weak var vwStatus: UIView!
    @IBOutlet weak var lblChatCount: UILabel!
    @IBOutlet weak var imgGender: UIImageView!
    
    // localization Outlets -
    @IBOutlet weak var lblLocLicense: UILabel!
    @IBOutlet weak var lblMyProfileHeader: UILabel!
    @IBOutlet weak var lblEdit: UILabel!
    @IBOutlet weak var lblLocYear: UILabel!
    @IBOutlet weak var lblLocMake: UILabel!
    @IBOutlet weak var lblLocModelNumber: UILabel!
    @IBOutlet weak var lblLocVehicleNumber: UILabel!
    @IBOutlet weak var lblLocVehicleType: UILabel!
    @IBOutlet weak var lblLocRegistration: UILabel!
    @IBOutlet weak var lblLocRegistrationEdit: UILabel!
    
    //MARK: - Varibles
    var userDetail = userDetailModel(dict: [:])
    var isOnline = "2"
    var strProfile = ""
    var strRegistration = ""
    var strLicense = ""
    var isLicenseVerify = ""
    var isRegistrationVerify = ""
     var isFromForgroundNotification = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        btnVehicleInfo.titleLabel?.numberOfLines = 1
        btnVehicleInfo.titleLabel?.adjustsFontSizeToFitWidth = true
        btnVehicleInfo.titleLabel?.lineBreakMode = .byClipping //<-- MAGIC LINE
        btnBasicInfo.titleLabel?.numberOfLines = 1
        btnBasicInfo.titleLabel?.adjustsFontSizeToFitWidth = true
        btnBasicInfo.titleLabel?.lineBreakMode = .byClipping //<-- MAGIC LINE
        self.vwBasicInfo.isHidden = false
        self.vwVehicleInfo.isHidden = true
        self.vwStatus.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //  self.tabBarController?.tabBar.isHidden = false
        self.localization()
        self.BasicVehicleTextManage()
        self.setUI()
         objAppShareData.isOnDriverProfileScreen = true
        if  objAppShareData.isFromZoom == true {
            objAppShareData.isFromZoom = false
        }else{
            self.callWsForGetTexiDriverProfile()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "refreshUI"), object: nil, queue: nil) { [weak self](Notification) in
            self?.isFromForgroundNotification = true
            self?.callWsForGetTexiDriverProfile()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI) , name: NSNotification.Name(rawValue: "didBecomeActive"), object: nil)
    }
    
    @objc func updateUI(){
        self.isFromForgroundNotification = true
        self.callWsForGetTexiDriverProfile()
        
    }
  
    
    
    override func viewWillDisappear(_ animated: Bool) {
               super.viewWillDisappear(animated)
               objAppShareData.isOnDriverProfileScreen = false
        NotificationCenter.default.removeObserver(self)
        self.isFromForgroundNotification = false
           }
    
    func setUI(){
        
        self.lblChatCount.layer.cornerRadius = self.lblChatCount.frame.height/2
        self.lblChatCount.clipsToBounds = true
         objAppShareData.showChatCountFromFirebase(lbl: self.lblChatCount)
        self.vwDotted.creatDashedLine(view: vwDotted)
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwProfile.setCornerRadius(radius: 12)
        self.vwRegistration.setCornerRadius(radius: 12)
        self.vwLicense.setCornerRadius(radius: 12)
        self.vwStatus.setCornerRadius(radius: 12)
        
        //          self.vwProfile.setProfileVerifyView(vwOuter: self.vwProfile, img: self.imgProfile)
        //           self.vwEdit.setButtonView(vwOuter : self.vwEdit , vwImage : self.vwImgEdit, btn: self.btnEdit )
        
        // deepak new Testing
        if objAppShareData.isDriverProfile == true {
        self.showBasicInfo()

        objAppShareData.isDriverProfile = false
        }
        // deepak new Testing
        
    }
    
    
   
    
    
    func BasicVehicleTextManage(){
        
        let selectedlanguage =  UserDefaults.standard.string(forKey: "Selectdlanguage")
        if self.vwBasicInfo.isHidden == false {
            if selectedlanguage  == "es"{
                btnBasicInfo.titleLabel?.font =  UIFont(name: "Poppins-SemiBold", size: 18.3)
               btnVehicleInfo.titleLabel?.font =  UIFont(name: "Poppins-Medium", size: 15)
            }else if selectedlanguage == "en"{
                btnBasicInfo.titleLabel?.font =  UIFont(name: "Poppins-SemiBold", size: 18.3)
               btnVehicleInfo.titleLabel?.font =  UIFont(name: "Poppins-Medium", size: 15)
            }
        }else if self.vwVehicleInfo.isHidden == false {
            if selectedlanguage  == "es"{
                btnVehicleInfo.titleLabel?.font =  UIFont(name: "Poppins-SemiBold", size: 18.3)
               btnBasicInfo.titleLabel?.font =  UIFont(name: "Poppins-Medium", size: 15)
            }else if selectedlanguage == "en"{
                btnVehicleInfo.titleLabel?.font =  UIFont(name: "Poppins-SemiBold", size: 18.3)
               btnBasicInfo.titleLabel?.font =  UIFont(name: "Poppins-Medium", size: 15)
            }
        }
        
    }
    
    func localization(){
        self.lblMyProfileHeader.text = "My_Profile".localize

        self.lblLocLicense.text = "License".localize

        self.lblEdit.text = "Edit".localize

        self.lblLocYear.text = "Year".localize

        self.lblLocMake.text = "Make".localize

        self.lblLocModelNumber.text = "Model_Number".localize
        
        self.lblLocVehicleNumber.text = "Vehicle_Number".localize

        self.lblLocVehicleType.text = "Vehicle_Type".localize
        self.lblLocRegistration.text = "Registration".localize

        self.lblLocRegistrationEdit.text = "Edit".localize
        
        self.btnBasicInfo.setTitle("Basic_Info".localize, for: .normal)
        self.btnVehicleInfo.setTitle("Vehicle_Info".localize, for: .normal)
    }
    
    //MARK: - Button Action
    
    @IBAction func btnChatAction(_ sender: Any) {
        self.view.endEditing(true)
       let sb = UIStoryboard(name: "Chat", bundle: nil)
              let detailVC = sb.instantiateViewController(withIdentifier: "ChatHistoryVC") as! ChatHistoryVC
              self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    @IBAction func btnOnlineAction(_ sender: Any) {
        self.view.endEditing(true)
        
        print("self.isOnline is  \(self.isOnline)")
        
        if self.isOnline == "2" {
            callWsForOnline(strOnline : "1" )
            
        }else{
            callWsForOnline(strOnline : "2" )
        }
    }
    
    @IBAction func btnRatingListAction(_ sender: Any) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "TaxiDProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ReviewListVC") as! ReviewListVC
        //  detailVC.strUserType = "2"
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    @IBAction func btnZoomAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "TaxiDProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ZoomImageVC") as! ZoomImageVC
        //  detailVC.strUserType = "2"
        
        if sender.tag == 0 {
            detailVC.strUrl = self.strLicense
        }else if sender.tag == 1 {
            detailVC.strUrl = self.strRegistration
        }else if sender.tag == 2 {
            detailVC.strUrl = self.strProfile
        }
        
        detailVC.modalPresentationStyle = .fullScreen
        
        //  detailVC.modalPresentationStyle = .overCurrentContext
        self.present(detailVC, animated: false, completion: nil)
        
        // self.navigationController?.pushViewController(detailVC, animated: false)
    }
    
    @IBAction func btnSettingAction(_ sender: Any) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
        detailVC.strUserType = "2"
        self.navigationController?.pushViewController(detailVC, animated: true)
     
    }
    
    @IBAction func btnEditAction(_ sender: Any) {
        self.view.endEditing(true)
        
        let sb = UIStoryboard(name: "TaxiDProfile", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "TaxiDriverEditProfileVC") as! TaxiDriverEditProfileVC
        detailVC.userDetail = self.userDetail
        detailVC.isFormFoodDriver = false
        self.navigationController?.pushViewController(detailVC, animated: true)
   
    }
    @IBAction func btnBasicInfoAction(_ sender: Any) {
        self.view.endEditing(true)
        
        // deepak new Testing
        self.showBasicInfo()
        // deepak new Testing
   
    }
    
    
    
    // deepak new Testing
    func showBasicInfo(){
    let selectedlanguage = UserDefaults.standard.string(forKey: "Selectdlanguage")

    self.vwVehicleInfo.isHidden = true
    self.vwBasicInfo.isHidden = false

    if selectedlanguage == "es"{
    btnBasicInfo.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18.3)
    btnVehicleInfo.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
    }else if selectedlanguage == "en"{
    btnBasicInfo.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 18.3)
    btnVehicleInfo.titleLabel?.font = UIFont(name: "Poppins-Medium", size: 15)
    }

    self.btnBasicInfo.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1), for: .normal)
    self.btnVehicleInfo.setTitleColor(#colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1), for: .normal)
    self.lblBasicInfo.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
    self.lblVehicleInfo.backgroundColor = UIColor.clear

    // self.btnBasicInfo.setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.Low), for: .vertical);
    // self.btnVehicleInfo.setContentHuggingPriority(UILayoutPriority(rawValue: UILayoutPriority.Low52), for: .vertical);
    }
    
    @IBAction func btnVehicleInfoAction(_ sender: Any) {
        self.view.endEditing(true)
        
        let selectedlanguage =  UserDefaults.standard.string(forKey: "Selectdlanguage")
         if selectedlanguage  == "es"{
            btnBasicInfo.titleLabel?.font =  UIFont(name: "Poppins-Medium", size: 15)
            btnVehicleInfo.titleLabel?.font =  UIFont(name: "Poppins-SemiBold", size: 18.3)
         }else if selectedlanguage == "en"{
            btnBasicInfo.titleLabel?.font =  UIFont(name: "Poppins-Medium", size: 15)
            btnVehicleInfo.titleLabel?.font =  UIFont(name: "Poppins-SemiBold", size: 18.3)
         }

        self.btnVehicleInfo.setTitleColor(#colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1), for: .normal)
        self.btnBasicInfo.setTitleColor(#colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5098039216, alpha: 1), for: .normal)
        self.lblVehicleInfo.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
        self.lblBasicInfo.backgroundColor = UIColor.clear
        self.vwVehicleInfo.isHidden = false
        self.vwBasicInfo.isHidden = true
    }
}

extension TaxiDriverProfileVC {
    
    // TODO: Webservice For Online
    
    func callWsForOnline(strOnline : String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        // objWebServiceManager.StartIndicator()
        
        var param = [String:Any]()
        param = [ "online_status": strOnline]
        print(param)
        
        objWebServiceManager.requestPut(strURL: WsUrl.setOnlineStatus, Queryparams:[:], body:param,strCustomValidation: "", success: {response in
            
            print(response)
            //  objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                self.callWsForGetTexiDriverProfile()
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title: "Alert".localize, controller: self)
            }
            
        }, failure: { (error) in
            print(error)
            //   objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title:"Alert".localize, controller: self)
            
        })
    }
    
    
    // TODO: Webservice For get Texi Drriver Profile
    func callWsForGetTexiDriverProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
       // objWebServiceManager.StartIndicator()
        if  self.isFromForgroundNotification != true{
                     objWebServiceManager.StartIndicator()
                     }
        
        objWebServiceManager.requestGet(strURL: WsUrl.getDriverDetails  ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                
                if objAppShareData.isFromBannerNotification == true {
                    objAppShareData.resetBannarData()
                }
                
                let dict  = response["data"] as? [String:Any]
                
                if let driverData = dict?["driver_details"] as? [String:Any]{
                    
                    
                    self.userDetail = userDetailModel.init(dict: driverData )
                    self.loadData(dict : driverData)
                    
                }
                
                
                if let vehicleData = dict?["vehicle_detail"] as? [String:Any]{
                    
                    
                    if let year = vehicleData["vehicle_year"]as? String{
                        self.lblYear.text = year
                    }
                    if let type = vehicleData["vehicle_type"]as? String{
                        self.lblVehicleType.text = type
                    }
                    if let number = vehicleData["vehicle_number"]as? String{
                        self.lblVehicleNumber.text = number
                    }
                    if let make = vehicleData["make"]as? String{
                        self.lblMake.text = make
                    }
                    if let model = vehicleData["model_number"]as? String{
                        self.lblModel.text = model
                    }
                    
                    if let license = vehicleData["license"]as? String {
                        self.strLicense = license
                        
                        if license != "" {
                            let url = URL(string: license)
                            self.imgLicense.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "document_placeholder_img"))
                        }
                    }
                    
                    
                    if let registration = vehicleData["registration"]as? String {
                        self.strRegistration =  registration
                        
                        if registration != "" {
                            let url = URL(string: registration)
                            self.imgRegistration.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "document_placeholder_img"))
                        }
                    }
                    
                    
                    if let licenseVerify = vehicleData["license_verify"]as? String{
                        self.isLicenseVerify = licenseVerify
                        
                    }
                    
                    if let registrationVerify = vehicleData["registration_verify"]as? String{
                        self.isRegistrationVerify = registrationVerify
                    }
                    
                    self.checkVerifyStatus()
                    objAppShareData.dictVichleInfo = vehicleData
                   // AppShareData.sharedObject().dictVichleInfo = param

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
        
        self.lblFullName.text  = userDetail.strFullName.capitalizingFirstLetter()
        
        
        self.strProfile = userDetail.strAvatar
        
        if self.strProfile != "" {
            let url = URL(string: self.strProfile)
            self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profile_placeholder_img"))
        }else{
            self.imgProfile.image = UIImage.init(named: "profile_placeholder_img")
        }
        
        
           
            let ratingData = Double(userDetail.strAvgRating)
            self.vwRating.value  = CGFloat(ratingData!)
       // self.lblRating.text = "(" + userDetail.strAvgRating + ")"
        let string = NSString(string: userDetail.strAvgRating)
              self.lblRating.text = "(" +  String(string.doubleValue) + ")"
        
        print("online in api \(userDetail.strIsOnline)")
            self.isOnline = userDetail.strIsOnline
            
            if userDetail.strIsOnline == "2" {
//                self.btnOnline.setTitle("OFFLINE", for: .normal)
//                self.vwOnline.setCornerRadBoarder(color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), cornerRadious: 16)
//                self.btnOnline.setTitleColor(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) , for: .normal)
//
                
                
                self.imgOnline.image = UIImage(named: "offline_ico".localize)
                    //#imageLiteral(resourceName: "offline_ico")
                
            }else{
//                self.btnOnline.setTitle("ONLINE", for: .normal)
//                self.vwOnline.setCornerRadBoarder(color: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), cornerRadious: 16)
//                self.btnOnline.setTitleColor(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1) , for: .normal)
//
                self.imgOnline.image = UIImage(named: "online_ico".localize)
                //#imageLiteral(resourceName: "online_ico")

            }
        
        
        
        
        ///////////////////////////////////
        
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
            
            let profilePic = userDetail.strAvatar
            if profilePic != "" {
                let url = URL(string: profilePic)
                self.imgProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "profile_placeholder_img"))
            }else{
                self.imgProfile.image = UIImage.init(named: "profile_placeholder_img")
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshTabbarUserImage"), object: nil, userInfo: nil)
            
            // self.tabBarController?.selectedIndex = 4
        }else{
            self.needToLogout()
            
        }
        
        //  print("email saved in ud in last  \(objAppShareData.UserDetail.strEmail)")
        
        //////////////////////////////////////
    }
    
    func needToLogout(){
        let alert = UIAlertController(title: "Alert".localize, message: "You_need_to_logout_your_account".localize , preferredStyle: UIAlertController.Style.alert)
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
    
    
    func checkVerifyStatus(){
        
        print("self.isLicenseVerify is \(self.isLicenseVerify)")
        print("self.isRegistrationVerify is \(self.isRegistrationVerify)")
        
        ////1=accept,2=pending,3=reject
//        imgStatusLicense: UIImageView!
//        @IBOutlet weak var imgStatusRegistration
        
        if self.isLicenseVerify == "1"{
            self.imgStatusLicense.image = #imageLiteral(resourceName: "verified_ico_green")
        } else if self.isLicenseVerify == "2"{
            self.imgStatusLicense.image = #imageLiteral(resourceName: "document_ico")
        } else if self.isLicenseVerify == "3"{
            self.imgStatusLicense.image = #imageLiteral(resourceName: "alert_ico")
        }
        
        if self.isRegistrationVerify == "1"{
            self.imgStatusRegistration.image = #imageLiteral(resourceName: "verified_ico_green")
        } else if self.isRegistrationVerify == "2"{
            self.imgStatusRegistration.image = #imageLiteral(resourceName: "document_ico")
        } else if self.isRegistrationVerify == "3"{
            self.imgStatusRegistration.image = #imageLiteral(resourceName: "alert_ico")
        }
        
        if self.isLicenseVerify == "1" && self.isRegistrationVerify == "1" {
            self.vwStatus.isHidden = true
            self.imgStatus.image = #imageLiteral(resourceName: "verified_ico_green")
        } else if self.isLicenseVerify == "2" || self.isRegistrationVerify == "2" {
            self.vwStatus.isHidden = false
            self.vwStatus.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.6470588235, blue: 0, alpha: 1)
            self.lblStatus.textColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.imgStatus.image = #imageLiteral(resourceName: "document_ico")
            self.lblStatus.text = "Your_profile_is_under_review.".localize
        }else if self.isLicenseVerify == "3" || self.isRegistrationVerify == "3" {
            self.vwStatus.isHidden = false
            self.vwStatus.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.2980392157, blue: 0.2980392157, alpha: 1)
            self.lblStatus.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.imgStatus.image = #imageLiteral(resourceName: "alert_ico")
            self.lblStatus.text = "Your_profile_is_not_verified,_Please_contact_admin.".localize
        }
    }
}

extension UILayoutPriority {
    static var Low: Float { return 250.0 }
    static var Low53: Float { return 253.0 }
    static var Low52: Float { return 252.0 }

    static var High: Float { return 750.0 }
    static var Required: Float { return 1000.0 }
}
