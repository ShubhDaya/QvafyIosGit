//
//  UserRoleDriverVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 09/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class UserRoleDriverVC: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var vwFrist: UIView!
    @IBOutlet weak var vwSecond: UIView!
    @IBOutlet weak var imgCheck1: UIImageView!
    @IBOutlet weak var imgCheck2: UIImageView!
 
    @IBOutlet weak var vwBack: UIView!
        
    // Localization outlets -
    
    @IBOutlet weak var lblUserRole: UILabel!
    @IBOutlet weak var lblHeaderText: UILabel!
    @IBOutlet weak var lblFrist: UILabel!
    @IBOutlet weak var lblSecond: UILabel!
    
    
    //MARK: - Variables
    
    var strUserType:String = ""
    var isFromLogin:Bool = false
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        
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
        
        self.strUserType = "3"
        
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
            objAlert.showAlert(message: "Please_select_driver".localize, title: kAlert.localize, controller: self)
        }else{
            self.callWsForUserDriverRoll()
        }
    }
}

extension UserRoleDriverVC {
    
    func callWsForUserDriverRoll(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        
        
        param = [
            WsParam.driverType: self.strUserType
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.driverType, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                let dic  = response["data"] as? [String:Any]
                
                let user_details  = dic!["user_detail"] as? [String:Any]
                objAppShareData.saveDataInDeviceLogin(dict: user_details!)

                
                if  let  userRole = user_details?["role"] as? String  {
                    if userRole == "2"{
                        self.NavigateToBasicInfo()
                    }else{
                        self.NavigationToVehicleRole()
                    }
                    
                    UserDefaults.standard.setValue(userRole, forKey: UserDefaults.KeysDefault.kRole)
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
    
    func NavigationToVehicleRole(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UserRoleVehicleVC") as! UserRoleVehicleVC
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func NavigateToBasicInfo(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "BasicInfoVC") as! BasicInfoVC
        detailVC.strDriverType = "1"
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    //MARK: Localization Method -
    func Localization(){
        self.lblHeaderText.text = "Contrary_to_popular_belief,_Lorem_ipsum_is_not_simply_random_text.".localize
        self.lblFrist.text = "Food_Delivery".localize
        self.lblSecond.text = "Taxi_Driver".localize
        self.lblUserRole.text = "User_Role".localize
       
     
    }
    
}

