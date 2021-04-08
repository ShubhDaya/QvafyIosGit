//
//  ViewController.swift
//  Qvafy
//
//  Created by IOS-Aradhana-cat on 02/06/20.
//  Copyright © 2020 IOS-Aradhana-cat. All rights reserved.
//

import UIKit

class LoginVC: UIViewController , UITextFieldDelegate , UIGestureRecognizerDelegate{
    
    //MARK: - Outlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var imgPasswordHideShow: UIImageView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    
    // Localization Outlets -
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblLoginHeader: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassWord: UILabel!
    @IBOutlet weak var btnForgotPasswotrd: UIButton!
    @IBOutlet weak var lblDontHaveAccount: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    
    //MARK: - Variables

    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewEmail.setCornerRadiusQwafy(vw: self.viewEmail)
        self.viewPassword.setCornerRadiusQwafy(vw: self.viewPassword)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        self.Localization()
//        self.txtEmail.text = "customer@gmail.com"
//        self.txtPassword.text = "123456"
    }
    
    //MARK: - Functions
    
    func validationForSignIn(){
        
        self.txtEmail.text = self.txtEmail.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        self.txtPassword.text = self.txtPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let strPassword = self.txtPassword.text?.count ?? 0
        let isValidPassword = objValidationManager.ValidPassWord8digit(with: txtPassword.text ?? "")
    
        if self.txtEmail.text?.isEmpty == true{
            objAlert.showAlert(message: BlankEmail.localize, title: kAlert.localize, controller: self)
        }
        else if !objValidationManager.validateEmail(with: self.txtEmail.text ?? ""){
            objAlert.showAlert(message: ValidEmail.localize, title: kAlert.localize, controller: self)

        }
        else if self.txtPassword.text?.isEmpty == true{
            objAlert.showAlert(message: BlankPassword.localize, title: kAlert.localize, controller: self)
        }else if !isValidPassword {
            objAlert.showAlert(message: validPassword8Digit.localize, title: kAlert.localize, controller: self)
        }else{
            //   objAlert.showAlert(message: "Under Development", title: kAlert, controller: self)
            self.callWsForLogin()
        }
    }
    //MARK: Localization Method -
    func Localization(){
        self.lblEmail.text = "Email".localize
        self.lblPassWord.text = "Password".localize
        self.lblLoginHeader.text = "Login".localize
        self.lblDontHaveAccount.text = "Don't_have_an_account_?".localize
        self.txtEmail.placeholder = "Enter_email".localize
        self.txtPassword.placeholder = "Enter_password".localize
        self.btnSignUp.setTitle("Sign_Up".localize, for: .normal)
        self.btnForgotPasswotrd.setTitle("Forgot_your_password?".localize, for: .normal)
        
//
//        self.txtEmail.attributedPlaceholder = NSAttributedString.attributedPlaceholderString(string: "Enter_email".localize)
//
//        self.txtPassword.attributedPlaceholder = NSAttributedString.attributedPlaceholderString(string: "Enter_password".localize)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail{
          // self.txtEmail.resignFirstResponder()
            self.txtPassword.becomeFirstResponder()
        }else if textField == self.txtPassword{
            self.txtPassword.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if textField == txtPassword{
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
    
    //MARK: - Button Actions
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
        // handling code
    }
    
    @IBAction func btnPasswordHideShow(_ sender: UIButton) {
        if self.imgPasswordHideShow.image == #imageLiteral(resourceName: "show_view_ico"){
            self.imgPasswordHideShow.image = #imageLiteral(resourceName: "hide_view_ico")
            self.txtPassword.isSecureTextEntry = true
        }else{
            self.imgPasswordHideShow.image = #imageLiteral(resourceName: "show_view_ico")
            self.txtPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.txtEmail.text = ""
        self.txtPassword.text = ""

    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        self.view.endEditing(true)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.txtEmail.text = ""
        self.txtPassword.text = ""
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        self.view.endEditing(true)
        self.validationForSignIn()
        
    }
    
}

extension LoginVC {
    
    func callWsForLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.StopIndicator()
            objAlert.showAlert(message: NoNetwork.localize , title: kAlert.localize , controller: self)
            return
        }
        objWebServiceManager.StartIndicator()
        
        var param: [String: Any] = [:]
        param = [
            WsParam.email: self.txtEmail.text ?? "",
            WsParam.password: self.txtPassword.text ?? "",
            WsParam.deviceToken:deviceToken!
            ] as [String : Any]
        
        print(param)
        
        objWebServiceManager.requestPost(strURL: WsUrl.login, params: param, strCustomValidation: "", showIndicator: false, success: {response in
            print(response)
            objWebServiceManager.StopIndicator()
            let status =   (response["status"] as? String)
            let message =  (response["message"] as? String)
            var profileComplete = ""
            
            if status == "success"
            {
                let dic  = response["data"] as? [String:Any]
                
                
                //  if let user_details = dic!["user_detail"] as? [String:Any]{
                
                let user_details  = dic!["user_detail"] as? [String:Any]
                

                
                objAppShareData.saveDataInDeviceLogin(dict: user_details!)

                let onBoardingStep = user_details!["onboarding_step"]
                let role = user_details!["role"]
                
                
                if (user_details!["account_number"]as? String) != nil{
                    UserDefaults.standard.setValue(user_details?["account_number"], forKey: UserDefaults.KeysDefault.kAccountNo)
                    print("account_number in login ")
                }
                
                
                if let free = user_details!["profile_complete"]as? String{
                    profileComplete = free
                    
                    print("in check profileComplete is \(profileComplete)")
                    
                }
                
                
                self.checkOnBoardingSteps(OnBoardingstep:onBoardingStep as! String,role: role as! String, ProfileCompleted: profileComplete , dict: user_details!)
                
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
    
    func checkOnBoardingSteps(OnBoardingstep: String , role:String, ProfileCompleted:String, dict : [String:Any]){
        
        if OnBoardingstep == "1" && ProfileCompleted == "0"{
            self.NavigateToUserRole()
        }else if OnBoardingstep == "2"{
            if ProfileCompleted == "0"{
                self.NavigationToDriverRole()
            }else{
                objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: dict)
                objAppShareData.fetchUserInfoFromAppshareData()
                objAppShareData.saveUserDetailsOnFireBase()
                 
                if role == "1"{
                    objAppDelegate.showCustomerTabbar()
                     objAppDelegate.observeProductMessages()
                    
                    
                }
         
            }
        }else if OnBoardingstep == "3" && ProfileCompleted == "0"{
            // deepak
            if role == "2"{
                self.NavigateToBasicInfo()
            }else{
                self.NavigationToVehicleRole()
            }
            // deepak
        }else if OnBoardingstep == "4"{
            self.NavigationToBankDetail()

        }
        else if OnBoardingstep == "5" && ProfileCompleted == "0" {
            self.NavigationToBankDetail()
        }else if OnBoardingstep == "5" && ProfileCompleted == "1" {
            objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: dict)
            objAppShareData.fetchUserInfoFromAppshareData()
            objAppShareData.saveUserDetailsOnFireBase()
            if role == "2"{
                objAppDelegate.showTexiDriverTabbar()
            }else{
                objAppDelegate.showFoodDeliveryTabbar()
            }
            objAppDelegate.observeProductMessages()
        }
        

    }
    
    func NavigateToUserRole(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UserRoleVC") as! UserRoleVC
        detailVC.isFromLogin = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func NavigateToBasicInfo(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "BasicInfoVC") as! BasicInfoVC
        detailVC.isFromLogin = true
        // detailVC.strDriverType = step
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func NavigationToDriverRole(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UserRoleDriverVC") as! UserRoleDriverVC
        detailVC.isFromLogin = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    func NavigationToVehicleRole(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "UserRoleVehicleVC") as! UserRoleVehicleVC
        detailVC.isFromLogin = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func NavigationToBankDetail(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = sb.instantiateViewController(withIdentifier: "AddBankDetailVC") as! AddBankDetailVC
         detailVC.isFromLogin = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
