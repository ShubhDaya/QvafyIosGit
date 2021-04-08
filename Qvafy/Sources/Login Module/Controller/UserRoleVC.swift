//
//  UserRoleVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 08/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class UserRoleVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var vwFrist: UIView!
    @IBOutlet weak var vwSecond: UIView!
    @IBOutlet weak var imgCheck1: UIImageView!
    @IBOutlet weak var imgCheck2: UIImageView!
    @IBOutlet weak var lblFrist: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    @IBOutlet weak var vwBack: UIView!
    
    
    //Localization Outlets -
    @IBOutlet weak var lblUserRole: UILabel!
    @IBOutlet weak var lblHeaderText: UILabel!
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblDriver: UILabel!

        
    //MARK: - Variables
    
    var strUserType:String = ""
    var isFromLogin:Bool = false
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
      //  self.callWsForUpdateLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.Localization()
        if self.isFromLogin == true {
            self.vwBack.isHidden = true
        }else{
            self.vwBack.isHidden = true
        }
    }
    //MARK: - Functions
    func setUI(){
        
        self.vwFrist.setViewRole(view: self.vwFrist)
              self.vwSecond.setViewRole(view: self.vwSecond)
        
    }
    
    //MARK: - Button Actions
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.view.endEditing(true)
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFrist(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imgCheck2.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        self.imgCheck1.image = #imageLiteral(resourceName: "active_check_box_ico")
        self.strUserType = "1"
    }
    
    @IBAction func btnSecond(_ sender: UIButton) {
        self.view.endEditing(true)
        self.imgCheck2.image = #imageLiteral(resourceName: "active_check_box_ico")
        self.imgCheck1.image = #imageLiteral(resourceName: "inactive_check_box_ico")
        self.strUserType = "2"
        
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        self.view.endEditing(true)
        if  self.imgCheck1.image != #imageLiteral(resourceName: "active_check_box_ico") && self.imgCheck2.image != #imageLiteral(resourceName: "active_check_box_ico") {
            objAlert.showAlert(message: "Please_select_user_role".localize, title: kAlert.localize, controller: self)
        }else{
            self.callWsForUserRoll()
            
        }
    }
    
}

extension UserRoleVC {
    
    // TODO: Webservice For User Roll

    func callWsForUserRoll(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        param = [
            WsParam.userRole: self.strUserType
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.userRole, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                let dic  = response["data"] as? [String:Any]
                
                let user_details  = dic!["user_detail"] as? [String:Any]
                objAppShareData.saveDataInDeviceLogin(dict: user_details!)
                
                if  let  userRole = user_details?["role"] as? String  {
                    if userRole == "1"{
                        
                        objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details ?? [:])
                        objAppShareData.fetchUserInfoFromAppshareData()
                        objAppShareData.saveUserDetailsOnFireBase()
                         objAppDelegate.observeProductMessages()
                        self.NavigateToGuideVC()
                    }else{
                        self.NavigationToDriverRole()
                    }
                }
            }
            else
            {
                objAlert.showAlert(message:message ?? "", title:kAlert.localize, controller: self)
            }
            
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: kAlert.localize, controller: self)
            
        })
    }
    
    // TODO: Webservice For update location
    

    func callWsForUpdateLocation(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        
        var fullAddress = ""
        var latitude = ""
        var longitude = ""

        if let address = objAppShareData.dictUserLoction["fullAddress"]as? String{
            fullAddress = address
        }
        if let lat = objAppShareData.dictUserLoction["latitude"]as? String{
            latitude = lat
        }
        if let long = objAppShareData.dictUserLoction["longitude"]as? String{
            longitude = long
        }
        
        var param: [String: Any] = [:]
        param = [
            WsParam.address: fullAddress ,
            WsParam.latitude: latitude,
            WsParam.longitude: longitude
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
    
    
    func NavigateToGuideVC(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "GuideVC") as! GuideVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func NavigationToDriverRole(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UserRoleDriverVC") as! UserRoleDriverVC
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        
        
    }
    
    
    func Navigation(){
        if self.imgCheck1.image == #imageLiteral(resourceName: "active_check_box_ico") {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "BasicInfoVC") as! BasicInfoVC
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }else if self.imgCheck2.image == #imageLiteral(resourceName: "active_check_box_ico"){
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let detailVC = sb.instantiateViewController(withIdentifier: "UserRoleDriverVC") as! UserRoleDriverVC
            self.navigationController?.pushViewController(detailVC, animated: true)
            
        }
        
    }

    //MARK: Localization Method -
    func Localization(){
        self.lblHeaderText.text = "There_are_many_variations_of_passages_of_Lorem_Ipsum_available".localize
        self.lblFrist.text = "Customer".localize
        self.lblSecond.text = "Driver".localize
        self.lblUserRole.text = "User_Role".localize
       
     
    }
    
}

