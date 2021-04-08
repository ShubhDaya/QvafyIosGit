//
//  SettingVC.swift
//  Qvafy
//
//  Created by ios-deepak b on 16/07/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class SettingVC: UIViewController ,UITextFieldDelegate{
    
    //MARK: Outlets
    
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var imgToggle: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwNotification: UIView!
    @IBOutlet weak var vwFaq: UIView!
    @IBOutlet weak var vwChangePassword: UIView!
    @IBOutlet weak var vwPolicy: UIView!
    @IBOutlet weak var vwTermCondition: UIView!
    @IBOutlet weak var vwBank: UIView!
    @IBOutlet weak var vwSavedCard: UIView!

    @IBOutlet weak var vwLogout: UIView!
    @IBOutlet weak var vwDotted1: UIView!
    @IBOutlet weak var vwDotted2: UIView!
    @IBOutlet weak var vwDotted3: UIView!
    @IBOutlet weak var vwDotted4: UIView!
    @IBOutlet weak var vwDotted5: UIView!
    @IBOutlet weak var vwDotted6: UIView!
    @IBOutlet weak var vwDotted7: UIView!
    
    @IBOutlet weak var imgDotted6: UIImageView!
    @IBOutlet weak var imgDotted7: UIImageView!

    @IBOutlet weak var vwBlur: UIView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var vwOldPass: UIView!
    @IBOutlet weak var vwNewPass: UIView!
    @IBOutlet weak var vwConfirmPass: UIView!
    @IBOutlet weak var vwDone: UIView!
    @IBOutlet weak var vwImgDone: UIView!
    @IBOutlet weak var btnDone : UIButton!
    @IBOutlet weak var txtOldPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var imgOldPass: UIImageView!
    @IBOutlet weak var imgNewPass: UIImageView!
    @IBOutlet weak var imgConfirmPass: UIImageView!
    
    
    // Localisation Outlets -
    
    @IBOutlet weak var lblLOSettingHeader: UILabel!
    @IBOutlet weak var lblLOSavedCard: UILabel!

    @IBOutlet weak var lblLONotification: UILabel!
    @IBOutlet weak var lblLOBankDetails: UILabel!
    @IBOutlet weak var lblLOChangeLanguage: UILabel!
    @IBOutlet weak var lblLOChangePassword: UILabel!
    @IBOutlet weak var lblLOFAQ: UILabel!
    @IBOutlet weak var lblLOPrivacyPolicy: UILabel!
    @IBOutlet weak var lblLOLogout: UILabel!
    @IBOutlet weak var lblLOTermsCondition: UILabel!
    @IBOutlet weak var lblLOChangePasswordHeader: UILabel!
    @IBOutlet weak var lblLOOldPassword: UILabel!
    @IBOutlet weak var lblLONewPassword: UILabel!
    @IBOutlet weak var lblLOConfirmPassword: UILabel!

    
    
    var strUserType = ""
    var strHowtoWork = ""
    var strPolicy = ""
    var strTermsCondition = ""
    var notificationStatus = ""
    var strStatus = ""
    var arrLanguage:[FilterModel] = []
    //MARK: LifeCycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiDesign()
        self.vwBlur.isHidden = true
        self.loadLanguages()
        self.callWsForGetContent()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.uiDesign()
        self.localization()
        print(self.arrLanguage.count)
       // self.loadLanguages()

        self.notificationStatus = objAppShareData.UserDetail.strPushAlertStatus
                
        if self.notificationStatus == "1"{
            self.imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")

        }else{
            self.imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
        }
        
    }
    func loadLanguages(){
        
        let obj = FilterModel.init(dict: ["businessTypeID": "1","name": "English"])
        let obj1 = FilterModel.init(dict: ["businessTypeID": "2","name": "Spanish"])
        self.arrLanguage.append(obj)
        self.arrLanguage.append(obj1)
    }
    
    func uiDesign(){
        self.vwHeader.setviewbottomShadow()
        self.vwDotted1.creatDashedLine(view: vwDotted1)
        self.vwDotted2.creatDashedLine(view: vwDotted2)
        self.vwDotted3.creatDashedLine(view: vwDotted3)
        self.vwDotted4.creatDashedLine(view: vwDotted4)
        self.vwDotted5.creatDashedLine(view: vwDotted5)
        self.vwDotted6.creatDashedLine(view: vwDotted6)
        self.vwDotted7.creatDashedLine(view: vwDotted7)
        
        self.vwOldPass.setCornerRadiusQwafy(vw: self.vwOldPass)
        self.vwNewPass.setCornerRadiusQwafy(vw: self.vwNewPass)
        self.vwConfirmPass.setCornerRadiusQwafy(vw: self.vwConfirmPass)
        self.vwDone.setButtonView(vwOuter : self.vwDone , vwImage : self.vwImgDone, btn: self.btnDone )
        self.vwBottom.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        
        
        if self.strUserType == "1"{
            self.vwBank.isHidden = true
            self.vwLogout.isHidden = true
            self.vwDotted6.isHidden = true
            self.imgDotted6.isHidden = true
            self.vwSavedCard.isHidden = false
        }else if strUserType == "2"{
            self.vwFaq.isHidden = true
            self.vwDotted7.isHidden = true
            self.imgDotted7.isHidden = true
            self.vwSavedCard.isHidden = true
            
        }else if strUserType == "3"{
            self.vwFaq.isHidden = true
            self.vwDotted7.isHidden = true
            self.imgDotted7.isHidden = true
            self.vwSavedCard.isHidden = true

        }
        
    }
    
    func localization(){
        
        self.lblLOSavedCard.text = "Saved Card".localize
        self.lblLOSettingHeader.text = "Settings".localize
        self.lblLONotification.text = "Notifications".localize
        self.lblLOBankDetails.text = "Bank_Details".localize
        self.lblLOChangeLanguage.text = "Change_Language".localize
        self.lblLOChangePassword.text = "Change_Password".localize
        self.lblLOFAQ.text = "How_to_use_(FAQ)".localize
        self.lblLOTermsCondition.text = "Term_&_Conditions".localize
        self.lblLOPrivacyPolicy.text = "Privacy_Policy".localize
        self.lblLOLogout.text = "Logout".localize
        self.lblLOChangePasswordHeader.text = "Change_Password".localize
        self.lblLOOldPassword.text = "Old_Password".localize
        self.lblLONewPassword.text = "New_Password".localize
        self.lblLOConfirmPassword.text = "Confirm_Password".localize


        self.txtOldPassword.placeholder = "Enter_old_password".localize
        self.txtNewPassword.placeholder = "Enter_new_password".localize
        self.txtConfirmPassword.placeholder = "Confirm_Password".localize
        self.btnDone.setTitle("Done".localize, for: .normal)

        
        self.txtOldPassword.placeholder = "Enter_old_password".localize
        self.txtNewPassword.placeholder = "Enter_new_password".localize
        self.txtConfirmPassword.placeholder = "Enter_confirm_password".localize
       
 
        
    }
    
    
    //MARK: Button Actions
    
    @IBAction func btnBack(_ sender: Any){
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNotification(_ sender: UIButton){
        self.view.endEditing(true)
        
        if self.notificationStatus == "1"{
            self.strStatus = "0"
                   self.callWsForNotificationStatus(strStatus: "0")
               }else{
            self.strStatus = "1"
             self.callWsForNotificationStatus(strStatus: "1")
               }
        
    }
    @IBAction func btnChangeLanguge(_ sender: UIButton){
        self.view.endEditing(true)
      
        let str = "Select_Language".localize
        self.showBotttomSheet(arr: self.arrLanguage,str: str)
        }
    
    
    @IBAction func btnSavedCard(_ sender: UIButton){
        self.view.endEditing(true)
      //  objAlert.showAlert(message: "Under Development", controller: self)
        
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "SavedCardListVC") as! SavedCardListVC
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        }
    
    
    
    @IBAction func btnBank(_ sender: UIButton){
        self.view.endEditing(true)
        
        
        let sb = UIStoryboard(name: "Setting", bundle: nil)

        if objAppShareData.UserDetail.strIsUserCuba == "1" {
            let detailVC = sb.instantiateViewController(withIdentifier: "UpdateBankDetailVC") as! UpdateBankDetailVC
            self.navigationController?.pushViewController(detailVC, animated: true)

        }else{
            
        let detailVC = sb.instantiateViewController(withIdentifier: "UpdateBankAccountVC") as! UpdateBankAccountVC
            self.navigationController?.pushViewController(detailVC, animated: true)

        }
        
    }
    @IBAction func btnFAQ(_ sender: UIButton){
        self.view.endEditing(true)
        
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        detailVC.strURL = self.strHowtoWork
        detailVC.strHeaderText = "FAQ's".localize
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    @IBAction func btnTermsCondition(_ sender: UIButton){
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        detailVC.strURL = self.strTermsCondition
        detailVC.strHeaderText = "Term_&_Conditions".localize
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        
    }
    @IBAction func btnPolicy(_ sender: UIButton){
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Setting", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "PolicyVC") as! PolicyVC
        detailVC.strURL = self.strPolicy
        detailVC.strHeaderText = "Privacy_Policy".localize
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    @IBAction func btnLogout(_ sender: UIButton){
        self.view.endEditing(true)
        self.userLogout()
    }
    @IBAction func btnChangePassword(_ sender: UIButton){
        self.view.endEditing(true)
        
        self.vwBlur.isHidden = false
        self.txtOldPassword.text = ""
        self.txtNewPassword.text = ""
        self.txtConfirmPassword.text = ""
        
    }
    @IBAction func btnCancle(_ sender: UIButton){
        self.view.endEditing(true)
        
        self.resetAll()
    }
    func resetAll(){
        self.vwBlur.isHidden = true
        self.txtOldPassword.isSecureTextEntry = true
        self.txtNewPassword.isSecureTextEntry = true
        self.txtConfirmPassword.isSecureTextEntry = true
        self.imgNewPass.image = #imageLiteral(resourceName: "hide_view_ico")
        self.imgOldPass.image = #imageLiteral(resourceName: "hide_view_ico")
        self.imgConfirmPass.image = #imageLiteral(resourceName: "hide_view_ico")

        self.txtOldPassword.text = ""
        self.txtNewPassword.text = ""
        self.txtConfirmPassword.text = ""
    }
    
    @IBAction func btnDone(_ sender: UIButton){
        self.view.endEditing(true)
        self.validationForChangePassword()
        
    }
    @IBAction func btnOldPassword(_ sender: UIButton){
        if self.imgOldPass.image == #imageLiteral(resourceName: "show_view_ico"){
            self.imgOldPass.image = #imageLiteral(resourceName: "hide_view_ico")
            self.txtOldPassword.isSecureTextEntry = true
        }else{
            self.imgOldPass.image = #imageLiteral(resourceName: "show_view_ico")
            self.txtOldPassword.isSecureTextEntry = false
        }
    }
    @IBAction func btnNewPassword(_ sender: UIButton){
       // self.view.endEditing(true)
        if self.imgNewPass.image == #imageLiteral(resourceName: "show_view_ico"){
            self.imgNewPass.image = #imageLiteral(resourceName: "hide_view_ico")
            self.txtNewPassword.isSecureTextEntry = true
        }else{
            self.imgNewPass.image = #imageLiteral(resourceName: "show_view_ico")
            self.txtNewPassword.isSecureTextEntry = false
        }
    }
    @IBAction func btnConfirmPassword(_ sender: UIButton){
     //   self.view.endEditing(true)
        if self.imgConfirmPass.image == #imageLiteral(resourceName: "show_view_ico"){
            self.imgConfirmPass.image = #imageLiteral(resourceName: "hide_view_ico")
            self.txtConfirmPassword.isSecureTextEntry = true
        }else{
            self.imgConfirmPass.image = #imageLiteral(resourceName: "show_view_ico")
            self.txtConfirmPassword.isSecureTextEntry = false
        }
    }
    
    
    func validationForChangePassword(){
        
        self.txtOldPassword.text = self.txtOldPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtNewPassword.text = self.txtNewPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtConfirmPassword.text = self.txtConfirmPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
        let isNewValidPassword = objValidationManager.ValidPassWord8digit(with: txtNewPassword.text ?? "")
        
        let isOldValidPassword = objValidationManager.ValidPassWord8digit(with: txtOldPassword.text ?? "")

        
        //let isOldValidPassword = objValidationManager.ValidPassWord8digit(with: txtOldPassword.text ?? "")
        if self.txtOldPassword.text?.isEmpty == true{
            objAlert.showAlert(message: BlankOldPassword.localize, title: kAlert.localize, controller: self)
        }else if !isOldValidPassword {
            objAlert.showAlert(message: OldPasswordInvalid.localize, title: kAlert.localize, controller: self)
        }
        else  if self.txtNewPassword.text?.isEmpty == true{
            objAlert.showAlert(message: BlankNewPassword.localize, title: kAlert.localize, controller: self)
        }else if !isNewValidPassword {
            objAlert.showAlert(message: NewPasswordInvalid.localize, title: kAlert.localize, controller: self)
        }
        else if self.txtConfirmPassword.text?.isEmpty == true{
            objAlert.showAlert(message: BlankConfirmPw.localize, title: kAlert.localize, controller: self)
        }
        else if(self.txtNewPassword.text != self.txtConfirmPassword.text){
            objAlert.showAlert(message: ConfirmPassInvalid.localize, title: kAlert.localize, controller: self)
        }
        
        else{
            self.callWsForChangePassword()
        }
        
//        if self.txtOldPassword.text?.isEmpty == true{
//            objAlert.showAlert(message: BlankOldPassword.localize, title: kAlert.localize, controller: self)
//        }else if strOldPassword < 6 {
//            objAlert.showAlert(message: OldPasswordLength.localize, title: kAlert.localize, controller: self)
//        }
//        else  if self.txtNewPassword.text?.isEmpty == true{
//            objAlert.showAlert(message: BlankNewPassword.localize, title: kAlert.localize, controller: self)
//        }
//
//        else if strNewPassword < 6 {
//            objAlert.showAlert(message: NewPasswordLength.localize, title: kAlert.localize, controller: self)
//        }
//        else if self.txtConfirmPassword.text?.isEmpty == true{
//            objAlert.showAlert(message: BlankConfirmPw.localize, title: kAlert.localize, controller: self)
//        }else if strConfirmPassword < 6 {
//            objAlert.showAlert(message: ConfirmPwLength.localize, title: kAlert.localize, controller: self)
//        }
//        else if(self.txtNewPassword.text != self.txtConfirmPassword.text){
//            objAlert.showAlert(message: PasswordMatching.localize, title: kAlert.localize, controller: self)
//        }
//
//        else{
//            self.callWsForChangePassword()
//        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtOldPassword{
//            self.txtOldPassword.isSecureTextEntry = true
//            self.txtNewPassword.isSecureTextEntry = true
//            self.txtConfirmPassword.isSecureTextEntry = true
           // self.txtOldPassword.resignFirstResponder()
//            self.imgOldPass.image = #imageLiteral(resourceName: "hide_view_ico")
//            self.imgNewPass.image = #imageLiteral(resourceName: "hide_view_ico")
//            self.imgConfirmPass.image = #imageLiteral(resourceName: "hide_view_ico")
            
            self.txtNewPassword.becomeFirstResponder()
        }else if textField == self.txtNewPassword{
//            self.txtOldPassword.isSecureTextEntry = true
//            self.txtNewPassword.isSecureTextEntry = true
//            self.txtConfirmPassword.isSecureTextEntry = true
            //self.txtNewPassword.resignFirstResponder()
//            self.imgOldPass.image = #imageLiteral(resourceName: "hide_view_ico")
//            self.imgNewPass.image = #imageLiteral(resourceName: "hide_view_ico")
//            self.imgConfirmPass.image = #imageLiteral(resourceName: "hide_view_ico")
//
            self.txtConfirmPassword.becomeFirstResponder()
        }else if textField == self.txtConfirmPassword{
//            self.txtOldPassword.isSecureTextEntry = true
//            self.txtNewPassword.isSecureTextEntry = true
//            self.txtConfirmPassword.isSecureTextEntry = true
//            self.imgOldPass.image = #imageLiteral(resourceName: "hide_view_ico")
//            self.imgNewPass.image = #imageLiteral(resourceName: "hide_view_ico")
//            self.imgConfirmPass.image = #imageLiteral(resourceName: "hide_view_ico")
            
            self.txtConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == txtOldPassword{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 21{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }else if textField == txtNewPassword{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 21{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }
        else if textField == txtConfirmPassword{
            let maxLength = 20
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            if newString.length == 21{
                //textField.resignFirstResponder()
            }
            return newString.length <= maxLength
        }
       else{
            return true
        }
    }
    
    
    
    func userLogout(){
        let alert = UIAlertController(title:"Alert".localize, message: "Are_you_sure_you_want_to_logout?".localize, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "No".localize, style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes".localize, style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            
            
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
    func needToLogout(){
        let alert = UIAlertController(title: "Alert".localize, message: "You_have_changed_your_passwordyour_session_is_expired._Please_login_again".localize , preferredStyle: UIAlertController.Style.alert)
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

extension SettingVC {
    // TODO: Webservice For Get Content
    func callWsForGetContent(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            //  objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        //objWebServiceManager.StartIndicator()
        
        objWebServiceManager.requestGet(strURL: WsUrl.content ,Queryparams: nil, body: nil, strCustomValidation: "", success: {response in
            print(response)
            
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"
            {
                let dict  = response["data"] as? [String:Any]
                
                if let content = dict?["content_url"] as? [String:Any]{
                    
                    if let faq = content["how_to_work_url"]as? String{
                        self.strHowtoWork = faq
                    }
                    if let policy = content["privacy_policy_url"]as? String{
                        self.strPolicy = policy
                    }
                    if let term = content["terms_conditions_url"]as? String{
                        
                        self.strTermsCondition = term
                    }
                }
                
                
            }else
            {
                objAlert.showAlert(message:message ?? "", title: kAlert.localize, controller: self)
            }
        }, failure: { (error) in
            print(error)
            // objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title:kAlert.localize, controller: self)
            
        })
        
    }
    // TODO: Webservice For Notification Status
    
    
    func callWsForNotificationStatus(strStatus:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param = [String:Any]()
        
        
        param = [ "notification_status": strStatus ]
        
        print(param)
        
        
        objWebServiceManager.requestPut(strURL: WsUrl.setNotificationStatus, Queryparams:[:], body:param,strCustomValidation: "", success: {response in
            
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
                       

                if  self.strStatus == "0" {
                    objAppShareData.UserDetail.strPushAlertStatus = "0"
                   // self.imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
                    self.imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
                    self.notificationStatus = "0"

                }else{
                   objAppShareData.UserDetail.strPushAlertStatus = "1"
                   // self.imgToggle.image = #imageLiteral(resourceName: "OFF_TOGGLE_ICO")
                    self.imgToggle.image = #imageLiteral(resourceName: "ON_TOGGLE_ICO")
                    self.notificationStatus = "1"


                }
                
             //   print(" strPushAlertStatus in api is \(objAppShareData.UserDetail.strPushAlertStatus)")

                
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
    
    // TODO: Webservice For Change Password

    func callWsForChangePassword(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
                
        param = [
            WsParam.oldPassword: self.txtOldPassword.text ?? "" ,
            WsParam.newPassword: self.txtNewPassword.text ?? "" ,
            WsParam.confirmPassword: self.txtConfirmPassword.text ?? ""
            ] as [String : Any]
        
        print(param)
        self.vwBlur.isHidden = true
        objWebServiceManager.requestPost(strURL: WsUrl.changePassword, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
            // objAlert.showAlertCallOneBtnAction(btnHandler: "Ok".localize, title: kAlert.localize, message: message ?? "", controller: self ){
                if message == "The old and new password should not be the same.".localize{
                                  self.resetAll()
                    }
//                else if message == "Your password has been updated successfully.".localize || message == "Your password has been updated successfully."{
//                                    self.needToLogout()
//                        }
                else{
                    self.needToLogout()

                }
            } else {
                objAlert.showAlertCallOneBtnAction(btnHandler: "OK".localize, title: "Alert".localize, message: message ?? "", controller: self ){
                    
                    if message == "The old and new password should not be the same.".localize || message == "The old and new password should not be the same."{
                        self.txtOldPassword.text = ""
                        self.txtNewPassword.text = ""
                        self.txtConfirmPassword.text = ""
                    }
                }
            }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: "Alert".localize, controller: self)
        })
    }
    
    
    // TODO: Webservice For Change Password
    func callWsForChangelanguage(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        var param: [String: Any] = [:]
        let selectedLanguage  = LocalizationSystem.sharedInstance.getLanguage()

        param = [
            WsParam.language: selectedLanguage,
            ] as [String : Any]
        print(param)
        objWebServiceManager.StartIndicator()
                        
        self.vwBlur.isHidden = true
        objWebServiceManager.requestPost(strURL: WsUrl.ChangeLanguage, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            
            if status == "success"{
               
            
            } else {
                
                objAlert.showAlert(message:message ?? "", title: "Alert".localize, controller: self)

                      }
            
        }, failure: { (error) in
            print(error)
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message:kErrorMessage.localize, title: "Alert".localize, controller: self)
        })
    }
    
    
    
    
}
extension SettingVC: FilterBottomSheetVCDelegate{
    func showBotttomSheet(arr : Array<Any>, str: String ){
        
        let sb = UIStoryboard.init(name: "Restaurant", bundle:Bundle.main)
        let vc = sb.instantiateViewController(withIdentifier:"FilterBottomSheetVC") as! FilterBottomSheetVC
        vc.arrBottom = arr as! [FilterModel]
        vc.strHeader = str
        vc.modalPresentationStyle = .overCurrentContext
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
    
    //MARK: step 6 finally use the method of the contract
    func sendDataToFirstViewController(arrId:[Int], arrName:[String]) {

        let strLanguageId = (arrId.map{String($0)}).joined(separator: ",")
        print("strLanguageId is \(strLanguageId)")
        let strLanguageName = (arrName.map{String($0)}).joined(separator: ",")
        print("strLanguageName is \(strLanguageName)")
        objAppShareData.arrSelectedLanguageId = arrId
        objAppShareData.arrSelectedLanguageName = arrName

        
        if strLanguageId == "2" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "es")
           
            UserDefaults.standard.set("es", forKey: "Selectdlanguage") //setObject
            self.localization()
        //  objAppDelegate.loginStatusCheck()
        }else{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UserDefaults.standard.set("en", forKey: "Selectdlanguage") //setObject
            self.localization()
           // objAppDelegate.loginStatusCheck()
        }
        
        self.callWsForChangelanguage()
   
    }
}
